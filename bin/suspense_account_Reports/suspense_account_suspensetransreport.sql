select
rls.loan          as loan_number,
scm.THEIR_LOAN_NO as investor_code,
scm.INVESTOR_CODE as pool_name,
rls.LOAN_STATUS   as loan_status,
BORROWER_SUSPENSE as suspense_balance,
'108'             as trans_code
from REVLOANSERVICING rls
inner join SCM7_CD scm on rls.LOAN=scm.LOAN and scm.HISTORY='L' and scm.ITEM='zzz' and scm.STATUS=1
inner join MISC_BALANCES misc on scm.LOAN=misc.LOAN and misc.BORROWER_SUSPENSE is not null and misc.BORROWER_SUSPENSE>0
where rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1

union All

select
rls.loan          as loan_number,
scm.THEIR_LOAN_NO as investor_code,
scm.INVESTOR_CODE as pool_name,
rls.LOAN_STATUS   as loan_status,
CLAIMS_SUSPENSE   as suspense_balance,
'109'             as trans_code
from REVLOANSERVICING rls
inner join SCM7_CD scm  on rls.LOAN=scm.LOAN and scm.HISTORY='L' and scm.ITEM='zzz' and scm.STATUS=1
inner join MISC_BALANCES misc on scm.LOAN=misc.LOAN and misc.CLAIMS_SUSPENSE is not null and misc.CLAIMS_SUSPENSE>0
where rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1