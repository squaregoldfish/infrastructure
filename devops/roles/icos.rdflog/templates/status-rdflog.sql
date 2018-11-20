\connect rdflog

select ctl.latest_timestamps_query() != '' as have_tables
\gset

\if :have_tables
  \echo The latest timestamps for each rdflog table are:
  select * from ctl.latest_timestamps() order by tstamp desc;
\else
  \echo 'No rdflog tables present! (maybe restore a backup?)'
\endif

