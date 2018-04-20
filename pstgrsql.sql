drop function test();
drop table tester;

create temp table tester (tim interval);

CREATE OR REPLACE FUNCTION test()
RETURNS
	--TABLE (test1 int, test2 interval) AS $$
	INTERVAL AS $$
DECLARE
	startTime timestamp;
	endTime timestamp;
	delta interval;
	test int;
BEGIN
	for i in 1..5 loop
		startTime := clock_timestamp();
		SELECT COUNT(unique3)
		FROM wisc1000k
		WHERE unique2 < 1000000
		INTO test;
		endTime := clock_timestamp();
		delta := 1000 * (extract(epoch from endTime)-extract(epoch from startTime));
		RAISE NOTICE 'Duration in milliseconds=%', delta;
		Insert into tester values(delta);
		RETURN delta;
	end loop;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM test();
SELECT * FROM tester;