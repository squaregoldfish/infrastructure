#!/usr/bin/python
# -*- coding: utf-8 -*-
# Ansible module that sets a fact to the contents of a file.

import errno
from ansible.module_utils.basic import AnsibleModule

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

EXAMPLES = '''
- slurpfact:
    path: /etc/hostname
    fact: my_hostname

# the hostname string
- debug: var=my_hostname

- slurpfact:
    path: /etc/passwd
    fact: my_passwd
    list: true

# a list of lines in /etc/passwd
- debug: var=my_passwd

- slurpfact:
    path: /etc/nosuchfile
    fact: my_nosuch
    fail: false

# an empty string
- debug: var=my_nosuch


# failure, file does not exist
- slurpfact:
    path: /etc/nosuchfile
    fact: my_nosuch
'''


def main():
    argument_spec = {'path': dict(required=True, type='str'),
                     'fact': dict(required=True, type='str'),
                     'list': dict(required=False, type='bool', default=False),
                     'fail': dict(required=False, type='bool', default=True)}
    module = AnsibleModule(argument_spec=argument_spec)

    data = None
    try:
        data = open(module.params['path']).read()
        if module.params['list']:
            data = data.splitlines()
    except IOError as e:
        if e.errno == errno.ENOENT and not module.params['fail']:
            data = ''
        else:
            module.fail_json(msg=str(e))
    assert data is not None
    result = {'changed': False,
              'ansible_facts': {module.params['fact']: data}}
    module.exit_json(**result)


if __name__ == '__main__':
    main()
