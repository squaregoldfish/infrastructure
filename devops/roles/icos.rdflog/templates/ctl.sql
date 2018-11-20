-- This file contains sql code that is used by the rdflog 'ctl' script.
--
-- The code is meant to be installed into a running rdflog database. It uses its
-- own schema ('ctl') to avoid mixing its definitions with the rdflog proper.

\connect rdflog

create schema if not exists ctl;

-- RDFLog contains about 20 identical tables, only differing in name. Each table
-- has a timestamp field. This function will build a query that goes through
-- each table and find the name and the latest timestamp for each table.
create or replace function ctl.latest_timestamps_query() returns text as
$$
DECLARE
	all_rdflog_tables CURSOR FOR
	select row_number() over () as row, pg_tables.tablename
    from pg_tables where schemaname = 'public'
	order by tablename;
    q text;
begin
	q := '';
	for t in all_rdflog_tables loop
		if (t.row > 1) then
			q := q || E'\nunion\n';
	    end if;
		q := q || format($f$select '%I', max(tstamp) from %I$f$,
	                     t.tablename, t.tablename);
	end loop;
	return q;
end;
	$$ language 'plpgsql';


-- Find the name and latest timestamp of each table in RDFLog.
create or replace function ctl.latest_timestamps(
  out tname text,
  out tstamp timestamp with time zone) returns setof record language plpgsql as
$$
declare q text;
begin
    return query execute ctl.latest_timestamps_query();
end
$$;
