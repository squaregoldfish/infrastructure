Overview
========

This role will install and configure postfix. It is dependent on one
of our own ansible modules called *postconf*.


## Postfix status

Is it up and running:

	$ systemctl status postfix

What does the logs say:

	$ tail -f /var/log/mail.log

Any mail stuck in the queue:

	$ mailq


## Configuring postfix

Ideally, all configuration should be done using the ansible *postconf*
module. To configure postfix manually, use *postconf(1)* - this
command will directly modify the postfix configuration files.


	$ postconf mynetworks
	mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128

	# Postconf cannot append to an existing value, so set everything again.
	$ postconf mynetworks=127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.20.0.0/16

	# reload configuration
	$ postfix reload


## Postfix mail queue

	# show mail queue (sendmail compatibility style)
	$ mailq

	# show postfix queue
	$ postqueue -p

	# mail queue overview
	$ qshape

	# attempt to deliver queued mail
	$ mailq -q

	# show message
	$ postcat -vq <id-from-postqueue>

	# delete all queued mail
	$ postsuper -d ALL

	# delete deferred mail
	$ postsuper -d ALL deferred

	# tail maillog then resend a specific mail
	$ tail -f /var/log/mail.log
	$ postqueue -i DA80E24A0A

	# delete a single mail from the queue
	$ postsuper -d DA80E24A0A


## fail2ban

We use fail2ban to keep stupid spam bots from filling the logs. Check
the status of those jails:

	$ fail2ban-client status
	Status
	|- Number of jail:      2
	`- Jail list:   postfix-auth, sshd
	$ fail2ban-client status postfix-auth
	Status for the jail: postfix-auth
	|- Filter
	|  |- Currently failed: 0
	|  |- Total failed:     22
	|  `- File list:        /var/log/mail.log
	`- Actions
	   |- Currently banned: 1
	   |- Total banned:     23
	   `- Banned IP list:   123.45.67.89

## Resources

https://marc.info/?l=postfix-users
