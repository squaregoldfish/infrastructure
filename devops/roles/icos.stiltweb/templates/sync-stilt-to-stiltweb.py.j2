#!/usr/bin/python3
# Sync from old-style stilt to new-style stiltweb.
#
# Each new-style stiltweb slot consists of four files. Three of these are
# hardlinked from the old-style directory tree, only the csv file is created.
#
# Old-style directory tree (output by the original STILT software)
#   /old_root/Footprints/ARR/foot2007x07x02x09x69.28Nx016.01Ex00005_aggreg.nc
#   /old_root/Footprints/ARR/.RDatafoot2007x07x02x09x69.28Nx016.01Ex00005
#   /old_root/RDATA/ARR/.RData2007x07x02x09x69.28Nx016.01Ex00005
#   /old_root/Results/ARR/stiltresult2007x69.28Nx016.01Ex00005_x.csv
#
# New-style directory tree (used by stiltweb)
#   /new_root/55.37Nx007.34Wx00003/2007/01/2007x01x27x21/foot
#   /new_root/55.37Nx007.34Wx00003/2007/01/2007x01x27x21/rdatafoot
#   /new_root/55.37Nx007.34Wx00003/2007/01/2007x01x27x21/rdata
#   /new_root/55.37Nx007.34Wx00003/2007/01/2007x01x27x21/csv
#

from concurrent import futures
import collections
import contextlib
import csv
import datetime
import doctest
import os
import re
import sys


NEW_ROOT = "/disk/data/stiltweb/slots"
OLD_ROOT = "/disk/data/stilt"

# The date id column used by stilt start at this date.
ORIGIN = datetime.date(1960, 1, 1)
STILT_DATE_ID_SLOTS = {"0": "00", "125": "03", "25": "06", "375": "09",
                       "5": "12", "625": "15", "75": "18", "875": "21"}

DEBUG = True


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def debug(msg):
    if DEBUG:
        print(msg)


def same_fs(path1, path2):
    """Returns True if both paths are on the same file system.

>>> same_fs('/', '/proc')
False
>>> same_fs('/usr', '/etc')
True
    """
    path1 = os.path.realpath(os.path.normpath(path1))
    path2 = os.path.realpath(os.path.normpath(path2))

    def get_mount(path):
        if os.path.ismount(path):
            return path
        return get_mount(os.path.dirname(path))

    return (os.path.exists(path1) and
            os.path.exists(path2) and
            get_mount(path1) == get_mount(path2))


def parse_date_id(s):
    """Parse a csv stilt date/slot string into python objects


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


def slotdir_to_dateid(slot):
    # '2014x07x14x21'
    year, month, day, hour = slot.split('x')
    date = datetime.date(year=int(year), month=int(month), day=int(day))
    diff = date - ORIGIN
    return str(diff.days + (int(hour) / 24))


# CSV PARSING

def extract_csv_for_station(stationdir):
    # matches 'stiltresult2007x62.91Nx027.66Ex00176_2.csv'
    # but not 'stiltresult2007x62.91Nx027.66Ex00176.csv'
    csvre = re.compile(r'stiltresult(\d{4})x(.*x\d+)_(\d+).csv')
    slots = {}
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
                slots[slotname] = (header, row)
    return slots


# Match an old-style foot print filename. Example:
#  foot2012x12x01x00x56.10Nx013.42Ex00150_aggreg.nc
FOOT_RE = re.compile(r"""
^foot        # prefix
(            # group 1 - whole date-position
(            # group 2 - whole date
(\d{4})x     # group 3 - year
(\d\d)x      # group 4 - month
(\d\d)x      # group 5 - day
(\d\d)       # group 6 - 3 hour interval
)            # end group 2 (whole date)
x            # separator between date and position
(            # group 7 - the position
(\d+\.\d+)   # group 8 - latitude
([NS])       # group 9 - north-south
x            # separator before longitude
(\d+\.\d+)   # group 10 - longitude
([EW])       # group 11 - east-west
x            # separator before height
(\d+)        # group 12 - height
)            # end group 7 (position)
)            # end of group 1 (whole date-position)
_aggreg\.nc$ # suffix
""", re.VERBOSE)


Footprint = collections.namedtuple(
    'Footprint', ['filename', 'datepos', 'date', 'year', 'month', 'day',
                  'hour', 'pos', 'latitude', 'northsouth', 'longitude',
                  'eastwest', 'height'])


def parse_footprint(foot):
    """Parse a old-style footprint filename.

>>> f = 'foot2012x12x01x00x56.10Nx013.42Ex00150_aggreg.nc'
>>> parse_footprint(f)
Footprint(filename='foot2012x12x01x00x56.10Nx013.42Ex00150_aggreg.nc', datepos='2012x12x01x00x56.10Nx013.42Ex00150', date='2012x12x01x00', year='2012', month='12', day='01', hour='00', pos='56.10Nx013.42Ex00150', latitude='56.10', northsouth='N', longitude='013.42', eastwest='E', height='00150')
>>> parse_footprint('hello?')
'hello?' did not parse as a footprint file name
>>>
    """
    m = FOOT_RE.match(foot)
    if not m:
        debug("'%s' did not parse as a footprint file name" % foot)
        return None
    return Footprint(foot, *m.groups())


OldSlot = collections.namedtuple(
    'OldSlot', ['root', 'station', 'foot', 'f_foot', 'f_rdata', 'f_rdatafoot'])


def list_slots(station, root=OLD_ROOT):
    """Yield OldSlots() for the given station.

>>> list_slots('HEI') # doctest: +ELLIPSIS
<generator object list_slots at ...>
    """
    fp_dir = os.path.join('Footprints', station)
    fp_files = {e.name: e for e in os.scandir(os.path.join(root, fp_dir))}

    rd_dir = os.path.join('RData', station)
    rd_files = {e.name: e for e in os.scandir(os.path.join(root, rd_dir))}

    valid_hours = set(STILT_DATE_ID_SLOTS.values())

    def pop_file(fname, files, dname):
        """Run some sanity checks on the file and pop it from the dict.
        """
        e = files.pop(fname, None)
        if e is None:
            debug('Not found - %s' % fname)
        elif not e.is_file():
            debug('Not a file - %s' % fname)
        elif e.stat(follow_symlinks=False).st_size == 0:
            debug('Is empty - %s' % fname)
        else:
            return os.path.join(root, dname, fname)

    # There'll be two kinds of files in the Footprints/STATION dirs:
    #   .RDatafoot2007x12x29x12x69.28Nx016.01Ex00005
    #   foot2007x12x31x21x69.28Nx016.01Ex00005_aggreg.nc
    # Then there'll be a third file in the RData/Station dir:
    #   .RData2007x12x31x21x69.28Nx016.01Ex00005
    # Iterate over all the names in the Footprints directory.
    for f_name in list(fp_files.keys()):
        # Each slot consists of three files, we only build slots starting with
        # the ones starting with "foot"
        if not f_name.startswith('foot'):
            continue
        # Parse the filename into a Footprint object. We then use the
        # date/position string part to find the other two files in the slot.
        foot = parse_footprint(f_name)
        if not foot:
            continue
        if foot.hour not in valid_hours:
            continue
        f_foot = pop_file(f_name, fp_files, fp_dir)
        f_rdata = pop_file('.RData%s' % foot.datepos, rd_files, rd_dir)
        f_rdatafoot = pop_file('.RDatafoot%s' % foot.datepos, fp_files, fp_dir)
        if not (f_rdata and f_rdatafoot):
            continue
        yield OldSlot(root, station, foot, f_foot, f_rdata, f_rdatafoot)

    n = sum(1 for n in fp_files if n.startswith('foot'))
    if n:
        debug("There are %s foot files in %s with no corresponding"
              " .RData or .RDatafoot files" % (n, fp_dir))
    if rd_files:
        debug("There are %s .RData files in %s with no corresponding"
              " foot or .RDatafoot files" % (len(rd_files), rd_dir))


def sync_single_station(station, old_root=OLD_ROOT, new_root=NEW_ROOT):
    assert(os.path.exists(new_root))
    assert(os.path.exists(old_root))

    def makedirs_below_new_root(d, **kw):
        """Run os.makedirs() while making sure we're in the right spot.
        """
        d = os.path.realpath(os.path.normpath(d))
        assert d.startswith(new_root), (d, new_root)
        os.makedirs(d, **kw)

    month_dirs = {}

    def should_store_in_which_month_dir(foot):
        """Return new parent directory for foot or None if it already exists.
        """
        assert 0, "These lines were the result of a one-off-hack"
        assert station in ["BG3", "GAR030", "GAR344", "HPB131", "KIT100"]
        if station == "BG3" and foot.year != "2014":
            return None
        if station == "GAR030" and foot.year != "2012":
            return None
        if station == "GAR344" and foot.year != "2012":
            return None
        if station == "HPB131" and foot.year != "2017":
            return None
        if station == "KIT100" and foot.year != "2007":
            return None

        # new_root/52.29Nx017.05Ex00100/2012/12
        mdir = os.path.join(new_root, foot.pos, foot.year, foot.month)
        try:
            mslots = month_dirs[mdir]
        except KeyError:
            if not os.path.exists(mdir):
                makedirs_below_new_root(mdir)
            mslots = {e.name: e for e in os.scandir(mdir)}
            month_dirs[mdir] = mslots
        # Is there already a directory named '2012x12x01x18'? That means that
        # the slot already exists, this will be the common case.
        if foot.date not in mslots:
            return mdir

    @contextlib.contextmanager
    def make_new_slot_dir_atomically(mdir, date):
        """Returns a temp slot dir and rename it afterwards.
        """
        # new_root/52.29Nx017.05Ex00100/2012/12/2012x12x01x18
        slot_dir = os.path.join(mdir, date)
        slot_tmp = slot_dir + '.tmp'
        makedirs_below_new_root(slot_tmp, exist_ok=True)
        yield slot_tmp
        os.rename(slot_tmp, slot_dir)
        month_dirs[mdir][slot_dir] = True

    def paranoid_hard_link(old_path, slot_dir, new_name):
        new_path = os.path.join(slot_dir, new_name)
        assert(old_path.startswith(old_root))
        assert(new_path.startswith(new_root))
        os.link(old_path, new_path)

    csv_dir = os.path.join(old_root, 'Results_1A4', station)
    if not os.path.exists(csv_dir):
        debug("Expected csv dir %s to exist" % csv_dir)
        return

    all_csv = extract_csv_for_station(csv_dir)
    if not all_csv:
        debug("%s existed but no csv data was found" % csv_dir)

    cnt = 0
    for slot in list_slots(station, old_root):
        mdir = should_store_in_which_month_dir(slot.foot)
        if mdir is None:
            continue
        try:
            header, row = all_csv[slot.foot.date]
        except KeyError:
            debug("No csv for station %s and slot '%s'" % (
                station, slot.foot.date))
            continue
        with make_new_slot_dir_atomically(mdir, slot.foot.date) as slot_dir:
            for old_path, new_name in ((slot.f_foot, 'foot'),
                                       (slot.f_rdata, 'rdata'),
                                       (slot.f_rdatafoot, 'rdatafoot')):
                paranoid_hard_link(old_path, slot_dir, new_name)
            with open(os.path.join(slot_dir, 'csv'), 'w') as f:
                writer = csv.writer(f, delimiter=' ')
                writer.writerow(header)
                writer.writerow(row)
        cnt += 1
    return cnt


def sync_all_stations(stations):
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for station_name in stations:
            future = executor.submit(sync_single_station, station_name)
            todos[future] = station_name
        for future in futures.as_completed(todos):
            item = todos[future]
            try:
                n_slots = future.result()
                print(item, 'succeeded, synced', n_slots)
            except Exception as e:
                print(item, "failed with", e)


if __name__ == '__main__':
    assert 0, "This script serves as a starting point for one-off-hacks"
    doctest.testmod()
    if not same_fs(NEW_ROOT, OLD_ROOT):
        die("%s and %s needs to be on the same filesystem" % (
            NEW_ROOT, OLD_ROOT))
    sync_all_stations(['BG3', 'GAR030', 'GAR344', 'HPB131', 'KIT100'])
