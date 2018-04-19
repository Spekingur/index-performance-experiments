USE Project1
-- Clean buffers; just in case
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE

-- Declare variables; only once per script
declare @startdate datetime
declare @enddate datetime
declare @time numeric(15,3)
declare @run int=0
declare @run2 int=0
declare @value int=0

declare @output table (r1_value INT, run INT, startdate datetime, enddate datetime, timed numeric(15,3))
declare @temp table (temp_v INT)

WHILE @run2 < 25
BEGIN
-- Clean buffers; need to do it for each value
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE

	WHILE @run < 5
	BEGIN
		-- Starting time
		set @startdate=GETDATE()

		-- Query; inserting results into a table to lower result clutter
		INSERT INTO @temp (temp_v) -- Creates some overhead but is consistent for all
		SELECT COUNT(UNIQUE3)
		--FROM Wisc1000K WITH (INDEX(IX_Wisc1000Ka)) --trying to force unclustered
		--FROM Wisc1000K WITH (INDEX(PK_Wisc1000Ka)) --trying to force clustered
		FROM Wisc1000K WITH (INDEX(0)) --trying to force table scan
		--WHERE UNIQUE1 <= @value
		--WHERE UNIQUE2 <= @value
		WHERE UNIQUE3 <= @value

		--- End time; put results into a table
		set @enddate=GETDATE()
		set @time=(CONVERT(numeric(15,8), @enddate)-CONVERT(numeric(15,8), @startdate))*(24.0*60.0*60.0)
		INSERT into @output (r1_value, run, startdate, enddate, timed)
		VALUES (@value, @run, @startdate, @enddate, @time)

		SET @run = @run + 1
	END;

--- Value check; changing value so it will increment up to 1 million in different increments
if @value < 10000
	SET @value = @value + 1000
else if @value < 50000
	SET @value = @value + 10000
else if @value < 100000
	SET @value = @value + 50000
else 
	SET @value = @value + 100000
SET @run2 = @run2 + 1
SET @run = 0
END;

--- Display results
select r1_value, run, startdate, enddate, timed
from @output