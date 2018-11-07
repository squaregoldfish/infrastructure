\pset footer
\pset title

\connect {{ rdflog_db_name }};

select
  case
    when s is null then 'No slots are currently replicating'
    else format('The following slots are currently replicating => %s', s) 
  end as slot_report
from (select string_agg(c, ', ') s from
	   (select slot_name FROM pg_replication_slots
	   		             JOIN pg_stat_replication ON pid = active_pid) _(c)) _ \gset

{# Keep this file separate since it might be used by one of our replicas #}
{{ lookup('file', 'status-rdflog.sql') }}
