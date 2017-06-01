SELECT          to_char(to_date(?),'YYYYMM') AS report_period, 
                scm7_cd.their_loan_no        AS fannie_mae_loan_no, 
                rlsm.loan_balance            AS loan_balance_current_amount, 
                rlsm.mon_schd_pmnt           AS loan_scheduled_payment_amount, 
                rlsm.serv_fee_sa             AS loan_serv_fee_aside_curr_amt, 
                rlsm.repair_sa               AS repairs_set_aside_curr_amt, 
                rlsm.prop_chrg_sa            AS fy_prop_set_aside_curr_amt, 
                rlsm.tax_ins_withhold_amount AS cur_tax_insu_withheld_bal_amt, 
                rlsm.tax_ins_sa              AS tax_insu_set_aside_curr_amt, 
                rlsm.prin_limit              AS principal_limit_curr_amt, 
                rlsm.net_prin_limit          AS net_principal_limit_cur_amt, 
                rlsm.loc_reserve             AS loc_reserve_curr_amt, 
                rlsm.net_loc                 AS net_loc_reserve_cur_amt, 
                rlsm.mon_mip                 AS mip_amount, 
                rlsm.mon_interest            AS interest_amount, 
                NULL				         AS loan_curr_index_rate, -- this is not available right now. This has to be captured by monthend. 
                rlsm.int_rate                AS current_interest_rate, 
                NULL		                 AS next_interest_rate,   -- this will change after monthend pbi for next interest rate
                NULL                         AS ln_note_rate_nxt_schd_chng_dt, -- this will change after monthend pbi for next interest rate 
                rlsm.len_of_term             AS remaining_term_sched_payments 
FROM            scm7_cd 
INNER JOIN      ( 
                ( 
                       SELECT loan, 
                              loan_balance, 
                              mon_schd_pmnt, 
                              serv_fee_sa, 
                              repair_sa, 
                              prop_chrg_sa, 
                              tax_ins_withhold_amount, 
                              tax_ins_sa, 
                              prin_limit, 
                              net_prin_limit, 
                              loc_reserve, 
                              net_loc, 
                              mon_mip, 
                              mon_interest, 
                              int_rate, 
                              len_of_term 
                       FROM   revloanservicingmonth RLSM 
                       WHERE  rlsm.history='L' 
                       AND    rlsm.item='zzz' 
                       AND    rlsm.status='1' 
                       AND    rlsm.record_date = 
                              ( 
                                     SELECT To_date(Last_day(?),'DD-MON-YY')+1 AS nextmonthfirstday 
                                     FROM   dual) ) rlsm ) 
ON              scm7_cd.loan = rlsm.loan 

WHERE           scm7_cd.history = 'L' 
AND             scm7_cd.item = 'zzz' 
AND             scm7_cd.status = '1' 
AND             scm7_cd.investor_code = ?