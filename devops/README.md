# DevOps

This directory contains our framework to automatically provision (setup /
install software) on our different servers.

The framework is based around Ansible for provisioning and Vagrant/VirtualBox
for testing.

## Quick start

The easiest way to this framework is to run it against Virtual Machines (VMs)
instead of the production environment. To create the VMs you first need to
install Vagrant and VirtualBox. Once that is done run

`vagrant up`

This takes a few minutes and creates two VMs, 'ubuntu' and 'centos'; one for
each of the tested Linux distributions. Next run

`vagrant ssh-config >> ~/.ssh/config`

Then test that you can execute commands on the VMs:

`for machine in ubuntu centos; do ssh $machine uname -a; done`

Which prints something like the following:

> Linux ubuntu 4.4.0-62-generic #83-Ubuntu SMP Wed Jan 18 14:10:15 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> Linux centos 3.10.0-514.2.2.el7.x86_64 #1 SMP Tue Dec 6 23:06:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Before you start with the provisioning/deployment you will need to make sure
that you have the ICOS software available in compiled form. Look
in [vars.yml](vars.yml) and make sure the paths exists.

Then you can start the provisioning

`ansible -i test.inventory main.yml`


## More ways to use the inventories and playbooks

There are two inventory files, [test.inventory](test.inventory)
and [production.inventory](production.inventory). These files divide hostnames
into groups, groups which are then assigned roles based on the ansible
playbooks.

Next are the playbooks, the [main playbook](main.yml) is the one we'll use, it
includes the smaller playbooks.

Say you want to test deployment of the stilt servers, the following command will
use the test inventory and execute the stilt playbook.

`ansible-playbook -i test.inventory stilt.yml`

A production deployment of stilt would use the production inventory:

`ansible-playbook -i production.inventory stilt.yml`

Finally, a production deployment to all our servers would look like:

`ansible-playbook -i production.inventory main.yml`

## Deploying Drupal websites

The drupal playbook requires a `website` parameter with the short name of the website. It can be used with the deploy script:

`deploy drupal -ewebsite=ac -tdrupal`

which is equivalent to

`ansible-playbook -i production.inventory -t drupal -e "website=ac" drupal.yml`
