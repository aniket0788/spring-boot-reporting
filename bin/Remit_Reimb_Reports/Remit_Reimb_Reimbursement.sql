SELECT 
                RevLoanPrePayments.loan loan_no,
                SCM7_CD.investor_code,
                mas3_CD.case_no, 
                        ORIG_LOAN_ATTRIBUTE.Vendor_ID, 
                masv_cd.funding_date, 
                idx,  
                prepay_type transaction_type,  
                tran_date transaction_date,  
                post_date,  
                CASE 
                    WHEN RevLoanPrePayments.mod_date IS NOT NULL AND RevLoanPrePayments.status = 0 THEN 'Cancelled' 
                    ELSE ' ' 
                END tran_status, 
                CASE 
                    WHEN mod_date IS NULL THEN '' 
                    ELSE to_char(mod_date, 'YYYY-MM-DD') 
                END tran_status_changed_date, 
                0 - amount AS amount,  
                brw1_cd.first_name,  
                brw1_cd.last_name, 
                mas3_cd.acInvestorCode ac_investor_code, 
                mask_cd.ACALTERNATELOAN investor_loan_no,  
                'Pre-payment' payment_type,  
                'SER' record_type, 
                RevLoanPrePayments.user_id, 
                '' as pmnt_method, 
                '' as deposit_bank_name, 
                '' as deposit_bank_acnt_no, 
                '' as deposit_bank_rout_no, 
                '' as mailto_street, 
                '' as mailto_city, 
                '' as mailto_state, 
                '' as mailto_zip 

            FROM 
                RevLoanPrePayments,  
                brw1_cd,  
                mas3_cd, 
                mas1_cd, 
                mask_cd, 
                masv_cd, 
                        ORIG_LOAN_ATTRIBUTE,
                SCM7_CD

            WHERE   
                RevLoanPrePayments.history = 'L' and  RevLoanPrePayments.item = 'zzz'  
                and  (RevLoanPrePayments.status = 1 OR 
                        (RevLoanPrePayments.status = 0 AND RevLoanPrePayments.mod_date IS NOT NULL)) 

                and mas3_cd.history = 'L' and  mas3_cd.item = 'zzz'  and  mas3_cd.status = 1  
                and mas3_cd.loan = RevLoanPrePayments.loan      
                and mas3_cd.originate_type != 'S02'  
                and masv_cd.history = 'L' and  masv_cd.item = 'zzz'  and  masv_cd.status = 1  
                and mas3_cd.loan = masv_cd.loan      

                and mas1_cd.history = 'L' and  mas1_cd.item = 'zzz'  and  mas1_cd.status = 1  
                and mas1_cd.loan = RevLoanPrePayments.loan   
                and mas1_cd.acidx = '01'  

                and brw1_cd.history = 'L' and brw1_cd.item = 'zzz'  and brw1_cd.status = 1  
                and brw1_cd.loan = RevLoanPrePayments.loan  
                and brw1_cd.brwr_no = mas1_cd.brwr_id_1  

                and mask_cd.history = 'L' and  mask_cd.item = 'zzz'  and  mask_cd.status = 1  
                and mask_cd.loan = RevLoanPrePayments.loan      
                        and orig_loan_attribute.loan(+) = RevLoanPrePayments.loan   
                and ((RevLoanPrePayments.post_date >= ? and RevLoanPrePayments.post_date < ?)  
                    OR (RevLoanPrePayments.mod_date >= ? and RevLoanPrePayments.mod_date < ?))  
                and ORIG_LOAN_ATTRIBUTE.status(+) = 1 
                and ORIG_LOAN_ATTRIBUTE.history(+) = 'L' 
                and ORIG_LOAN_ATTRIBUTE.item(+) = 'zzz'
                and investor_code = ?
