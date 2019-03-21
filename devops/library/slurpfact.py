#!/usr/bin/python
# -*- coding: utf-8 -*-
# Ansible module that sets a fact to the contents of a file.

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

- debug: var=my_hostname

- slurpfact:
    path: /etc/passwd
    fact: my_passwd
    list: true

- debug: var=my_passwd
'''


def main():

    module = AnsibleModule(
        argument_spec={'path': dict(required=True, type='str'),
                       'fact': dict(required=True, type='str'),
                       'list': dict(required=False, type='bool',
                                    default=False)})

    try:
        data = open(module.params['path']).read()
        if module.params['list']:
            data = data.splitlines()
    except Exception as e:
        module.fail_json(msg=str(e))
    else:
        result = {'changed': False,
                  'ansible_facts': {module.params['fact']: data}}
        module.exit_json(**result)


if __name__ == '__main__':
    main()
