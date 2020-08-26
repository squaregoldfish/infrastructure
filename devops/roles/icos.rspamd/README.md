## Overview

[A spam filter][1] that we use with postfix

Installed into a LXD VM and used by the host's postfix as a milter.

### Parts
+ It has a CLI called rspamadm(1).
+ TCP ports are used by several rspamd processes, among them:
  + Port 11332 is where postfix contacts the milter - configured using
    postconf(1) on the host.
  + Port 11334 is for the web ui - proxied by nginx on the host.
+ Segfaults occur every now and then, sometimes because the configuration file
  is broken, unclear if this is by choice or not.
+ Redis is used as a caching database.


### Commands
+ rspamadm pw -p password -> password hash for cleartext password
+ systemctl status rspamd -> is it up or down


### Log files
+ tail /var/log/rspamd/* on the vm
+ tail /var/log/mail.log on the host has info on rspamd
