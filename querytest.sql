
-- Declare variables; only once per script
declare @startdate datetime
declare @enddate datetime
declare @time numeric(15,3)
declare @run int=0
declare @run2 int=0
declare @value int=1000

declare @output table (r1_value INT, run INT, startdate datetime, enddate datetime, timed numeric(15,3))

WHILE @run2 < 24
BEGIN
-- Clean buffers
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE

	WHILE @run	< 5
	BEGIN
		-- Starting time
		set @startdate=GETDATE()

		-- Query
		SELECT COUNT(UNIQUE3)
		from Wisc1000K
		--where ONE_PERC < 50
		--where TWENTY_PERC < 4
		--where R1 < 200000
		where R1 < @value

		--- End time; print the difference
		set @enddate=GETDATE()
		set @time=(CONVERT(numeric(15,8), @enddate)-CONVERT(numeric(15,8), @startdate))*(24.0*60.0*60.0)
		--select @run, @startdate, @enddate, @time
		INSERT into @output (r1_value, run, startdate, enddate, timed)
		VALUES (@value, @run, @startdate, @enddate, @time)

		SET @run = @run + 1
	END;
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
select r1_value, run, startdate, enddate, timed
from @output