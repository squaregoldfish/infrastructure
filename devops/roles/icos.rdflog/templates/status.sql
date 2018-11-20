-- This is the status report used the rdflog's 'ctl' tool.

\pset footer
\pset title

\connect {{ rdflog_db_name }};

-- This part shows replication status on the master side.
select
  case
    when s is null then 'No slots are currently replicating'
    else format('The following slots are currently replicating => %s', s) 
  end as slot_report
from (select string_agg(c, ', ') s from
	   (select slot_name FROM pg_replication_slots
	   		             JOIN pg_stat_replication ON pid = active_pid) _(c)) _;

-- This part show status of the rdflog database itself.
{# The reason we keep the status report in a separate file is because that file #}
{# can then be re-used by rdflog replicas #}
{{ lookup('file', 'status-rdflog.sql') }}
