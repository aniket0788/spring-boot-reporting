select
rls.LOAN_STATUS                 as  loan_status,
rlp.INT_OR_MIP_RATE             as  mip_rate,
rlsm.MON_UNSCHD_PMNT            as  unSche_pmnt,
scm.THEIR_LOAN_NO               as  investor_number,
rlsm.MON_UNSCHD_PMNT            as  fnma_adjust
from REVLOANSERVICING rls
inner join SCM7_CD scm on rls.LOAN=scm.LOAN
inner join REVLOANPAYMENTS rlp  on scm.LOAN=rlp.LOAN
inner join REVLOANSERVICINGMONTH rlsm on rlp.LOAN=rlsm.LOAN and rlsm.HISTORY='L' and rlsm.ITEM='zzz' and rlsm.STATUS=1 and rlsm.RECORD_DATE between ? and ?