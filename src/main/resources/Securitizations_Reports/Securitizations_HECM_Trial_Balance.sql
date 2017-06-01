select 
revloanmonth.loan                      			as Loanno,
revloanmonth.INT_RATE					 		as Note_rate,
revprevmonth.PREVBALANCE          	 			as PRIOR_MONTH_TOTAL_UPB,
revloanmonth.MON_INTEREST              			as Interest,
revloanmonth.MON_MIP                   			as MIP,
revloanmonth.MON_SERV_FEE              			as Service_fee,
revloanmonth.MON_SCHD_PMNT             			as MONTHLY_SCHEDULED_PAYMENT,
revforeclosure.foreclosure_attorney_fee 		as foreclosure_attorney_fee ,
revservicing.servicing_advances 				as servicing_advances,
revprincipalpmt.PRINCIPAL_PAYMENTS 				as PRINCIPAL_PAYMENTS,
revproceeds.Paid_in_Full_Proceeds 				as Paid_in_Full_Proceeds,
revshortsale.short_sale_proceeds 				as short_sale_proceeds,
revreosales.reo_sales_proceeds 					as reo_sales_proceeds, 
revinitclaim.Initial_Claim_Proceeds 			as Initial_Claim_Proceeds, 
revloanmonth.LOAN_BALANCE   					as CURRENT_TOTAL_UPB,
revmonappr.appraisal_date       				as Most_Recent_Appr_Date,
revmonappr.appr_val   		 					as Most_Recent_Appr_Value,
revmonappr.appr_type							as Appr_Type,
revmonmaxupb.maxupbloan           				as curr_max_upb_loanno,
revloanmonth.LOAN_STATUS			 			as STATUS_DESCRIPTION, 
revloanstat.called_due_date                		as CALLED_DUE_DATE,
revloanstat.called_due_upb               		as CALLED_DUE_UPB,
revloanliquidstat.liquid_status_date            as Liquid_Status_Date,
revprepmt.REO_received_date 					as REO_received_date,
revservmon.mortgage_assigned_date 				as mortgage_assigned_date 

from REVLOANSERVICINGMONTH revloanmonth 

join 
  (
    (
      select revmonth.LOAN_BALANCE as PREVBALANCE, revmonth.loan as revprevmonthloanno 
      from REVLOANSERVICINGMONTH revmonth 
      where RECORD_DATE = ?
    ) revprevmonth
  )
   on revloanmonth.LOAN = revprevmonthloanno

join 
  (
     (
        select sum(revforeclosure.amount) foreclosure_attorney_fee , revforeclosure.loan as revloanno
         from 
        REVLOANPAYMENTS revforeclosure
        where revforeclosure.post_date between ? and ? and         
       	revforeclosure.pay_type='95'
        group by revforeclosure.loan
      ) revforeclosure
  ) 
  on revloanmonth.LOAN = revloanno
join 
  (
     (
        select sum(revservicing.amount) servicing_advances , revservicing.loan as revloanservicingno
         from 
        REVLOANPAYMENTS revservicing
        where revservicing.post_date between ? and ? and         
       	revservicing.pay_type in ('40','90','91','92','93','94','96')
        group by revservicing.loan
      ) revservicing
  ) 
  on revloanmonth.LOAN = revloanservicingno
 join 
  (
     (
        select sum(revprincipalpmt.amount) PRINCIPAL_PAYMENTS, revprincipalpmt.loan as revloanprincipalno
         from 
        REVLOANPAYMENTS revprincipalpmt
        where revprincipalpmt.post_date between ? and ? and         
       	revprincipalpmt.pay_type in ('80','81','82','83','84')
        group by revprincipalpmt.loan
      ) revprincipalpmt
  ) 
  on revloanmonth.LOAN = revloanprincipalno
join 
  (
     (
        select sum(revproceeds.amount) Paid_in_Full_Proceeds, revproceeds.loan as revloanpaidno
        from 
        REVLOANPAYMENTS revproceeds
        where revproceeds.post_date between ? and ? and         
       	revproceeds.pay_type in ('31','32','33','34')
        group by revproceeds.loan
      ) revproceeds
  ) 
  on revloanmonth.LOAN = revloanpaidno
join 
  (
     (
        select sum(revshortsale.amount) short_sale_proceeds, revshortsale.loan as revloanshortsale
         from 
        REVLOANPAYMENTS revshortsale
        where revshortsale.post_date between ? and ? and         
       	revshortsale.pay_type in ('80A')
        group by revshortsale.loan
      ) revshortsale
  ) 
 on revloanmonth.LOAN = revloanshortsale
 join 
  (
     (
        select sum(revreosales.amount) reo_sales_proceeds, revreosales.loan as revloanreosale
         from 
        REVLOANPAYMENTS revreosales
        where revreosales.post_date between ? and ? and         
       	revreosales.pay_type in ('80C')
        group by revreosales.loan
      ) revreosales
  ) 
  on revloanmonth.LOAN = revloanreosale
  join 
  (
     (
        select sum(revinitclaim.amount) Initial_Claim_Proceeds, revinitclaim.loan as revloaninitclaim
         from 
        REVLOANPAYMENTS revinitclaim
        where revinitclaim.post_date between ? and ? and         
       	revinitclaim.pay_type in ('80D')
        group by revinitclaim.loan
      ) revinitclaim
  ) 
  on revloanmonth.LOAN = revloaninitclaim
  join 
  (
     (
        select sum(revsupclaim.amount) Supplemental_Claim_Proceeds,revsupclaim.loan as revloansupclaim
         from 
        REVLOANPAYMENTS revsupclaim
        where revsupclaim.post_date between ? and ? and         
       	revsupclaim.pay_type in ('80E')
        group by revsupclaim.loan
      ) revsupclaim
  ) 
  on revloanmonth.LOAN = revloansupclaim
join
  (
    (select max(revprepmt.post_date) as REO_received_date, revprepmt.loan as revloannopre
        from 
        REVLOANPREPAYMENTS revprepmt
        where revprepmt.post_date between ? and ? and         
        revprepmt.PREPAY_TYPE in ('80C')
        group by revprepmt.loan
    ) revprepmt
  )
  on revloanmonth.LOAN = revloannopre
join
  (
    (select MAX(revservmon.record_date) as mortgage_assigned_date, revservmon.loan as revloannoserv
        from 
        REVLOANSERVICINGMONTH revservmon
        where revservmon.record_date between ? and ? and         
        revservmon.LOAN_STATUS='72'
        group by revservmon.loan
    ) revservmon
  )
  on revloanmonth.LOAN = revloannoserv
  join
  (
    (select revmonmaxupb.loan as maxupbloan
        from 
        REVLOANSERVICINGMONTH revmonmaxupb
        where revmonmaxupb.record_date between ? and ? and
        revmonmaxupb.loan_balance = (select max(loan_balance) from REVLOANSERVICINGMONTH)
    ) revmonmaxupb
  )
  on revloanmonth.LOAN = maxupbloan
  join
  (
    (select revloanstat.post_date as called_due_date, revloanstat.loan as revloanstatno, revmonth.loan_balance as called_due_upb
        from 
        REVLOANSTATUS revloanstat join revloanservicingmonth revmonth
        on revloanstat.loan = revmonth.loan
        where revloanstat.post_date between ? and ? and         
        revloanstat.new_loan_status in ('55', '56', '57A', '57B', '57C', '58A', '58B', '58D')
    ) revloanstat
  )
  on revloanmonth.LOAN = revloanstatno
 join
  (
    (select max(revloanliquidstat.post_date) as liquid_status_date, revloanliquidstat.loan as revloanliquidno
        from 
        REVLOANSTATUS revloanliquidstat
        where revloanliquidstat.post_date between ? and ? and         
        revloanliquidstat.new_loan_status in ('60', '70', '71', '72', '74')
        group by revloanliquidstat.loan
    ) revloanliquidstat
  )
  on revloanmonth.LOAN = revloanliquidno
 join
  (
   (select appraisal_date,appr_val,appr_type,revloanapprno from
	(select revmonappr.APPRAISAL_DATE as appraisal_date, revmonappr.MKT_VALUE as appr_val, revmonappr.loan revloanapprno,
      CASE
      WHEN revmonappr.APPRAISAL_DATE IS NULL THEN 'ORIGINAL' ELSE 'UPDATED' END as appr_type,
      (CASE
      WHEN scm7inv.investor_code = 'HECM Trust 2015-1' THEN '30-APR-2015'
      WHEN scm7inv.investor_code = 'HECM Trust 2015-2' THEN '30-SEP-2015'
      WHEN scm7inv.investor_code = 'HECM Trust 2016-1' THEN '31-DEC-2015'
      WHEN scm7inv.investor_code = 'HECM Trust 2016-2' THEN '30-APR-2016'
      WHEN scm7inv.investor_code = 'HECM Trust 2016-3' THEN '30-JUN-2016'
      --else '01-JAN-1971'
      END) as investor_date
        from 
        REVLOANSERVICINGMONTH revmonappr
        INNER JOIN REVLOANPREPAYMENTS revprepmnt on revmonappr.loan=revprepmnt.loan
        INNER JOIN SCM7_CD scm7inv on revmonappr.LOAN=scm7inv.LOAN
        where
        revmonappr.record_date between ? and ?
        and
        revmonappr.loan_status NOT IN ('0','60','50','51','52','53','61','62','63','64','72')
        and
        revprepmnt.prepay_type NOT IN ('31','32','33','34')
        and
        scm7inv.investor_code = ?) tmp
        where
        tmp.appraisal_date > tmp.investor_date
    ) revmonappr
  )
  on revloanmonth.LOAN = revloanapprno

inner join SCM7_CD scm7cd on revloanmonth.LOAN=scm7cd.LOAN
where 
scm7cd.investor_code = ? and 
revloanmonth.RECORD_DATE BETWEEN ? and ?