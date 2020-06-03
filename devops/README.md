# DevOps

This directory contains our framework to automatically provision (setup /
install software) on our different servers.

The framework is based around Ansible for provisioning and Vagrant/VirtualBox
for testing.

## Deploying Drupal websites

The drupal playbook requires a `website` parameter with the short name of the website. It can be used with the deploy script:

`deploy drupal -ewebsite=ac -tdrupal`

which is equivalent to

`ansible-playbook -i production.inventory -t drupal -e "website=ac" drupal.yml`
