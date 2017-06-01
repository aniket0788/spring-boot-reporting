select
rls.loan as loan_num,
mas.CASE_NO as fha_caseno,
mas.ACINVESTORCODE as pool
from REVLOANSERVICINGMONTH rls
left join mas3_cd mas on rls.LOAN=mas.LOAN and mas.HISTORY='L' and mas.ITEM='zzz' and mas.STATUS=1
where rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1 and rls.RECORD_DATE between ? and ?