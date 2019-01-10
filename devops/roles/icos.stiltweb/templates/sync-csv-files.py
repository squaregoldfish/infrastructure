#!/usr/bin/python3
# Split the large csv files output by stilt into small ones for use by stiltweb

from concurrent import futures
import collections
import csv
import os
import re
import sys
import datetime


# Write files here.
STILTWEB_SLOTS = '{{ stiltweb_statedir }}/slots'
# The date id column used by stilt start at this date.
ORIGIN = datetime.date(1960, 1, 1)
STILT_DATE_ID_SLOTS = {"0": "00", "125": "03", "25": "06", "375": "09",
                       "5": "12", "625": "15", "75": "18", "875": "21"}


def parse_date_id(s):
    """Parse stilt date/slot string into python objects


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
    slot = STILT_DATE_ID_SLOTS[nslot]
    return date, slot


SyncResult = collections.namedtuple(
    'SyncResult', ['stationdir', 'nwritten', 'nmissing', 'nalready',
                   'nnoexist'])


def extract_csv_for_station(stationdir):
    # matches 'stiltresult2007x62.91Nx027.66Ex00176.csv'
    # but not 'stiltresult2007x62.91Nx027.66Ex00176_2.csv'
    csvre = re.compile(r'stiltresult(\d{4})x(.*x\d+)_(\d+).csv')
    nmissing = 0
    nnoexist = 0
    nalready = 0
    nwritten = 0
    for f in sorted(os.scandir(stationdir), key=lambda k: k.name):
        m = csvre.match(f.name)
        if not m:
            continue
        year, coords, suffix = m.groups()
        with open(os.path.join(stationdir, f.name)) as csvfile:
            # header looks like:
            #  "ident" "latstart" "lonstart" "aglstart"
            # data looks like
            #  17349.25 69.28 16.01 5
            csvreader = csv.reader(csvfile, delimiter=' ')
            header = None
            for n, row in enumerate(csvreader):
                if n == 0:
                    header = row
                    continue
                date, slot = parse_date_id(row[0])
                # 2007x12x31x00
                slotname = "%sx%02dx%02dx%s" % (date.year, date.month,
                                                date.day, slot)
                # /slots/55.35Nx017.22Ex00028/2007/12/2007x12x31x00
                slotdir = os.path.join(STILTWEB_SLOTS, coords,
                                       "%s" % date.year,
                                       "%02d" % int(date.month),
                                       slotname)
                if not slotdir:
                    nmissing += 1
                    continue
                if not os.path.exists(slotdir):
                    nnoexist += 1
                    continue
                destcsv = os.path.join(slotdir, 'csv')
                if os.path.exists(destcsv):
                    nalready += 1
                    continue
                with open(destcsv, 'w') as f:
                    writer = csv.writer(f, delimiter=' ')
                    writer.writerow(header)
                    writer.writerow(row)
                    nwritten += 1
    return SyncResult(stationdir, nwritten, nmissing, nalready, nnoexist)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: bulk-create-csv-files CSVROOT")
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for station in os.scandir(sys.argv[1]):
            if not station.is_dir():
                continue
            future = executor.submit(extract_csv_for_station,
                                     os.path.join(sys.argv[1], station.name))
            todos[future] = station.name
        for future in futures.as_completed(todos):
            item = todos[future]
            result = future.result()
            print(result)
