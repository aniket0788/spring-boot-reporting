select
rls.LOAN                  as  loan,
lnf.PRIOR_SERVICER_NUM    as  client_loannum,
rlsm.LOAN_BALANCE         as  cur_total_upb,
brwr.FIRST_NAME           as  BORROWER_FIRST_NAME,
prp.PROP_STATE             as PROP_STATE,
mas.ACINVESTORCODE        as  investor,
rlsm.INT_RATE             as  cur_int_rate,
rlsm.MON_INTEREST         as  acc_int,
rlsm.MON_MIP              as  mip_rate,
rlsm.MIP_BAL              as  mip,
rlsm.MON_SERV_FEE         as  service_fees,
rlsm.LOAN_BALANCE+rlsm.INT_RATE+rlsm.MON_MIP+rlsm.MON_SERV_FEE  as  total_loan,
masv.MAX_CLAIM_AMOUNT     as mca,
round((rlsm.LOAN_BALANCE+rlsm.INT_RATE+rlsm.MON_MIP+rlsm.MON_SERV_FEE)/masv.MAX_CLAIM_AMOUNT,2) as mca_percent,
rls.LOAN_STATUS           as loan_status,
(case
When rls.LOAN_STATUS ='0'
Then 'Active'
Else 'InActive'
end)                      as category,
flmas5.date_              as fcl_1stlegal_date,
fcmas5.date_              as fc1_confirmed_saledate,
mask.ACMERSCODE           as  min_nbr
from REVLOANSERVICING rls
inner join REVLOANSERVICINGMONTH rlsm on rls.loan=rlsm.LOAN and rlsm.HISTORY='L'and rlsm.ITEM='zzz' and rlsm.STATUS=1 and rlsm.RECORD_DATE between ? and ?
left join MAS3_CD mas on mas.LOAN =rlsm.loan and mas.HISTORY='L' and mas.ITEM='zzz' and mas.STATUS=1
left join loan_info lnf on lnf.LOAN = rlsm.loan
left join MASV_CD  masv on masv.LOAN=rlsm.LOAN and masv.HISTORY='L' and masv.ITEM='zzz' and masv.STATUS=1
left join BRW1_CD brwr on brwr.LOAN=rlsm.LOAN and brwr.HISTORY='L' and brwr.ITEM='zzz' and brwr.STATUS=1 and brwr.brwr_no in ('1','01')
left join PRP1_CD prp on prp.LOAN=rlsm.LOAN and prp.HISTORY='L' and prp.ITEM='zzz' and prp.PROP_CODE in('001')
left join(select loan,date_,history,item,status from MAS5_CD  where DATE_CDE='F87' and OCCURANCE=01) flmas5 on flmas5.loan=rlsm.LOAN and  flmas5.history='L' and flmas5.item='zzz' and flmas5.status=1
left join(select loan,date_,history,item,status from MAS5_CD  where DATE_CDE='F75' and OCCURANCE=01) fcmas5 on fcmas5.loan=rlsm.LOAN and  fcmas5.history='L' and fcmas5.item='zzz' and fcmas5.status=1
left join MASK_CD mask on mask.loan=rls.loan and mask.HISTORY='L' and mask.ITEM='zzz' and mask.STATUS=1