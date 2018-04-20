drop table if exists outputs;
drop table if exists temps;
drop function if exists test();

-- set enable_seqscan=false;
-- set enable_seqscan=true;

create or replace function test()
returns
	table (r int, run int, startdate timestamp(3), enddate timestamp(3), timed numeric(15,3)) as $$
declare
	v_startdate timestamp(3);
	v_enddate timestamp(3);
	v_time numeric(15,3);
	v_run int=0;
	v_run2 int=0;
	v_value int=0;
BEGIN
	create temp table outputs(r1_value int, run int, startdate timestamp(3), enddate timestamp(3), timed numeric(15,3));
	create temp table temps(temp_v int);
	WHILE v_run2 < 25
	LOOP
		WHILE v_run < 5
		LOOP
			v_startdate:=clock_timestamp(); --NOW();
			insert into temps
			select count(unique3)
			from wisc1000k -- can't force indexes
			where unique1 <= v_value; -- unclustered index
			--where unique2 <= v_value; -- clustered index
			--where unique3 <= v_value; -- no index; may need to set enable_seqscan to false
			v_enddate:=clock_timestamp(); --NOW();
			--v_time:=(CONVERT(numeric(15,8), v_enddate)-CONVERT(numeric(15,8), v_startdate))*(24.0*60.0*60.0);
			v_time:=(EXTRACT(SECONDS FROM v_enddate)-EXTRACT(SECONDS FROM v_startdate));
			insert into outputs(r1_value, run, startdate, enddate, timed)
			values (v_value, v_run, v_startdate, v_enddate, v_time);
			
			v_run := v_run + 1;
		END LOOP;
	if v_value < 10000 then
		v_value := v_value + 1000;
	elsif v_value < 50000 then
		v_value := v_value + 10000;
	elsif v_value < 100000 then
		v_value := v_value + 50000;
	else
		v_value := v_value + 100000;
	end if;
	v_run2 := v_run2 + 1;
	v_run := 0;
	END LOOP;
RETURN QUERY SELECT * FROM outputs;
drop table if exists outputs;
drop table if exists temps;
END;
$$ LANGUAGE plpgsql;

select * from test();
--select * from outputs;			
