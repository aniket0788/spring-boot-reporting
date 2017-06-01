SELECT     4                                              AS transaction_designator, 
           scm7_cd.their_loan_no                          AS fannie_mae_loan_number,
           '268800000'									  AS servicer_number,
           to_char(to_date(?),'YYYYMM')				 	  AS report_period, 
           to_char(plnchg.post_date,'YYYYMMDD')           AS effective_date, 
           plnchg.payment_plan                            AS payment_plan, 
           plnchg.new_mon_pmnt                            AS schedule_payment, 
           plnchg.new_len_of_term                         AS term, 
           plnchg.new_loc_reserve                         AS line_of_credit_reserve_amount, 
           plnchg.tax_ins_amount                          AS insurance_withholding_amount, 
           null                         				  AS insurance_withholding_percent, 
           null  										  AS withholding_from_date, 
           null 										  AS withholding_to_date 
FROM       scm7_cd 
inner join ( 
           ( 
                    SELECT   revplanchange.loan, 
                             revplanchange.post_date, -- needs review from business
                             (CASE 
                                      WHEN revplanchange.new_pmnt_plan = 'TM' THEN 1 
                                      WHEN revplanchange.new_pmnt_plan = 'TN' THEN 2 
                                      WHEN revplanchange.new_pmnt_plan = 'MM' THEN 3 
                                      WHEN revplanchange.new_pmnt_plan = 'MN' THEN 4 
                                      WHEN revplanchange.new_pmnt_plan = 'LC' THEN 5 
                                      else null
                             END) AS payment_plan, 
                             revplanchange.new_mon_pmnt, 
                             revplanchange.new_len_of_term, 
                             revplanchange.new_loc_reserve, 
                             revplanchange.tax_ins_amount, 
                             --revplanchange.tax_ins_percent, 
                             --revplanchange.withhold_from_date, 
                             --revplanchange.withhold_to_date, 
                             Row_number() over (PARTITION BY revplanchange.loan ORDER BY revplanchange.idx DESC) AS rn
                    FROM     revplanchange 
                    WHERE    revplanchange.history='L' 
                    AND      revplanchange.item='zzz' 
                    AND      revplanchange.status='1' 
                    AND  	 revplanchange.post_date between ? and ? 
           ) plnchg ) 
ON         scm7_cd.loan = plnchg.loan 
WHERE      scm7_cd.history='L' 
AND        scm7_cd.item='zzz' 
AND        scm7_cd.status='1' 
AND        plnchg.rn = '1' 
AND        scm7_cd.investor_code = ?