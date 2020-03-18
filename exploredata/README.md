# How to push new notebooks to exploredata / exploretest

The notebooks are pushed from a local clone of the jupyter repository. This
means that if someone else has pushed new notebooks to github, you'll have to
update your local repo first, otherwise you will push old notebooks to
exploredata:

    cd ~/icos/jupyter
    git pull

Next we navigate to the infrastructure repo, it needs to be situated next to
the jupyter, like this:

    # we're already in the ~/icos/jupyter directory
    cd ../infrastructure/exploredata

Then make sure that the infrastructure repo is up to date

    git pull

Now psuh to exploretest

    make pushtest

Once this finishes, navigate to https://exploretest.icos-cp.eu and make sure
that all the expected changes are visible and that everything works. Then push
to exploredata.

    make pushprod

This will update https://exploredata.icos-cp.eu


# Debugging

The deployment relies on you having ssh access to the exploredata virtual
machine, as root. You can test this by running the following command:

    ssh -p 60532 root@fsicos2.lunarc.lu.se

If this gives you a command-prompt on exploredata, you now that you have the
correct credentials. If you fail to connect using ssh, run the command again,
but this time with an extra option:

    ssh -v -p 60532 root@fsicos2.lunarc.lu.se

Then copy-paste the output to your friendly neighbourhood sysadmin.


# All it one shell-script

Copy-paste the following to a shell-script, make it executable and then run it.


    #!/bin/bash

    set -e

    # The root under which you keep your cloned github repos
    ICOS=~/icos

    cd "$ICOS"
    cd jupyter
    git pull
    cd ../infrastructure/exploredata
    git pull
    make pushprod
    echo "now go to exploretest, then run 'make pushprod'"
