select 
pool_mon.GNMA_POOL_NUMBER as PAR_Pool_Number,
sum(part_mon.UPB) as PAR_Participation_UPB,
pool_mon.GNMA_POOL_NUMBER as SAR_Pool_Number,
MAX(pool_mon.SECURITY_ENDING_RPB) as Sar_Security_Ending_RPB
FROM 
SERV_POOL_MONTH pool_mon
join 
SERV_PARTICIPATION_MONTH part_mon
on pool_mon.GNMA_POOL_NUMBER = part_mon.GNMA_POOL_NUMBER
where pool_mon.RECORD_DATE is not null and 
pool_mon.RECORD_DATE between ? and ?
group by pool_mon.GNMA_POOL_NUMBER 