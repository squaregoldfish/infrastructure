# Overview

This role wraps a Java application consisting of a single jar file running as a
systemd service.

To use it you must first set up some variables and then use ansibles
'include_role' directive, like this:

	- name: Run the jarservice role
	  include_role:
		name: icos.jarservice
	  vars:
		username        : foouser
		jarfile         : foo.jar
		servicename     : foo
		servicetemplate : roles/foo/templates/service.j2



## Deploy only config

To skip deploying a new jar file and only update the config, use:

	- hosts: icosprod
	  become: true
	  vars:
		jarservice_conf_only: True
	  roles:
		- role: icos.cpauth


To further skip updating the nginx config (which relies on certbot), use:

	- hosts: icosprod
	  become: true
	  vars:
		jarservice_conf_only: True
		certbot_disabled: True
	  roles:
		- role: icos.cpauth
