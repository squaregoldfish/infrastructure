#!/usr/bin/python3
#
# Sync (by hardlinking!) stilt data from new-style slot-based directory layout
# - as used by stiltweb - to the classic stilt layout.
#
# Each new-style slot directory contain four files, but only three of those are
# synced by this script. Those three file - foot, rdata and rdatafoot - have a
# one-to-one mapping between new-style and old-style and can thus easily be
# hardlinked. The csv file however exists as one-line-per-file in the new-style
# structure and many-lines-per-file in the old-style and is not synced.
#
# This script will spawn one process per station. By default it only shows what
# would be synced, use '--help' for usage info. The script is designed to run
# as a systemd service, trigger by a (inotify-based) path trigger - this way
# one can have access to newly computed stilt data in the old-style layout.


import argparse
from concurrent import futures
import collections
import os
import re
import sys


NEW_ROOT = "{{ stiltweb_statedir }}"
OLD_ROOT = "{{ stiltweb_stiltdir }}"
STATION_DIR = os.path.join(NEW_ROOT, 'stations')
DEBUG = True


# UTILS

def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def same_fs(path1, path2):
    path1 = os.path.realpath(os.path.normpath(path1))
    path2 = os.path.realpath(os.path.normpath(path2))

    def get_mount(path):
        if os.path.ismount(path):
            return path
        return get_mount(os.path.dirname(path))

    return (os.path.exists(path1) and
            os.path.exists(path2) and
            get_mount(path1) == get_mount(path2))


# CREATE STATION OBJECTS

Station = collections.namedtuple(
    'Station', ['name', 'path', 'pos'])


def station_from_name(name, sdir=STATION_DIR):
    # /disk/data/stiltweb/stations/PUI
    path = os.path.join(sdir, name)
    if not os.path.exists(path):
        die("Could not find the '%s' station in %s" % (name, sdir))
    # /disk/data/stiltweb/slots/62.91Nx027.66Ex00176
    real = os.path.realpath(path)
    # 62.91Nx027.66Ex00176
    pos = os.path.basename(real)
    return Station(name, real, pos)


def list_stations(sdir=STATION_DIR):
    if not os.path.isdir(sdir):
        die('Expected "%s" to be a directory with station symlinks!' % sdir)
    for elt in os.scandir(sdir):
        # elt.path == '/disk/data/stiltweb/stations/PUI'
        # elt.name == 'PUI'
        if elt.is_symlink():
            # /disk/data/stiltweb/slots/62.91Nx027.66Ex00176
            path = os.path.realpath(elt)
            # 62.91Nx027.66Ex00176
            pos = os.path.basename(path)
            yield Station(elt.name, path, pos)


# LIST SLOTS

def list_slots(station):
    for year in os.scandir(station.path):
        if not (year.is_dir() and re.match('[0-9]+', year.name)):
            continue
        for month in os.scandir(year.path):
            if not (month.is_dir() and re.match('[0-9]+', month.name)):
                continue
            for slot in os.scandir(month.path):
                if not (slot.is_dir() and re.match('[0-9x]+', slot.name)):
                    continue
                yield (month.path, slot)


# SYNC A STATION

SyncResult = collections.namedtuple(
    'SyncResult', ['station', 'nslots', 'nsyncd', 'slotnames'])


def sync_station(station, dryrun=True, old_root=OLD_ROOT):
    fp_dir = os.path.join(old_root, 'Footprints', station.name)
    rd_dir = os.path.join(old_root, 'RData', station.name)

    if os.path.exists(fp_dir):
        fp_files = {e.path for e in os.scandir(fp_dir)}
    else:
        fp_files = set()
        if not dryrun:
            os.makedirs(fp_dir)

    if os.path.exists(rd_dir):
        rd_files = {e.path for e in os.scandir(rd_dir)}
    else:
        rd_files = set()
        if not dryrun:
            os.makedirs(rd_dir)

    nslots = 0
    nsyncd = 0
    slotnames = []

    new2old = (('foot%s_aggreg.nc', fp_dir, fp_files, 'foot'),
               ('.RDatafoot%s', fp_dir, fp_files, 'rdatafoot'),
               ('.RData%s', rd_dir, rd_files, 'rdata'))

    for (month, slot) in list_slots(station):
        nslots += 1
        # e.g '2007x12x29x12x69.28Nx016.01Ex00005'
        datepos = '%sx%s' % (slot.name, station.pos)
        didsync = False
        for old_name, old_dir, old_files, new_name in new2old:
            old_path = os.path.join(old_dir, old_name % datepos)
            if old_path in old_files:
                continue
            new_path = os.path.join(month, slot, new_name)
            assert(old_path.startswith(old_root))
            if not dryrun:
                os.link(new_path, old_path)
            didsync = True
        if didsync:
            nsyncd += 1
            slotnames.append(slot.name)
    return SyncResult(station, nslots, nsyncd, slotnames)


def sync_all_stations(stations, dryrun=True, verbose=True):
    print("Syncing %d stations." % (len(stations)))
    nsyncd = 0
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for station in stations:
            future = executor.submit(sync_station, station, dryrun)
            todos[future] = station
        for future in futures.as_completed(todos):
            station = todos[future]
            try:
                r = future.result()
                if r.nsyncd > 0:
                    if dryrun:
                        print("%6s - %-5d slots of which %5d needs linking" % (
                            r.station.name, r.nslots, r.nsyncd))
                    else:
                        print("%6s - %-5d slots of which %5d were linked" % (
                            r.station.name, r.nslots, r.nsyncd))
                    if verbose:
                        for slot in r.slotnames:
                            print(slot)
                    nsyncd += 1
            except Exception as e:
                print(future, "failed with", e)
    print("%d out of %d stations needed syncing" % (nsyncd, len(stations)))


# MAIN

if __name__ == '__main__':
    assert(os.path.isdir(NEW_ROOT))
    assert(os.path.isdir(OLD_ROOT))

    if not same_fs(NEW_ROOT, OLD_ROOT):
        die("%s and %s needs to be on the same filesystem" % (
            NEW_ROOT, OLD_ROOT))

    if os.getuid() == 0:
        die("Refusing to run as root, please run as the stiltweb user")

    p = argparse.ArgumentParser(
        description='Sync slots from %s to %s.' % (NEW_ROOT, OLD_ROOT))
    p.add_argument('stations', metavar='STATIONS', type=str, nargs='*',
                   help='Which stations to sync. Default is all stations')
    p.add_argument('--sync', dest='dryrun', action='store_false',
                   help='Really sync. Default is a dry run.')
    p.add_argument('--verbose', dest='verbose', action='store_true',
                   help='Output every single slot that needs syncing.')

    args = p.parse_args()
    if args.stations:
        stations = [station_from_name(n) for n in args.stations]
    else:
        stations = list(list_stations())

    sync_all_stations(stations, args.dryrun, args.verbose)
