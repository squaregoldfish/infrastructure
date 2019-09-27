#!/usr/bin/python3
# Frontend for ansible-playbook + ICOS playbooks.
#
# This scripts assumes that:
#  1. It lives in the same directory as the ICOS playbooks
#  2. Each application has its own playbook
#  3. All tags begins with APPLICATION_
#  4. The default inventory is production.
#
# Installation:
# $ ln -s deploy.py $HOME/bin/deploy
#
# Show tags for cpmeta:
# $ deploy cpmeta --list-tasks
#
# Show tasks for cpmeta:
# $ deploy cpmeta --list-tasks
#
# Run entire cpmeta playbook using test inventory:
# $ deploy test cpmeta
#
# Run only the backup tasks using production inventory:
# $ deploy cpmeta backup
#
# Deploy new version of cpmeta to production.
# $ deploy cpmeta app -ecpmeta_jar_file=cpmeta.jar


import sys
import os


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


# Try to find out in which directory this script lives.
DEVOPS = os.path.dirname(os.path.realpath(sys.argv.pop(0)))

# Change to the directory where the playbooks lives. Ansible uses the current
# working directory as a starting point when locating its files.
os.chdir(DEVOPS)

if len(sys.argv) < 1:
    die("usage: deploy [prod|test] name(.yml) {tags}")
elif sys.argv[0] == 'prod':
    INVENTORY = "production.inventory"
    del sys.argv[0]
elif sys.argv[0] == 'test':
    INVENTORY = "test.inventory"
    del sys.argv[0]
else:
    INVENTORY = "production.inventory"

if not os.path.exists(INVENTORY):
    die("Cannot find %s in %s" % (INVENTORY, DEVOPS))

NAME = sys.argv.pop(0)
PLAYBOOK = "%s.yml" % NAME
if not os.path.exists(PLAYBOOK):
    die("Cannot find %s in %s" % (PLAYBOOK, DEVOPS))

# The remaining arguments are either tags or options to ansible.
TAGS = ["-t%s" % tag for tag in sys.argv if not tag.startswith('-')]
OPTS = [opt for opt in sys.argv if opt.startswith('-')]
ARGS = ['ansible-playbook', '-i', INVENTORY, PLAYBOOK] + TAGS + OPTS

print("ansible-playbook", *ARGS)

os.execvp('ansible-playbook', ARGS)
