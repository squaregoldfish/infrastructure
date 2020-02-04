#!/usr/bin/python
# -*- coding: utf-8 -*-
# Ansible module that manipulates LXD networks
#
# The LXD network config keys are here:
#   https://lxd.readthedocs.io/en/latest/networks/

from ansible.module_utils.basic import AnsibleModule
import json
import yaml
import os


ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}


DOCUMENTATION = '''
---
module: lxd_network
short_description: Manipulate LXD networks
version_added: "2.9"
description:
  - Create/delete/change LXD networks.
options:
  name:
    description:
      - The name of the network.
    required: true
  state:
      choices:
        - present
        - absent
      description:
        - Define the state of a network.
      default: present
  config:
    description:
      - The same config keys as accepted by LXD
      - https://lxd.readthedocs.io/en/latest/networks/
  description:
    description:
      - A description of the network
'''


EXAMPLES = '''
- lxd_network:
    name: lxdbr_foo
    description: Network used for container foo
    config:
      ipv4.address: 10.30.13.1/24
'''


module = None


# UTILS

# Modern LXD on Ubuntu is installed using snap.
def ensure_snap_in_path():
    snap_bin = '/snap/bin'
    for part in os.environ['PATH'].split(':'):
        if part == snap_bin:
            return
    os.environ['PATH'] = '%s:%s' % (snap_bin, os.environ['PATH'])


def deepupdate(original, update):
    changed = False
    for k, v in original.items():
        if k not in update:
            continue
        if isinstance(v, dict):
            changed = deepupdate(v, update[k]) or changed
        else:
            changed = original[k] != update[k] or changed
            original[k] = update[k]
    return changed


# LXC

def lxc(*args):
    # REST API you say? Not so much!
    _, stdout, _ = module.run_command(['lxc']+list(args), check_rc=True)
    return stdout


def lxc_network_show(name):
    stdout = lxc('network', 'show', name)
    return yaml.load(stdout)


def lxc_network_list():
    stdout = lxc('network', 'list', '--format', 'json')
    return json.loads(stdout)


# MAIN

def main():
    global module
    argument_spec = {'name': dict(required=True, type='str'),
                     'state': dict(default='present',
                                   choices=('present', 'absent')),
                     'description': dict(typ='str'),
                     'config': dict(type='dict')}

    module = AnsibleModule(argument_spec=argument_spec)
    name = module.params['name']
    state = module.params['state']

    result = {}
    changed = False

    ensure_snap_in_path()
    present = any([n for n in lxc_network_list() if n['name'] == name])

    if state == 'absent':
        if present:
            lxc('network', 'delete', name)
            changed = True
    else:
        if not present:
            lxc('network', 'create', name)
            changed = True

        current = lxc_network_show(name)
        changed = deepupdate(current['config'],
                             module.params.get('config', {})) or changed

        newdesc = module.params.get('description', current['description'])
        if newdesc != current['description']:
            current['description'] = newdesc
            changed = True

        module.run_command(['lxc', 'network', 'edit', name],
                           data=yaml.dump(current), check_rc=True)

        result['description'] = current['description']
        result['config'] = current['config']

    result['changed'] = changed
    module.exit_json(**result)


if __name__ == '__main__':
    main()
