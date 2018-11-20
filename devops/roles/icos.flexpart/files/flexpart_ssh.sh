#!/bin/bash
# This script is invoked by sshd everytime someone tries to login as the
# flexpart user (by using command=flexpart_ssh.sh in the authorized_keys file).

set -- $SSH_ORIGINAL_COMMAND
exec /usr/local/bin/flexpart "$@"
