## Overview

Note! All nextcloud links in this file goes to the latest ("stable") versions of the documentation, remember to change the version (by editing the URL) to the version you intend to install.


* [Nextcloud release schedule][1]
* [Admin manual][2]
* [Discussion groups][3]


## Upgrading postgresql

Upgrading postgres between minor versions (which for versions 10 and beyond means changing the second versions, i.e 10.8 to 10.14) can be done by just upping the second version and starting the new container.

Upgrading between major versions, e.g version 10 to version 11, requires either a dump/restore or a pg_upgrade, the later might prove tricky in a container.

1. Check [which versions][5] of postgres are supported by nextcloud. Currently versions 9.[56], 10 and 11 are supported.
2. The [postgres version lifecycle][6] is available here. Currently we're running postgres 10, which is supported until October 2022.
3. Check [nextcloud notes][4] about postgres.
4. Find the latest [postgres docker tags][7]



## Upgrading Nextcloud

1: Check and if possible fix the [warnings on the admin page][8]





[1]: https://github.com/nextcloud/server/wiki/Maintenance-and-Release-Schedule
[2]: https://docs.nextcloud.com/server/stable/admin_manual/
[3]: https://help.nextcloud.com/
[4]: https://docs.nextcloud.com/server/stable/admin_manual/configuration_database/linux_database_configuration.html#postgresql-database
[5]: https://docs.nextcloud.com/server/stable/admin_manual/installation/system_requirements.html
[6]: https://www.postgresql.org/support/versioning/
[7]: https://hub.docker.com/_/postgres/?tab=tags
[8]: https://docs.nextcloud.com/server/stable/admin_manual/configuration_server/security_setup_warnings.html
