This role wraps a Java application consisting of a single jar file running as a
systemd service.

It's meant to be used with ansible's 'include_role' directive, like this:

	- name: Run the jarservice role
	  include_role:
		name: icos.jarservice
	  vars:
		username        : foouser
		jarfile         : foo.jar
		servicename     : foo
		servicetemplate : roles/foo/templates/service.j2
