select
m.loan as loan_num,
l.prior_servicer_num as client_loan_nbr,
m.case_no as FHA_CASE_NBR,
m.ACINVESTORCODE as pool_name,
rls.LOAN_STATUS as loan_status,
rls.LOAN_BALANCE as current_total_upb
from
mas3_cd m
inner join scm7_cd s on m.loan = s.loan and s.history = 'L' and s.item='zzz' and s.status=1
inner join revloanservicing rls on s.loan=rls.loan and rls.LOAN_STATUS in ('70','71','72','73','104','110','60')
left outer join loan_info l on m.loan = l.loan
where m.history = 'L' and m.ITEM='zzz' and m.STATUS=1