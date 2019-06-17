#!/bin/bash
# This script serves as an easy frontend for the day-to-day
# interaction between our virtual machines used for testing and our
# ansible stuff.
#
# First create a link to somewhere in your path, using the name of the
# virtual machine as destination. Example:
#  $ mkdir -p $HOME/bin
#  $ ln -s $PWD/vm.sh $HOME/bin/bionic
#
# Then use the script along these lines:
#   $ bionic recreate
#   $ bionic help
#   $ bionic icosprod -t nginx

set -e
set -u

HOST="${0##*/}"
DEVOPS="$(dirname $(realpath $0))"
TMUX_SESSION="$HOST"
TMUX_WINDOWS=6


function cmd_attach {
    if tmux has-session -t "$TMUX_SESSION" > /dev/null; then
	    tmux kill-session -t "$TMUX_SESSION"
    fi

    tmux new-session -s "$TMUX_SESSION" -d

    for i in $(seq 1 "$TMUX_WINDOWS"); do
	    if [[ $i -gt 1 ]]; then
		    tmux new-window -t "$TMUX_SESSION"
	    fi
	    tmux select-window -t"$TMUX_SESSION:$i"
	    tmux send-key -t "$TMUX_SESSION:$i" "ssh -t $HOST sudo su -" C-m
    done

    tmux switch-client -t "$TMUX_SESSION:1"
}    


case "${1:-}" in
    "go")
	ssh -t "$HOST" "sudo su -"
	;;
    "up")
        cd "$DEVOPS"
        vagrant up "$HOST"
        ;;
    "halt")
        cd "$DEVOPS"
        vagrant halt "$HOST"
        ;;
    "recreate")
        cd "$DEVOPS"
        vagrant destroy -f "$HOST"
        vagrant up "$HOST"
        ;;
    "attach")
        cmd_attach
        ;;
    "provision")
	shift
	cd "$DEVOPS"
        ansible-playbook -i test.inventory -lbionic "$@"
        ;;
    "icosprod")
	shift;
	cd "$DEVOPS"
	ansible-playbook icosprod.yml -i test.inventory -lbionic "$@"
	;;
    "status")
        cd "$DEVOPS"
        vagrant status "$HOST"
        ;;
    "update")
        cd "$DEVOPS"
        vagrant box update
        ;;
    ""|"help")
        cat <<EOF
usage: $HOST <cmd>
  go		ssh $HOST
  up		vagrant up $HOST
  halt		vagrant halt $HOST
  recreate	vagrant destroy $HOST; vagrant up $HOST
  attach	tmux support
  provision	ansible-playbook -i$HOST, "\$@"
  icosprod	ansible-playbook icosprod.yml -i test.inventory -l$HOST "\$@"
  update	vagrant box update
EOF
esac    
