
A bit more information about what the script does, is
in docs/manual.pdf


You need the  mailmainclient module installed into python
https://mailmanclient.readthedocs.io/en/latest/index.html
(the source is in the doc folder), but
try first: pip install mailmanclient

At the moment, configuration is for "test mode"
safe to play around until everything is working.
Then you can go in production by adjusting the ini files.



You need to double check the following settings
to switch from "test" mode to production:

- Adjust all the descriptions and carbon portal admin entries in the config files

- Make sure that the "umbrella.ini" contains proper descriptions

- set config/config.ini   test = False

- delete the cphelpers sparql query "limit 5" otherwise you don't get
the full list.

Be aware, that the interaction with mailman is slow. adding 100 mailing lists
may easily take up a couple of minutes.

you can follow the progress by monitoring the logfile