select
msd.LOAN                    as  loan_num,
scd.THEIR_LOAN_NO           as  investor_loannum,
scd.THEIR_LOAN_NO           as  gnma_loannum,
sch_mon_adv.amount          as  scheduled_monthly_advance,
sch_mon_adv.disb_term_remaining,
msd.FIRST_PMNT_DATE         as  first_payment_date,
sch_mon_adv.total_monthly_advances_date,
sch_mon_adv.total_unscheduled_advances,
sch_mon_adv.total_monthly_advances_date+sch_mon_adv.total_unscheduled_advances  as  total_advances,
sch_mon_adv.service_fee                   as  mon_serv_fee,
rls.INT_RATE                              as  growth_rate,
mad.MAX_CLAIM_AMOUNT                      as  current_max_claim,
sch_mon_adv.mip                           as  mip,
sch_mon_adv.current_bal,
sch_mon_adv.current_avail_loc,
rlp.last_draw,
sch_mon_adv.current_rate,
msd.NO_INT_CHANGES                        as  rate_adj_freq,
msd.INIT_INDEX                            as  int_index,
msd.MARGIN                                as  margin,
msd.LIFE_CAP                              as  ceiling_rate,
msd.LIFE_FLOOR                            as  floor_rate,
msd.INDEX_TYPE                            as  rate_type,
msd.LOAN_TYPE                             as  product_type,
rbs.DATE_OF_DEATH                         as  borrower_dod,
rls.LOAN_STATUS                           as  loanb_sts,
sch_mon_adv.current_service_fee_sa,
sch_mon_adv.current_repair_sa,
sch_mon_adv.current_ti_sa,
sch_mon_adv.current_pl,
sch_mon_adv.accrued_interest,
sch_mon_adv.mip_accrued,
sch_mon_adv.service_fee_accrued,
msd.PERIOD_CAP                          as  periodic_cap,
mad.FUNDING_DATE                        as  funding_date,
prp.MKT_VALUE                           as  most_recent_appr_val,
msd.ORIG_TERM                           as  original_term_payments,
sch_mon_adv.property_charges_sa,
msd.LIFE_CAP                            as  interest_maximum,
mad.EXP_AVG_INT_RATE                    AS  expected_rate,
revpmt.PAY_TYPE                         as  pay_type,
--rlsm.APPRAISAL_DATE                     as
sch_mon_adv.appraisal_date,
mad.HECM_REFI_YES_NO                    as  hecm_saver_flag
from MAS3_CD msd
inner join  (select loan,history,item,status,sum(MON_SCHD_PMNT) as amount, sum(MON_SERV_FEE) as service_fee,
              sum(MON_MIP) as mip, LOAN_BALANCE as current_bal, NET_LOC as current_avail_loc,INT_RATE as current_rate,
              SERV_FEE_SA as current_service_fee_sa,REPAIR_SA as current_repair_sa,LOC_TAX_INS_SA as current_ti_sa,
              PRIN_LIMIT as current_pl,INTEREST_BAL as accrued_interest,MIP_BAL as mip_accrued,SERV_FEE_BAL as service_fee_accrued,
              PROP_CHRG_SA as property_charges_sa,APPRAISAL_DATE as appraisal_date,LEN_OF_TERM as disb_term_remaining,SCHD_PMNT_BAL as total_monthly_advances_date,UNSCHD_PMNT_BAL as total_unscheduled_advances
              from REVLOANSERVICINGMONTH
              where item='zzz' and history='L' and status=1 and RECORD_DATE between ? and ? and LOAN_STATUS not in('110')
              group by loan, history, item, status, LOAN_BALANCE,NET_LOC, INT_RATE, SERV_FEE_SA, REPAIR_SA, LOC_TAX_INS_SA,PRIN_LIMIT, INTEREST_BAL, MIP_BAL, SERV_FEE_BAL, PROP_CHRG_SA,APPRAISAL_DATE, LEN_OF_TERM, SCHD_PMNT_BAL, UNSCHD_PMNT_BAL
            )sch_mon_adv on msd.LOAN=sch_mon_adv.loan
inner join SCM7_CD scd on scd.LOAN=sch_mon_adv.LOAN and scd.HISTORY='L' and scd.ITEM='zzz' and scd.STATUS=1
inner join REVLOANSERVICING rls on rls.loan=scd.loan and rls.HISTORY='L' and rls.ITEM='zzz' and rls.STATUS=1
inner join MASV_CD mad on  rls.loan=mad.loan and mad.HISTORY='L' and mad.ITEM='zzz' and mad.STATUS=1
inner join PRP1_CD prp on mad.LOAN=prp.LOAN and prp.HISTORY='L'
left join REVBRWRSERVICING rbs on prp.loan=rbs.loan and rls.HISTORY='L' and rbs.ITEM='zzz' and rbs.STATUS=1 and BRWR_NO in('01','1')
left join  (
              select  max(lst_drw) as last_draw,loan  from (
                select max(TRAN_DATE) as lst_drw,loan from REVLOANPAYMENTS where HISTORY='L' and item='zzz' and status=1 and  TRAN_DATE BETWEEN ? and ? GROUP BY loan
                 union
                select max(TRAN_DATE)as lst_drw,loan from REVLOANPREPAYMENTS where HISTORY='L' and item='zzz' and status=1 and  TRAN_DATE BETWEEN ? and ? GROUP BY loan
              ) group by loan
            ) rlp on prp.loan=rlp.LOAN
left join (
              select LISTAGG(PAY_TYPE,'/') within group(order by loan) PAY_TYPE,LOAN from REVLOANPAYMENTS where HISTORY='L' and ITEM='zzz' and STATUS=1 and TRAN_DATE BETWEEN ? and ? group by LOAN
          ) revpmt on prp.LOAN=revpmt.LOAN
where msd.HISTORY='L' and msd.ITEM='zzz' and msd.STATUS=1