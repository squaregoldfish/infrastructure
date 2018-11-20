This role wraps a Java application consisting of a single jar file running as a
systemd service.

To use it you must first set up some variables and then use ansibles
'import_role' directive, like this:

	- name: Run the jarservice role
	  import_role:
		name: icos.jarservice
	  vars:
		username        : foouser
		jarfile         : foo.jar
		servicename     : foo
		servicetemplate : roles/foo/templates/service.j2

