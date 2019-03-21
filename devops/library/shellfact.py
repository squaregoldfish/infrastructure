#!/usr/bin/python
# -*- coding: utf-8 -*-
# Ansible module sets a fact to the contents of a file.

from ansible.module_utils.basic import AnsibleModule

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

EXAMPLES = '''
- shellfact:
    exec: echo $SSH_CONNECTION | sed 's/ /\n/g'
    fact: ssh_connection
    list: true

- debug: var=ssh_connection

- shellfact:
    exec: |
      IP=$(echo $SSH_CONNECTION | cut -d ' ' -f 3);
      ssh-keyscan localhost | sed "s/^localhost/$IP/"
    fact: hostkeys

- debug: var=hostkeys
'''

def main():
    module = AnsibleModule(
        argument_spec={'exec': dict(required=True, type='str'),
                       'fact': dict(required=True, type='str'),
                       'list': dict(required=False, type='bool', default=False),
                       'rstrip': dict(required=False, type='bool', default=True)})

    rc, stdout, stderr = module.run_command(
        module.params['exec'], check_rc=True, use_unsafe_shell=True)
    if module.params['rstrip']:
        stdout = stdout.rstrip()
    if module.params['list']:
        stdout = stdout.splitlines()
    result = {'changed': False,
              'ansible_facts': {module.params['fact']: stdout}}
    module.exit_json(**result)


if __name__ == '__main__':
    main()
