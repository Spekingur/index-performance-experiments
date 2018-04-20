drop table if exists outputs;
drop table if exists temps;
drop function if exists test();

create temp table outputs(r1_value int, run int, startdate timestamp(3), enddate timestamp(3), timed numeric(15,3));
create temp table temps(temp_v int);

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
	WHILE v_run2 < 25
	LOOP
		WHILE v_run < 5
		LOOP
			v_startdate:=NOW();
			insert into temps
			select count(unique3)
			from wisc1000k
			where unique3 <= v_value;
			v_enddate:=NOW();
			--v_time:=(CONVERT(numeric(15,8), v_enddate)-CONVERT(numeric(15,8), v_startdate))*(24.0*60.0*60.0);
			v_time:=(EXTRACT(MILLISECONDS FROM v_enddate)-EXTRACT(MILLISECODS FROM v_startdate));
			insert into outputs(r1_value, run, startdate, enddate, timed)
			values (v_value, v_run, v_startdate, v_enddate, v_time);
			
			v_run := v_run + 1;
		END LOOP;
	if v_value < 10000 then
		v_value := v_value + 1000;
	else if v_value < 50000 then
		v_value := v_value + 10000;
	else if v_value < 100000 then
		v_value := v_value + 50000;
	else
		v_value := v_value + 100000;
	end if;
	v_run2 := v_run2 + 1;
	v_run := 0;
	END LOOP;
RETURN outputs;
END;
$$ LANGUAGE plpgsql;

select * from test();
			
