select rls.LOAN     as  loan_no,
(CASE
  WHEN EXTRACT(day FROM ?)>15
  THEN (CASE WHEN rlsts.OLD_LOAN_STATUS is not null THEN rlsts.OLD_LOAN_STATUS ELSE rls.loan_status END)
  ELSE  (rls.loan_status) 
END)                as  loan_sts_mid_mon,
rls.loan_status     as  loan_sts_end_mon,
(CASE WHEN EXTRACT(day FROM ?)>15 and rlsts.OLD_LOAN_STATUS is not null and rlsts.OLD_LOAN_STATUS!=rls.loan_status
      THEN  'Check'
      ELSE  'Match'
END)                    as  change_sts,
rls.LOAN_BALANCE        as  upb,
masv.MAX_CLAIM_AMOUNT   as  mca,
(CASE
      WHEN  masv.MAX_CLAIM_AMOUNT>0
      THEN  round((rls.LOAN_BALANCE+rls.INT_RATE+rls.MIP_BAL+rls.SERV_FEE_BAL)/masv.MAX_CLAIM_AMOUNT,2)
      ELSE
      0
END)                    as  mca_percent,
masv.EXP_CLOSE_DATE     as  due_close_date,
scm7_cd.WIRE_DATE       as  wire_date,
brw.FIRST_NAME          as  bor_firstname,
brw.LAST_NAME           as  bor_lastname,
prp.PROP_ADDR           as  prop_address,
prp.PROP_CITY           as  prop_city,
prp.PROP_STATE          as  prop_state,
prp.PROP_ZIP            as  prop_zipcode
from REVLOANSERVICING rls 
left join (
select curr_status ,loan, NEW_LOAN_STATUS,OLD_LOAN_STATUS from (select loan,new_loan_status,OLD_LOAN_STATUS,(ROW_NUMBER() OVER(PARTITION BY LOAN ORDER BY TRAN_DATE DESC)) As curr_status from REVLOANSTATUS where TRAN_DATE between ? and  ?)
where curr_status=1 )rlsts on rls.loan=rlsts.loan
left join SCM7_CD scm7_cd on  rls.LOAN=scm7_cd.LOAN and scm7_cd.HISTORY='L' and scm7_cd.ITEM='zzz' and scm7_cd.STATUS=1
left join MASV_CD  masv on rls.LOAN=masv.LOAN and masv.HISTORY='L' and masv.ITEM='zzz' and masv.STATUS=1
left join BRW1_CD brw on rls.LOAN=brw.LOAN and brw.HISTORY='L' and brw.ITEM='zzz' and brw.STATUS=1
left join PRP1_CD  prp on rls.loan=prp.LOAN and prp.HISTORY  = 'L' AND prp.ITEM = 'zzz' AND prp.PROP_STATUS = '1'
where rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1