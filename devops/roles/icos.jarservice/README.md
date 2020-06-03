# Overview

This role wraps a Java application consisting of a single jar file running as a
systemd service.

To use it you must first set up some variables and then use ansibles
'include_role' directive, like this:

	- name: Run the jarservice role
	  include_role:
		name: icos.jarservice
	  vars:
		servicename     : foo
		username        : foouser
		jarfile         : foo.jar
		configfile      : roles/foo/templates/application.conf
		nginxconfig     : roles/foo/files/meta.conf
		servicetemplate : roles/foo/templates/service



## Deploy only config

To skip deploying a new jar file and only update the config, use:

	- hosts: fsicos
	  become: true
	  vars:
		jarservice_conf_only: True
	  roles:
		- role: icos.cpauth


To further skip updating the nginx config (which relies on certbot), use:

	- hosts: fsicos
	  become: true
	  vars:
		jarservice_conf_only: True
		certbot_disabled: True
	  roles:
		- role: icos.cpauth
