EXPLAIN ANALYZE
select count(unique3)
from wisc1000k -- can't force indexes
where unique3 <= 200000; -- unclustered index
--where unique2 <= v_value; -- clustered index
--where unique3 <= v_value; -- no index; may need to set enable_seqscan to false