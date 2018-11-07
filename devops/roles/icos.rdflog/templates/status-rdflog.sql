-- RDFLog contains about 20 identical tables, only differing in name. Each table
-- has a timestamp field. This function will build a query that goes through
-- each table and find the name and the latest timestamp for each table.
create or replace function _latest_timestamps_query() returns text as
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
create or replace function _latest_timestamps(
  out tname text,
  out tstamp timestamp with time zone) returns setof record language plpgsql as
$$
declare q text;
begin
    return query execute _latest_timestamps_query();
end
$$;

\echo -- The latest updates for each rdf table --
\echo

select _latest_timestamps_query() != '' as have_tables \gset
\if :have_tables
  \echo The latest timestamp in each table are:
  select * from _latest_timestamps() order by tstamp desc;
\else
  \echo 'No rdflog tables present! (maybe restore a backup?)'
\endif
