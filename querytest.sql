-- Clean buffers
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE

-- Declare variables; only once per script
declare @startdate datetime
declare @enddate datetime
declare @time numeric(15,3)
declare @run int=0

declare @output table (run INT, startdate datetime, enddate datetime, timed numeric(15,3))

WHILE @run	< 5
BEGIN
	-- Starting time
	set @startdate=GETDATE()

	-- Query
	SELECT COUNT(UNIQUE1)
	from Wisc1000K
	where ONE_PERC < 50

	--- End time; print the difference
	set @enddate=GETDATE()
	set @time=(CONVERT(numeric(15,8), @enddate)-CONVERT(numeric(15,8), @startdate))*(24.0*60.0*60.0)
	--select @run, @startdate, @enddate, @time
	INSERT into @output (run, startdate, enddate, timed)
	VALUES (@run, @startdate, @enddate, @time)

	SET @run = @run + 1
END;

select run, startdate, enddate, timed
from @output