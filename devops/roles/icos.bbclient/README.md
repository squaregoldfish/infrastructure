Username.

    - role: icos.bbclient
      tags: backup
      bbclient_user: "{{ myrole_username }}"


Username and coldbackup schedule.

    - role: icos.bbclient
      tags: bbclient
      vars:
        bbclient_user: "{{ mailman_username }}"
        bbclient_coldbackup_crontab: { hour: 02, minute: 40 }


Remotes.

    - role: icos.bbclient
      tags: bbclient
      bbclient_user: cpdata
      bbclient_remotes: [fsicos2.lunarc.lu.se]


User, home and remote name.

    - role: icos.bbclient
      tags: bbclient
      bbclient_user: root
      bbclient_home: "{{ restheart_home }}"
      bbclient_name: restheart



Turn off coldbackup.

    - role: icos.bbclient
      bbclient_coldbackup_enable: no








