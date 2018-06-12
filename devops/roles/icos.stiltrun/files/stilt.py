#!/usr/bin/python3

"""A frontend for the STILT docker container.

The driver for the development of this program was two-fold:
  + To contain the messiness involved in running the STILT docker
    container. Setting up output directories, collecting log output etc.
  + To act as a helper when doing a distributed STILT simulation.

The first point is accomplished by using a "run directory"; for each run of the
program we create a temporary directory, within we to host subdirectories that
are then mounted as volumes within the docker container. The container is then
started and output is generated within those directories. After the container
has finished executing and the output extracted, the run directory is removed.

By the second point (a distributed STILT simulation) is meant using several
different machines to run a single simulation. Currently STILT is meant to be
run on a single machine and a STILT run can take several weeks of computer
time. We hope to get STILT to work in a distributed fashion by:
  1. Getting STILT to tell us what timeslots (3-hour intervals) are contained
     within a given time interval. This functionality is already available in
     this program is the 'calcslots' subcommand.
  2. Starting a STILT simulation for only a single timeslot and then running
     many of these in parallell on many physical machines.
  3. Merging the results back together.
"""

import collections
import datetime
import glob
import os
import pwd
import re
import shutil
import subprocess
import sys
import tempfile

# GLOBALS

# A directory of symlinks like 'HEL -> ../slots/54.18Nx007.90Ex00015'
# FIXME - use host-specific paths via ansible
STATION_DIR = "/disk/data/stiltweb/stations"

# Classic stilt data
# FIXME - use host-specific paths via ansible
STILT_DATA_DIR = "/disk/data/stilt"
STILT_INPUT_DIR = os.path.join(STILT_DATA_DIR, 'Input')

METFILES_DIR = os.path.join(STILT_DATA_DIR, "Input/Metdata/Europe2")
# FIXME - configure this during deployment
STILT_IMAGE = 'stiltcustom'
RUN_DIRECTORY = os.path.join(os.environ['HOME'], '.stiltruns')
DEBUG_FILES = []
DEFAULT_SITE_NAME = 'XXX'


# HELPERS

def run(*args, **kwargs):
    return subprocess.check_output(args, **kwargs)


def lines(*args, **kwargs):
    return [l.strip() for l in
            run(*args, **kwargs).decode('utf-8').split('\n')]


def debug(msg):
    s = '%s - %s' % (datetime.datetime.now().isoformat(), msg)
    for f in DEBUG_FILES:
        print(s, file=f)
        f.flush()


def start_debug_log(rundir):
    f = open(os.path.join(rundir, 'debug.log'), 'a')
    # Outputting a separator makes the log easier to read when we're
    # reusing a run directory (and its logfile).
    print("\n" + "-- New invocation of stilt", file=f)
    DEBUG_FILES.append(f)
    debug("cwd = %s" % os.getcwd())
    debug("cmd = %s" % ' '.join(map(str, sys.argv)))


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def users_id_and_gid():
    pw = pwd.getpwuid(os.getuid())
    return pw.pw_uid, pw.pw_gid


def rundir_lookup_dwim(s):
    if not os.path.isdir(s):
        if s.isdigit():
            g = glob.glob('%s/*-%s' % (RUN_DIRECTORY, s))
        else:
            g = glob.glob('%s/*%s*' % (RUN_DIRECTORY, s))
        if len(g) > 1:
            die("Rundir description '%s' matches more than one directory." % s)
        if len(g) == 1 and os.path.isdir(g[0]):
            return g[0]
    else:
        p = os.path.abspath(s)
        b = os.path.basename(p)
        if b.startswith('stilt-run-') and\
           os.path.isfile(os.path.join(p, 'debug.log')):
            return p
    die("Cannot find rundir '%s'" % s)


def rundir_is_existing(d):
    d = os.path.abspath(d)
    if not os.path.isdir(d):
        die("%s must be a run directory" % d)
    for s in ('logs', 'output'):
        p = os.path.join(d, s)
        if not os.path.isdir(p):
            die("expected to find the directory %s" % p)
    return d


# ARGUMENT PARSING

def parse_setup_arg(arg):
    m = re.match(r"--setup=(.+)", arg)
    if not m:
        return None
    setup = m.group(1)
    if not (os.path.isfile(setup) and os.access(setup, os.X_OK)):
        die("%s is not an executable file" % setup)
    if not (setup.startswith('.') or setup.startswith('/')):
        setup = './' + setup
    return setup


def parse_image_arg(arg):
    m = re.match(r"--image=(.+)", arg)
    if not m:
        return None
    return m.group(1)


def parse_rundir_arg(arg):
    m = re.match(r"--rundir=(.+)", arg)
    if not m:
        return None
    return rundir_is_existing(m.group(1))


def find_arg(args, parse_func, default=None):
    result = None
    args = args[:]
    for i in range(len(args)):
        result = parse_func(args[i])
        if result is not None:
            args.pop(i)
            break
    if result is None:
        result = default
    return result, args


# CONTAINER CLASS

class STILTContainer:

    """Represent a STILT Docker container.

    Only a single instance is created from this class during each run.
    """

    Volume = collections.namedtuple(
        'Volume', ['host_dir', 'cont_dir', 'readonly', 'chown'])

    setup = None
    rundir = None
    keep_rundir = False
    image = None
    name = None

    def __init__(self):
        self._run_dir = self.rundir
        if self.rundir is not None:
            self.keep_rundir = True
        self._volumes = []
        self._cid = None
        self._setup_rundir()

    # PREPARATION
    def _setup_rundir(self, base=RUN_DIRECTORY):
        # We're gonna reuse an earlier run directory
        if self._run_dir is not None:
            assert(os.path.isdir(self._run_dir))
        else:
            if not os.path.isdir(base):
                os.mkdir(base)
                debug("Created the %s directory" % base)
            self._run_dir = make_run_dir()
            debug("Created directory %s" % self._run_dir)
        start_debug_log(self._run_dir)
        if self.name is None:
            self.name = os.path.basename(self._run_dir)
        debug("The name of the container will be %s" % self.name)
        return self.name

    def add_volume(self, host_dir, cont_dir, readonly=False, chown=False):
        self._volumes.append(self.Volume(host_dir, cont_dir, readonly, chown))

    # Basically we should only remove temporary run directories - when stilt.py
    # is done with them. This means the following for different subcommands:
    #   + calcslots - remove once we've extracted the slot list
    #   + shell - always remove
    #   + run   - never remove, the user will remove
    #
    # We do _not_ remove the directory if we're re-using a previous directory
    # or if the user specified --keep-rundir.
    def remove_rundir(self):
        if self.keep_rundir:
            debug("Not removing run directory")
        else:
            debug("Removing run directory")
            shutil.rmtree(self._run_dir)

    def add_run_dir_volume(self, name, cont_dir, readonly=False):
        assert self._run_dir is not None
        host_dir = os.path.join(self._run_dir, name)
        if not os.path.isdir(host_dir):
            os.mkdir(host_dir)
            debug("Created directory %s" % host_dir)
        self.add_volume(host_dir, cont_dir,  readonly, chown=True)
        return host_dir

    # CREATE / SETUP / REMOVE
    def _build_docker_args(self, cmd):
        self._ensure_input_output_volumes()
        uid, gid = users_id_and_gid()
        if uid != 0:
            debug("User is not root, adding chown hack to command line")
            dirs = [v.cont_dir for v in self._volumes if v.chown]
            cmd += "; chown -R %s:%s %s" % (uid, gid, ' '.join(dirs))
        debug("Full command to execute inside container is '%s'" % cmd)
        args = []
        if self.name is not None:
            args += ['--name', self.name]
        for v in self._volumes:
            args += ['-v', '%s:%s%s' % (v.host_dir, v.cont_dir,
                                        ':ro' if v.readonly else '')]
        args += [self.image, 'nice', '/bin/bash', '-c', cmd]
        return args

    def _create_container(self, cmd):
        create = ['docker', 'create', '-it'] + self._build_docker_args(cmd)
        debug("Creating container")
        debug("Docker create command is '%s'" % ' '.join(create))
        self._cid = subprocess.check_output(create).decode(
            'utf-8').strip()[:12]
        debug("Successfully created container %s" % self._cid)

    def _setup_container(self):
        if self.setup is None:
            return
        debug("Invoking %s to setup container " % self.setup)
        subprocess.check_call([self.setup, self._cid])
        debug("Finished running external setup command.")

    def remove_container(self):
        debug("Removing container %s" % self._cid)
        subprocess.check_call(['docker', 'rm', self._cid],
                              stdout=subprocess.DEVNULL,
                              stderr=subprocess.STDOUT)

    # RUN
    def _start_background(self):
        global DEBUG_FILES
        # If we're to run in the background, we'd like a run directory in which
        # to put docker.output ec.
        assert self._run_dir
        docker_out_path = os.path.join(self._run_dir, "docker.output")
        debug("Redirecting docker output to %s" % docker_out_path)
        debug("Starting docker in background")
        # The parent process returns, signalling that the container should not
        # be removed.
        pid = os.fork()
        if pid:
            debug("Leaving process %s as docker watchdog" % pid)
            return False
        DEBUG_FILES = False
        with open(docker_out_path, 'w') as dout:
            debug("Starting docker container %s" % self._cid)
            subprocess.check_call(['docker', 'start', self._cid],
                                  stdout=dout, stderr=subprocess.STDOUT)
        debug("Waiting for docker container %s to stop" % self._cid)
        rc = subprocess.check_output(['docker', 'wait', self._cid])
        debug("Container %s has stopped (return code %s)" % (
            self._cid, int(rc.strip())))
        # Here the child returns, signalling that the container may be removed.
        return True

    def _start_foreground(self):
        assert self._cid is not None
        debug("Starting docker in foreground")
        subprocess.check_call(['docker', 'start', '-i', self._cid])
        debug("Docker has finished.")

    def run(self, cmd=None, background=False):
        self._create_container(cmd)
        self._setup_container()
        if background:
            remove_container = self._start_background()
        else:
            self._start_foreground()
            remove_container = True
        if remove_container:
            self.remove_container()

    # PRIVATE
    def _ensure_input_output_volumes(self):
        if not any(True for v in self._volumes
                   if v.cont_dir.startswith('/opt/STILT_modelling/Input')):
            self.add_volume(STILT_INPUT_DIR,
                            '/opt/STILT_modelling/Input', readonly=True)


# METEOROLOGY FILES

def list_metfiles(path=METFILES_DIR):
    if not os.path.isdir(path):
        die("%s is not a directory" % path)
    return sorted(glob.glob("%s/ECmetF.*.arl" % path))


def parse_metfile_date(fname):
    # NOTE: There are files named ECmetF3h as well. That is the naming
    # convention used in the original STILT software. The '3h' was removed when
    # STILT was adapted to work within ICOS CP.
    #
    # "/mnt/additional_disk/WORKER/Input/Metdata/Europe2/ECmetF.11120100.arl"
    r = re.compile(r"[^.]+ECmetF\.(\d\d)(\d\d)0100\.arl")
    m = r.match(fname)
    assert m, "%s is not a metdata file?" % fname
    year = int('20%s' % m.group(1))
    month = int(m.group(2))
    return datetime.datetime(year, month, 1)


def first_day_of_next_month(d):
    y, m = (d.year, d.month+1) if d.month < 12 else (d.year+1, 1)
    limit = datetime.datetime(year=y, month=m, day=1)
    return limit


def calc_metfileranges():
    result = []
    first = None
    limit = None
    for f in list_metfiles():
        d = parse_metfile_date(f)
        if limit == d:
            limit = first_day_of_next_month(d)
        else:
            if limit:
                result.append((first, limit))
            limit = first_day_of_next_month(d)
            first = d + datetime.timedelta(days=10)
    if limit:
        result.append((first, limit))
    return result


def date_within_range(date, first, limit):
    return date >= first and date < limit


def range_within_range(date1, date2, first, limit):
    return (date_within_range(date1, first, limit) and
            date_within_range(date2, first, limit))


# STILT PECULIARITIES

def post_stilt_run_cleanup(rundir, verbose=True):
    expected_crap = sorted(['ASCDATA.CFG', 'runhymodelc.bat',
                            'ROUGLEN.ASC', 'LANDUSE.ASC'])
    debug("Cleaning up rundir %s" % rundir)
    p = os.path.join(rundir, 'logs', 'STILT_Exe')
    for e in (os.scandir(p) if os.path.isdir(p) else []):
        if not (e.name.startswith('Copy') and e.is_dir()):
            continue
        if e.name == 'Copy1':
            continue
        if sorted(os.listdir(e.path)) != expected_crap:
            debug("Not removing %s because it didn't exectly "
                  "what was expected" % e.path)
        else:
            shutil.rmtree(e.path)
            debug("Removing %s" % e.path)
    if verbose:
        print("Cleaned %s" % rundir)


# RUNS

def make_run_dir():
    """Create a properly named directory for a stilt run.

    We use mkdtemp to create a randomly named directory. That also gives the
    benefit of having generated a unique name for the docker container. To make
    it easier to track multiple runs and to remember which run was which, we
    tuck on an id at the end. We find the next available id by scanning the run
    directory.

    Given a RUN_DIRECTORY "/home/andre", this function will create a directory
    named "/home/andre/stilt-run-XXXXXXXX-1". The second time its called it'll
    create "/home/andre/stilt-run-XXXXXXXX-2" and so on. Each 'X' in the name
    will be a random character.

    """
    run_ids = [0]
    for f in os.scandir(RUN_DIRECTORY):
        if not f.is_dir():
            continue
        m = re.match(r'stilt-run-.*-(\d+)', f.name)
        if not m:
            continue
        run_ids.append(int(m.group(1)))
    suffix = '-%d' % (max(run_ids) + 1)
    return tempfile.mkdtemp(suffix=suffix, prefix="stilt-run-",
                            dir=RUN_DIRECTORY)


# DOCKER

def procs_in_container(cname):
    ps = lines("docker", "top", cname, '-o', 'pid,etimes,args')
    header = ps.pop(0)
    assert(header.split() == ['PID', 'ELAPSED', 'COMMAND'])
    for l in ps:
        l = l.strip()
        if not l:
            continue
        pid, etimes, args = l.split(None, 2)
        yield pid, int(etimes), args


# COMMANDS

def cmd_list_metfiles():
    """List all meteorology data files.
    """
    print("\n".join(list_metfiles()))


def cmd_metfileranges():
    """Show which date ranges we have meteorology data for.
    """
    for (first, limit) in calc_metfileranges():
        print("There's meteorology data available:")
        print("\tFrom %s up to (but not including) %s" % (
            first.strftime("%Y-%m-%d"), limit.strftime("%Y-%m-%d")))


def cmd_may_calc(first, last):
    """Pass in two dates (YYYY-MM-DD) and check if we have input data for them.
    """
    r = re.compile(r"^(\d{4})-(\d\d)-(\d\d)$")
    f, l = r.match(first), r.match(last)
    if not (f and l):
        die("I require two dates as argument, both of the form YYYY-MM-DD")
    f = datetime.datetime(*[int(_) for _ in f.groups()])
    l = datetime.datetime(*[int(_) for _ in l.groups()])
    for first, limit in calc_metfileranges():
        if range_within_range(f, l, first, limit):
            print("Yes")
            break
    else:
        die("No")


def cmd_metinfo():
    """Show summarized info about meteorology data.
    """
    print("Meteorology files lives in %s" % METFILES_DIR)
    wc = run("find %s -iname '*.arl' | wc -l" % METFILES_DIR, shell=True)
    du = run("du", METFILES_DIR, "-shcx").split()[0].strip().decode('utf-8')
    print("Meteorology files occupy %s across %s files" % (
        du, wc.strip().decode('utf-8')))
    cmd_metfileranges()


def cmd_info():
    """Show all obtainable status information about current system.
    """
    cmd_metinfo()
    print("")


def cmd_run(*args):
    """Start stilt simulation.

    e.g - "stilt run HTM 56.10 13.42 150 2012061500 2012061500"

    If the first argument looks like "--setup=FILE" then FILE should be an
    executable file that will be run to setup the container before stilt is
    started. For example, when this command is run:
      stilt run --setup=setup.sh HTM 56.10 13.42 150 2012061500 2012061500

    The following steps happens:
      1. A new container is created using "docker create ...."
      2. setup.sh is called with the newly created container ID as argument.
      3. The stilt container is started using "docker start ID"

    The purpose of the --setup argument is to enable the user make
    modifications to the container before it's run - without having to build a
    new docker image.

    """
    if len(args) != 6:
        die("Wrong number of arguments: stilt run [--setup=FILE] "
            "HTM 56.10 13.42 150 2012061500 2012061500")
    sc = STILTContainer()
    sc.add_run_dir_volume('logs', '/opt/STILT_modelling/%s' % sc.name)
    sc.add_run_dir_volume('output', '/opt/STILT_modelling/Output/%s' % sc.name)
    # The third to last argument to start.stilt.sh is the RUN_ID (the name of
    # the directory containing outputs and logs.  The second to last argument
    # is always 1 (number of "parts" i.e cpus). The last argument [0-2], 0
    # means calculate slots, 1 means final merging run (calculation of csv
    # files using existing particle location files), 2 means full run.
    cmd = ('cd /opt/STILT_modelling && '
           './start.stilt.sh %s %s 1 2 >& %s/start.stilt.log' % (
               ' '.join(args), sc.name, sc.name))
    print(sc._run_dir)
    sc.run(cmd, background=False)
    post_stilt_run_cleanup(sc._run_dir, verbose=False)


def cmd_shell():
    """Starts a shell in the STILT container.

    Useful for inspecting the runtime environment of STILT.

    andre@stilt:~$ stilt --image=stilt_special shell
    root@d5d5bd9c32f4:/#
    """
    dc = STILTContainer()
    dc.add_run_dir_volume('logs', '/opt/STILT_modelling/RUNID')
    dc.run('/bin/bash -i')
    dc.remove_rundir()


def cmd_calcslots(start_slot, end_slot):
    """Prints the slots included between start_slot and end_slot.

    $ stilt calcslots 2012010100 2012010309
    2012010100
    2012010103
    2012010106
    2012010109
    2012010112
    2012010115
    ...
    """
    dc = STILTContainer()
    log_dir = dc.add_run_dir_volume('logs', '/opt/STILT_modelling/RUNID')
    # "; ./start.stilt.sh SITE _ _ _ %s %s RUNID 0 > /dev/null"
    # "; ./start.prepare.sh SITE _ _ _ %s %s RUNID > /dev/null"
    cmd = ("cd /opt/STILT_modelling"
           "; ./start.stilt.sh SITE _ _ _ %s %s RUNID 1 0 > /dev/null" % (
               start_slot, end_slot))
    dc.run(cmd)
    for line in open(os.path.join(log_dir, 'output.txt'), 'r'):
        line = line.strip()
        if not line:
            continue
        print(line)
    dc.remove_rundir()


def cmd_cleanup(rundir):
    """Remove STILT leftovers from run directory.

    $ stilt cleanup 43 # cleans $HOME/stiltruns/stilt-run-*-43
    $ stilt cleanup .
    """
    rundir = rundir_lookup_dwim(rundir)
    post_stilt_run_cleanup(rundir)


def cmd_help(cmds):
    if len(sys.argv) > 2:
        cmd = sys.argv[2]
        if cmd not in cmds:
            die("no such command '%s'" % cmd)
        doc = cmds[cmd].__doc__
        if doc is None:
            print('Sorry, no extended help for "%s"' % cmd)
        else:
            print(doc)
    else:
        print("usage: stilt [OPTS] CMD\n\n"
              "OPTS include\n",
              "\t--keep-rundir\t- Never remove the generated run directory\n"
              "\t--debug\t\t\t- Debug logging\n",
              "\t--rundir=DIR\t- Re-use an existing run directory\n"
              "\t--setup=FILE\t- Run FILE with container ID before starting\n"
              "\t--image=IMAGE\t- Specify another docker image (%s)\n" % (
                  STILT_IMAGE))
        longest = max([len(n) for n in cmds])
        for c in sorted(cmds):
            firstline = (cmds[c].__doc__ or "").split('\n')[0]
            print("  {:<{}} - {!s}".format(c, longest, firstline))


# MAIN

if __name__ == '__main__':
    cmds = {"listmetfiles": cmd_list_metfiles,
            "metfileranges": cmd_metfileranges,
            "maycalc": cmd_may_calc,
            "metinfo": cmd_metinfo,
            "info": cmd_info,
            "run": cmd_run,
            "shell": cmd_shell,
            "calcslots": cmd_calcslots,
            "cleanup": cmd_cleanup}

    do_debug, args = find_arg(sys.argv[1:], lambda a: a == '--debug' or None)
    if do_debug:
        DEBUG_FILES.append(sys.stderr)
    STILTContainer.setup, args = find_arg(args, parse_setup_arg)
    STILTContainer.image, args = find_arg(
        args, parse_image_arg, STILT_IMAGE)
    STILTContainer.keep_rundir, args = find_arg(
        args, lambda a: a == '--keep-rundir' or None)
    STILTContainer.rundir, args = find_arg(args, parse_rundir_arg)
    if len(args) < 1 or args[0] == "help":
        cmd_help(cmds)
    elif args[0] not in cmds:
        die("no such command (%s)" % args[0])
    else:
        func = cmds[args[0]]
        try:
            func(*args[1:])
        except TypeError as e:
            # This is a somewhat solid way of determining if the user have
            # passed the wrong number of arguments to the function.
            if 'positional argument' in str(e):
                print('Wrong number of arguments to "%s" - '
                      'documentation below.\n' % func.__name__,
                      file=sys.stderr)
                doc = getattr(func, '__doc__', None) or ''
                print(re.sub('\n[ \t]+', '\n', doc), file=sys.stderr)
            else:
                raise
