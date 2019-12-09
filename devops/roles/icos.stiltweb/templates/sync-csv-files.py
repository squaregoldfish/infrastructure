#!/usr/bin/python3
# Sync csv from stilt to stiltweb.
#
# Split the large csv files output by stilt into small ones for use by
# stiltweb - overwriting the existing csv files.
#
# This script started its life as a way to populate stiltweb slots
# with csv files. The slots that existed back then only had three
# files (foot, rdata, rdatafoot) and needed a csv as well.
#
# These days all slots have csv files and newly created slots gets a
# csv as well. However, sometimes the csv files needs to be
# updated. This is done by running a classical stilt outside of
# stiltweb and then using this script to split the resulting large csv
# files into many small ones used by stiltweb.
#
# Once the stiltweb's csv files for a given station/year has been
# updated the stiltweb cache file for that station/year needs to be
# removed as well for the new csv files take effect.

from concurrent import futures
import collections
import csv
import glob
import os
import re
import sys
import datetime


# Write files here.
STILTWEB_STATIONS = '{{ stiltweb_statedir }}/stations'

# The date id column used by stilt start at this date.
ORIGIN = datetime.date(1960, 1, 1)
STILT_DATE_ID_SLOTS = {"0": "00", "125": "03", "25": "06", "375": "09",
                       "5": "12", "625": "15", "75": "18", "875": "21"}

# Make sure that we read the correct csv files, the following regexp:
#   matches 'stiltresult2007x62.91Nx027.66Ex00176_2.csv'
#   but not 'stiltresult2007x62.91Nx027.66Ex00176.csv'
MATCHING_CSV = re.compile(r'stiltresult(\d{4})x[^_]+_\d+.csv')

# This object serves as something to return to the process executor.
SyncResult = collections.namedtuple(
    'SyncResult', ['csvdir', 'nwritten', 'nnoexist', 'nskipped'])


def parse_date_id(s):
    """Parse stilt date/slot string into python objects

    Each slot is a decimal value which gives us the three-hour window
    since stilt's ORIGIN.

    >>> parse_date_id('17167.5')
    (datetime.date(2007, 1, 1), '12')
    >>> parse_date_id('20820.125')
    (datetime.date(2017, 1, 1), '03')
    """
    # '17167' => '17167.0'
    if '.' not in s:
        s += '.0'
    ndays, nslot = s.split('.')
    date = ORIGIN + datetime.timedelta(days=int(ndays))
    try:
        slot = STILT_DATE_ID_SLOTS[nslot]
    except KeyError:
        # This happens - presumably - if stilt has been run for another
        # resolution that three-hourly. nslot might look like '4583333333'.
        slot = None
    return date, slot


def remove_csv_cache_file(station, year):
    """Remove the stiltweb csv cache file for station/year.

    Stiltweb keeps a csv cache file (consisting of the 365*(24/3) ==
    2920 small csv files that makes up a station-year). When we update
    the individual csv files we need to remove the cache
    file. Stiltweb will automatically rebuild the cache file. This
    also has the benefit of making our update atomic.
    """
    cache_files = glob.glob(os.path.join(
        STILTWEB_STATIONS, station, year, "cache*.txt"))
    # Check our assumptions about cache files before removing any.
    assert len(cache_files) in (0, 1), cache_files
    if len(cache_files) > 0:
        os.unlink(cache_files[0])


def open_stilt_csv(path):
    # header looks like:
    #  "ident" "latstart" "lonstart" "aglstart"
    # data looks like
    #  17349.25 69.28 16.01 5
    reader = csv.reader(open(path), delimiter=' ')
    header = next(reader, None)
    return (header, reader)


def calculate_slotdir_path(station, row):
    """Calculate the correct stiltweb slot path for a csv row.

    The first field of each csv row is the date field, parse that and
    use it to index into stiltweb's directory tree.

    >>> calculate_slotdir_path('HEI', ['17349.25', '69.28', '16.01', '5'])
    '/disk/data/stiltweb/stations/HEI/2007/07/2007x07x02x06'
    """
    date, slot = parse_date_id(row[0])
    if slot is None:
        return None
    slotname = "%sx%02dx%02dx%s" % (date.year, date.month, date.day, slot)
    return os.path.join(STILTWEB_STATIONS,
                        station,
                        "%s" % date.year,
                        "%02d" % int(date.month),
                        slotname)


def extract_csv_for_station(csvdir, station):
    """Parse the large csv files for a station and write the small csv files.

    This is the main worker function for each spawned process.
    """
    nnoexist = 0
    nwritten = 0
    nskipped = 0
    for f in sorted(os.scandir(csvdir), key=lambda k: k.name):
        m = MATCHING_CSV.match(f.name)
        if not m:
            continue
        header, reader = open_stilt_csv(f.path)
        nwritten_save = nwritten
        for row in reader:
            slotdir = calculate_slotdir_path(station, row)
            if slotdir is None:
                nskipped += 1
                continue
            if not os.path.exists(slotdir):
                nnoexist += 1
                continue
            destcsv = os.path.join(slotdir, 'csv')
            with open(destcsv, 'w') as f:
                writer = csv.writer(f, delimiter=' ')
                writer.writerow(header)
                writer.writerow(row)
                nwritten += 1
        if nwritten > nwritten_save:
            remove_csv_cache_file(station, m.group(1))
    return SyncResult(csvdir, nwritten, nnoexist, nskipped)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: sync-csv-files CSVROOT")
        sys.exit(0)
    stations = []
    for csvdir in os.scandir(sys.argv[1]):
        if not csvdir.is_dir():
            continue
        assert os.path.exists(os.path.join(STILTWEB_STATIONS, csvdir.name))
        stations.append(csvdir)
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for csvdir in stations:
            future = executor.submit(extract_csv_for_station,
                                     csvdir.path, csvdir.name)
            todos[future] = csvdir.name
        for future in futures.as_completed(todos):
            result = future.result()
            print(result)
