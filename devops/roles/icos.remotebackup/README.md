# Use a combination of ssh and rsync to do remote backups.

This role uses ansible's 'delegate_to' to install both the source and target
hosts at the same time.

## On the source host this role will:

  * generate a remotebackup user
  * generate an ssh key pair
  * install a remotebackup script that invokes rsync for each target

## On the target host this role will:

  * generate a remotebackup user
  * install the ssh public key from the source host
  * create a target directory
  * restrict the ssh key to only run rrsync (a restricted rsync script that's
    part of the rsync distribution) which is limited to the target directory.

## On the source host one can then invoke the following:

    remotebackup -av test_directory

Which translate into:

    rsync -av test_directry target_host1:source_host/
    rsync -av test_directry target_host2:source_host/
    ...
    rsync -av test_directry target_hostn:source_host/


## Assumptions

Each target host needs to have hostvars[hostname].ssh_connection_remote_ip set
to it's public ip.

To use the script one has to have read access to ~remotebackup/.ssh/id_rsa.pub
which would mean that one is either root or a member of the remotebackup group.
