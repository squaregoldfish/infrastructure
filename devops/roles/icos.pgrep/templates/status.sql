\pset footer
\pset title

select case when pg_is_in_recovery() then 'Postgres is set up for replication.'
	   else 'Postgres is _not_ set up for replication' end
	   as "Replication mode";

select case count(*) when 0 then
 	   'The connection to {{ pgrep_peer_host}} is broken.'
	   else
	   'The connection to {{ pgrep_peer_host }} is up.'
	   end as "Connection status"
	   from pg_stat_wal_receiver where slot_name='{{ pgrep_peer_slot }}';

select pg_last_xact_replay_timestamp() as "Last update from {{ pgrep_peer_host }}";


{{ pgrep_extra_sql | default('') }}
