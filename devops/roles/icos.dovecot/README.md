## Overview

This role installs the dovecot IMAP server and configure the host postfix to
relay messages to it.

## Howto


### Add a new user
We use [virtual users](https://wiki.dovecot.org/VirtualUsers) in a [passwd database](https://wiki.dovecot.org/AuthDatabase/PasswdFile)

	# generate the password hash
	doveadm pw -s sha256

	# add user
	echo "user@domain.com:{SHA256}longstring:" >> /etc/dovecot/users

	# no need to reload the user database


### Add new domain

First create the certificate manually using certbot, then add it to
the certbot configuration and redeploy.

	# on server
	$ sudo certbot --nginx --domain DOMAIN

	# on localhost
	$ cat devops/production.inventory/host_vars/host
	...
	dovecot_domains:
		- DOMAIN
		- DOMAIN2
