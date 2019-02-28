#!/usr/bin/python
# -*- coding: utf-8 -*-
# Ansible module that sets/appends postfix config values.
# Works by calling postconf(1) and postfix(1).
# Basic support for postfix parameters that are lists.

from ansible.module_utils.basic import AnsibleModule

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
---
module: postconf
short_description: Set postfix configuration
version_added: "2.7"
description:
  - Set/append postfix configuration values.
options:
  param:
    description:
      - The name of the postfix configuration parameter to set/append.
    required: true
  value:
    description:
      - The value to set/append.
    required: true
  append:
    description:
      - Some Postfix parameters are lists. These are separated by
        commas or spaces. Setting C(append) to true vill add C(value)
        to the existing value instead of overwriting it.
    required: false
    default: false
  reload:
    description:
      - Make postfix reload it's configuration after changing it.
    required: false
    default: true
  separator:
    description:
      - Which character to separate list values with.
    required: false
    choices: ['comma', 'space']
    default: 'space'
notes:
  - The postfix values are read/updated through the postconf(1)
    command. The configuration is reloaded by executing 'postfix
    reload'. In same cases postfix supports escaping commas and spaces
    for use in parameter values. That syntax is not supported by this
    module. We try not to mess up, but no promises are made.
author:
  - "André Bjärby (@andreby)"
'''


EXAMPLES = '''
# Set recipient_delimiter to +
- postconf:
    param: recipient_delimiter
    value: +
    append: True

# Append 172.25.0.0/24 to mynetworks
- postconf:
    param: mynetworks
    value: 172.25.0.0/24
    append: True
'''


def main():
    module = AnsibleModule(
        argument_spec=dict(
            param=dict(required=True, type='str'),
            value=dict(required=True, type='str'),
            append=dict(required=False, type='bool', default=False),
            reload=dict(required=False, type='bool', default=True),
            separator=dict(required=False, type='str',
                           choices=['comma', 'space'], default='space')))

    param = module.params['param']
    value = module.params['value']
    append = module.params['append']
    separator = ',' if module.params['separator'] == 'comma' else ' '
    result = dict(param=param, value=value, append=append, changed=False)

    if append and (' ' in value or ',' in value):
        msg = "When appending, the value cannot contain spaces or commas."
        module.fail_json(msg=msg)

    # If we try to execute an executable that's not present, the error
    # message will not always be clear about _which_ executable is
    # missing - it simply says '[Errno 2] No such file or directory'
    # which can be confusing to end users.
    for cmd in ['postconf', 'postfix']:
        rc, _, _ = module.run_command(['which', cmd], check_rc=False)
        if rc != 0:
            msg = 'Could not execute %s - is postfix installed?' % cmd
            module.fail_json(msg=msg)

    # Run postconf to get the current value of param.
    rc, stdout, stderr = module.run_command(['postconf', param],
                                            check_rc=False)
    if rc != 0:
        msg = "Could not execute postconf => %s" % stderr
        module.fail_json(msg=msg)

    # postconf will exit with 0 for unknown parameters
    if stderr.strip().endswith('unknown parameter'):
        msg = 'Unknown postfix parameter "%s"' % param
        module.fail_json(msg=msg)

    # Split 'mydomain = test.com' into 'mydomain' and 'test.com'
    cur_param, cur_value = [s.strip() for s in stdout.split('=', 1)]
    if cur_param != param:
        msg = 'Expected config param "%s" but got "%s"' % (param, cur_param)
        module.fail_json(msg=msg)

    new_value = None
    if not append:
        if cur_value != value:
            new_value = value
    else:
        # Postfix has a special syntax for allowing commas and
        # whitespace as part of config values. We don't support this
        # syntax but try not to mess up.
        if '{ ' in cur_value:
            msg = ("This module can't append to config values that uses the "
                   "'{ ' syntax (see postfix docs for export_environment)")
        parts = cur_value.replace(',', ' ').split()
        if value not in parts:
            parts.append(value)
            new_value = separator.join(parts)

    if new_value is not None:
        args = ['postconf', '%s=%s' % (param, new_value)]
        rc, stdout, stderr = module.run_command(args, check_rc=False)
        if rc != 0 or stderr:
            msg = 'Attempted to set postfix config "%s"="%s" => %s' % (
                param, new_value, stderr.strip())
            module.fail_json(msg=msg)
        else:
            rc, stdout, stderr = module.run_command(['postfix', 'reload'],
                                                    check_rc=False)
            # FIXME: When I simulated this failure at the command
            # prompt - by calling 'postfix nosuch' - postfix responds
            # with "... unknown command: 'nosuch'". But when executed
            # using run_command, both stderr and stdout are always
            # empty! Somewhere the output is eaten.
            if rc != 0:
                msg = ('Failed to reload postfix config '
                       '(using "postfix reload") => %s' % (stderr+stdout))
                module.fail_json(msg=msg)
            else:
                result['changed'] = True

    module.exit_json(**result)


if __name__ == '__main__':
    main()
