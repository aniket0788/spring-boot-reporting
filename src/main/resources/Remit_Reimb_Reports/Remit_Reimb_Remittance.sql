SELECT  
                RevLoanPayments.loan loan_no, 
                SCM7_CD.investor_code,
                mas3_CD.case_no, 
                        ORIG_LOAN_ATTRIBUTE.Vendor_ID, 
                masv_cd.funding_date, 
                idx,  
                pay_type transaction_type,  
                tran_date transaction_date,  
                post_date,  
                CASE 
                    WHEN RevLoanPayments.mod_date IS NOT NULL AND RevLoanPayments.status = 0 THEN 'Cancelled' 
                    ELSE ' ' 
                END tran_status, 
                CASE 
                    WHEN mod_date IS NULL THEN '' 
                    ELSE to_char(mod_date, 'YYYY-MM-DD') 
                END tran_status_changed_date, 
                amount,  
                brw1_cd.first_name,  
                brw1_cd.last_name, 
                mas3_cd.acInvestorCode ac_investor_code, 
                mask_cd.ACALTERNATELOAN investor_loan_no,  
                'Payment' payment_type,  
                RevLoanPayments.RECORD_TYPE,  
                RevLoanPayments.user_id, 
                pmnt_method, 
                deposit_bank_name, 
                deposit_bank_acnt_no, 
                deposit_bank_rout_no, 
                RevLoanPayments.mailto_street, 
                RevLoanPayments.mailto_city, 
                RevLoanPayments.mailto_state, 
                RevLoanPayments.mailto_zip 

            FROM 
                RevLoanPayments,  
                mas3_cd, 
                mas1_cd, 
                brw1_cd, 
                mask_cd, 
                masv_cd, 
                ORIG_LOAN_ATTRIBUTE,
                SCM7_CD

            WHERE 
                RevLoanPayments.history = 'L' and  RevLoanPayments.item = 'zzz'  
                and  (RevLoanPayments.status = 1 OR 
                        (RevLoanPayments.status = 0 AND RevLoanPayments.mod_date IS NOT NULL)) 

                and mas3_cd.history = 'L' and  mas3_cd.item = 'zzz'  and  mas3_cd.status = 1  
                and mas3_cd.loan = RevLoanPayments.loan      
                and mas3_cd.originate_type != 'S02'  

                and masv_cd.history = 'L' and  masv_cd.item = 'zzz'  and  masv_cd.status = 1  
                and mas3_cd.loan = masv_cd.loan      

                and mas1_cd.history = 'L' and  mas1_cd.item = 'zzz'  and  mas1_cd.status = 1  
                and mas1_cd.loan = RevLoanPayments.loan   
                and mas1_cd.acidx = '01'  

                and brw1_cd.history = 'L' and brw1_cd.item = 'zzz'  and brw1_cd.status = 1  
                and brw1_cd.loan = RevLoanPayments.loan 
                and brw1_cd.brwr_no = mas1_cd.brwr_id_1  

                and mask_cd.history = 'L' and  mask_cd.item = 'zzz'  and  mask_cd.status = 1  
                and mask_cd.loan = RevLoanPayments.loan      

                and RevLoanPayments.pay_type NOT IN ('P01', 'P02', 'P03')
                    
                        and ORIG_LOAN_ATTRIBUTE.LOAN(+) = RevLoanPayments.loan  
                and ((RevLoanPayments.post_date >= ? and RevLoanPayments.post_date < ?)  
                    OR (RevLoanPayments.mod_date >= ? and RevLoanPayments.mod_date < ?))  
                and ORIG_LOAN_ATTRIBUTE.status(+) = 1 
                and ORIG_LOAN_ATTRIBUTE.history(+) = 'L' 
                and ORIG_LOAN_ATTRIBUTE.item(+) = 'zzz' 
                and investor_code = ?