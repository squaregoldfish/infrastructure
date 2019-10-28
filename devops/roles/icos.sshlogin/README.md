# Overview

This role sets up a ssh login from hostA to hostB. It depends on the ansible
controller having access to both hosts and then uses delegate_to to provision
both hosts at once.


## Example
The following example:

    hosts: hostProd
    roles:
      - role: icos.sshlogin
        sshlogin_dst: hostBackups
        sshlogin_src_user: produser
        sshlogin_dst_user: produser

Will create users, generate and copy ssh keys, retrieve host keys etc. The role
can optionally figure out the source host ip and restrict the ssh key to only
that IP.
