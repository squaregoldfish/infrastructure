#!/usr/bin/python3
# Find slots where the 'csv' file is missing.
#
# Syncing of old stilt data to the new stiltweb directory layout is a long and
# winding process. Sometimes it goes wrong and ends up creating slot
# directories which are missing the 'csv' file. That will cause no end of
# upset. This script will recurse down the {{ stiltweb_statedir }}/slots
# directory and look for these directories.
#
# It will display a nice looking output along a shell script that when
# run removes the troublesome directories.


import concurrent.futures
import collections
import os

STATIONS_ROOT = "{{ stiltweb_statedir }}/slots"
CORRECT_PARTS = set(('csv', 'rdata', 'rdatafoot', 'foot'))
STATION_NAMES = {}

Result = collections.namedtuple(
    'Result', ['station', 'name', 'year', 'year_path', 'npresent', 'nmissing'])


def station_name(coordinates):
    if not STATION_NAMES:
        # elt ~ '/disk/data/stiltweb/slots/62.91Nx027.66Ex00176'
        for elt in os.scandir("{{ stiltweb_statedir }}/stations"):
            if elt.is_dir() and elt.is_symlink():
                target = os.readlink(elt)
                # 62.91Nx027.66Ex00176 => PUI
                STATION_NAMES[os.path.basename(target)] = elt.name
    return STATION_NAMES.get(coordinates, None)


def do_station_year(station, year):
    npresent = 0
    nmissing = 0
    missing = []
    year_path = os.path.join(STATIONS_ROOT, station, year)
    for month in os.scandir(year_path):
        for slot in os.scandir(month.path):
            if not slot.name.startswith(year) and slot.is_dir():
                continue
            parts = set(e.name for e in os.scandir(slot.path))
            lacks = CORRECT_PARTS - parts
            if len(lacks) == 0:
                npresent += 1
            elif lacks == {'csv'}:
                nmissing += 1
                missing.append(slot.path)
            else:
                raise AssertionError(lacks, parts)
    return Result(station, station_name(station), year, year_path,
                  npresent, nmissing)


with concurrent.futures.ProcessPoolExecutor() as executor:
    todos = []
    for station in os.scandir(STATIONS_ROOT):
        if not station.is_dir():
            continue
        for year in os.scandir(station.path):
            if not year.is_dir():
                continue
            future = executor.submit(do_station_year, station.name, year.name)
            todos.append(future)
    station_results = {}
    empty_stations = {}
    for future in concurrent.futures.as_completed(todos):
        result = future.result()
        if result.name is None:
            continue
        # By default, all station_results are considered "empty", i.e they
        # have no complete slots
        if result.station not in empty_stations:
            empty_stations[result.station] = result.name
        years = station_results.setdefault(result.name, {})
        assert result.year not in years
        years[result.year] = result
    troublesome_slots = []
    for station, years in sorted(station_results.items()):
        for n, (year, result) in enumerate(sorted(years.items())):
            if n > 0:
                station = ''
            print("%-6s %s\tpresent = %-4d. missing = %-4d" % (
                station, year, result.npresent, result.nmissing))
            # As long as a station has any complete slots, we'll keep it.
            if result.npresent > 0 and result.station in empty_stations:
                del empty_stations[result.station]
            if result.nmissing > 0:
                troublesome_slots.append(result.year_path)
    for c in troublesome_slots:
        print('rm -rf -- "%s"' % c)
    for station, name in empty_stations.items():
        print('rm -rf -- "{{ stiltweb_statedir }}/slots/%s"' % station)
        print('rm -rf -- "{{ stiltweb_statedir }}/stations/%s"' % name)
