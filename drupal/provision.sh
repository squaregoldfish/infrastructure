#!/bin/bash

# Disable firewalld on the vagrant box since we don't need it
systemctl disable firewalld
systemctl stop firewalld

# Add virt7-testing repository for up to date docker
cp /vagrant/shell/virt7-testing/virt7-testing.repo /etc/yum.repos.d/virt7-testing.repo

# Update the box
yum update -y --skip-broken

# Install and configure docker
yum install -y docker
groupadd docker
usermod -a -G docker vagrant
echo 'OPTIONS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' >> /etc/sysconfig/docker
systemctl start docker
systemctl enable docker

# Install docker compose
curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Run the docker containers
cd /vagrant/docker
# Using absolute path to docker-compose here since the vagrant up shell doesn't have it in its path
/usr/local/bin/docker-compose -p icos up -d
