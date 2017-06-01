select
rls.LOAN                as    loan_number,
mas.ACINVESTORCODE                as    pool_name,
mas.CASE_NO                       as    fha_case_number,
prp.PROP_STATE                    as    property_state,
rls.INT_RATE                      as    cur_int_rate,
scm.THEIR_LOAN_NO                 as    investor_loan_num,
brw.LAST_NAME                     as    bor_last_name,
rls.LOAN_STATUS                   as    loan_status,
rls.PMNT_PLAN                     as    pay_plan,
--revplch.NEW_PMNT_PLAN             as    product_type,
mas.LOAN_TYPE                     as    product_type,
mas.ORIG_REC_DATE                 as    origination_date,
masc.DUE_DATE                     as    due_date,
scm.UPB                           as    tot_loan_bal,
masv.MAX_CLAIM_AMOUNT             as    mca,
(CASE
  WHEN masv.MAX_CLAIM_AMOUNT=0
  THEN 0
  ELSE
  ROUND(rls.LOAN_BALANCE/masv.MAX_CLAIM_AMOUNT,2)
END)                             as   percent_mca ,
rls.LOAN_BALANCE                 as   cur_balance,
scm.LNETPROCEEDS                 as   sales_proceeds_amt,
prp.PROP_ZIP                     as   prop_zipcode
from REVLOANSERVICINGMONTH rls
inner join MAS3_CD mas on mas.LOAN=rls.LOAN and rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1
inner join SCM7_CD scm on scm.LOAN=mas.LOAN and mas.HISTORY='L' and mas.ITEM='zzz' and mas.STATUS=1
left join BRW1_CD brw on brw.LOAN=rls.loan and brw.HISTORY='L' and brw.ITEM='zzz' and brw.STATUS=1 and brw.BRWR_NO in('01','1')
left join MASV_CD masv  on masv.LOAN=rls.LOAN and masv.HISTORY=rls.HISTORY and masv.ITEM=rls.ITEM and masv.STATUS=rls.STATUS
left join PRP1_CD prp on prp.LOAN=rls.LOAN and prp.HISTORY=rls.HISTORY and rls.ITEM=rls.ITEM
--left join REVPLANCHANGE revplch on rls.LOAN=revplch.LOAN and revplch.HISTORY='L' and revplch.ITEM='zzz' and revplch.STATUS=1
left join( select max(DUE_DATE) as DUE_DATE,LOAN,HISTORY,ITEM,STATUS from MASC_CD group by LOAN, HISTORY, ITEM, STATUS) masc on  masc.LOAN=rls.LOAN and masc.HISTORY='L' and masc.ITEM='zzz' and masc.STATUS=1
where rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1 and rls.RECORD_DATE between ? and ?