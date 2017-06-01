/*********************************************************************************************************************** 
                                        INVESTOR REPORTING DAILY TRANSACTIONS REPORT
***********************************************************************************************************************/
SELECT   
RLPS.LOAN                                                                         AS loan_no,  
MAS3.CASE_NO                                                                      AS case_no,  
OLA.VENDOR_ID                                                                     AS Vendor_ID,  
MASV.FUNDING_DATE                                                                 AS funding_date,  
RLPS.IDX                                                                          AS idx,   
CASE WHEN RLPS.PAY_TYPE = '40'   THEN '40 - Unscheduled Payment-Prevent Tax Lien'
     WHEN RLPS.PAY_TYPE = '41'   THEN '41 - Unscheduled Payment-Repairs set-aside not final'
     WHEN RLPS.PAY_TYPE = '42'   THEN '42 - Unscheduled Payment-First-year property charges set-aside not final'
     WHEN RLPS.PAY_TYPE = '43A'  THEN '43A - Unscheduled Payment-Taxes  set-aside'
     WHEN RLPS.PAY_TYPE = '43B'  THEN '43B - Unscheduled Payment-Insurance set-aside'
     WHEN RLPS.PAY_TYPE = '44'   THEN '44 - Unscheduled Payment-Net line of credit set-aside'
     WHEN RLPS.PAY_TYPE = '44A'  THEN '44A - Unscheduled Payment-Net line of credit  repair not final'
     WHEN RLPS.PAY_TYPE = '44B'  THEN '44B - Unscheduled Payment-Net line of credit repair final'
     WHEN RLPS.PAY_TYPE = '44C'  THEN '44C - Unscheduled Payment-Net line of credit Tax  set-aside'
     WHEN RLPS.PAY_TYPE = '44D'  THEN '44D - Unscheduled Payment-Net line of credit Insurance set-aside'
     WHEN RLPS.PAY_TYPE = '45'   THEN '45 - Unscheduled Payment-Repair set-aside final'
     WHEN RLPS.PAY_TYPE = '46'   THEN '46 - Unscheduled Payment-First-year property charges set-aside final'
     WHEN RLPS.PAY_TYPE = '47'   THEN '47 - Unscheduled Payment-Appraisal fee set-aside'
     WHEN RLPS.PAY_TYPE = '48'   THEN '48 - Unscheduled Payment-Tax payment from line of credit'
     WHEN RLPS.PAY_TYPE = '49'   THEN '49 - Unscheduled Payment-Payment Plan Change'
     WHEN RLPS.PAY_TYPE = '50'   THEN '50 - Unscheduled Payment-Life expect set-aside not final'
     WHEN RLPS.PAY_TYPE = '51'   THEN '51 - Unscheduled payment-Life expect set-aside final'
     WHEN RLPS.PAY_TYPE = '90'   THEN '90 - Unscheduled Payment-Taxes'
     WHEN RLPS.PAY_TYPE = '91'   THEN '91 - Unscheduled Payment-Insurance'
     WHEN RLPS.PAY_TYPE = '92'   THEN '92 - Unscheduled Payment-Inspection'
     WHEN RLPS.PAY_TYPE = '93'   THEN '93 - Unscheduled Payment-Appraisal'
     WHEN RLPS.PAY_TYPE = '94'   THEN '94 - Unscheduled Payment-Property Preservations'
     WHEN RLPS.PAY_TYPE = '95'   THEN '95 - Unscheduled Payment-Attorney Fees/Costs'
     WHEN RLPS.PAY_TYPE = '96'   THEN '96 - Unscheduled Payment-HOA Dues/Fees'
     WHEN RLPS.PAY_TYPE = 'P01'  THEN 'P01 - Monthly Interest Payment'
     WHEN RLPS.PAY_TYPE = 'P02'  THEN 'P02 - Monthly MIP Payment'
     WHEN RLPS.PAY_TYPE = 'P03'  THEN 'P03 - Monthly Servicing Fee Payment'
     WHEN RLPS.PAY_TYPE = 'P00'  THEN 'P00 - Monthly Scheduled Payment'
     ELSE ''
END                                                                                AS transaction_type,   
TO_CHAR(RLPS.TRAN_DATE, 'MM/DD/YYYY')                                              AS transaction_date,   
TO_CHAR(RLPS.POST_DATE, 'MM/DD/YYYY')                                              AS post_date,   
CASE WHEN RLPS.MOD_DATE IS NOT NULL AND RLPS.STATUS = '0' THEN 'Cancelled'  
     ELSE ' '  
END                                                                                AS tran_status,
RLPS.STATUS,
CASE WHEN RLPS.MOD_DATE IS NULL THEN ' '
     ELSE TO_CHAR(RLPS.MOD_DATE, 'MM/DD/YYYY')  
END                                                                               AS tran_status_changed_date,
/*CASE WHEN RLPS.STATUS = '0' THEN TO_CHAR(UPDATED_ON,'DD-MON-YY')
     ELSE ' ' 
END                                                                               AS tran_status_changed_date,*/          --No Req to Updated logic to account for Cancelled transactions
(CASE WHEN RLPS.STATUS = '0' THEN RLPS.AMOUNT*-1 ELSE RLPS.AMOUNT END)            AS amount,
NULL                                                                              AS Misc_Servicing_Fee,                --Added it as per Defect# 51054 
NULL                                                                              AS Legal_Fees,     
NULL                                                                              AS HUD_Disbursements,  
NULL                                                                              AS Property_Preservation_Fees, 
NULL                                                                              AS Loss_Draft_Funds,  
NULL                                                                              AS Title_Fee_and_Recording_Fees, 
NULL                                                                              AS County_Recording_Fees,  
NULL                                                                              AS writeoff_payoff_amount,
NULL                                                                              AS writeoff_payoff_cost_center,       --changed it from writeoff_costcenter_assignment to writeoff_payoff_cost_center
NULL                                                                              AS Writeoff_Adjs_cost_center,         --Added it as per PBI# 31842
BRW1.FIRST_NAME                                                                   AS first_name,   
BRW1.LAST_NAME                                                                    AS last_name,
MAS3.ACINVESTORCODE                                                               AS investor_code,
MASK.ACALTERNATELOAN                                                              AS investor_loan_no,  
'Payment'                                                                         AS payment_type,   
RLPS.RECORD_TYPE                                                                  AS RECORD_TYPE,   
RLPS.USER_ID                                                                      AS user_id,  
RLPS.PMNT_METHOD                                                                  AS pmnt_method,  
RLPS.DEPOSIT_BANK_NAME                                                            AS deposit_bank_name,  
RLPS.DEPOSIT_BANK_ACNT_NO                                                         AS deposit_bank_acnt_no,  
RLPS.DEPOSIT_BANK_ROUT_NO                                                         AS deposit_bank_rout_no,  
RLPS.MAILTO_STREET                                                                AS mailto_street,  
RLPS.MAILTO_CITY                                                                  AS mailto_city,  
RLPS.MAILTO_STATE                                                                 AS mailto_state,  
RLPS.MAILTO_ZIP                                                                   AS mailto_zip
FROM REVLOANPAYMENTS   RLPS
INNER JOIN (SELECT LOAN
            FROM SCM7_CD        SCM7
            WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1' AND SCM7.INVESTOR_CODE  = ?
            ) SCM7 ON RLPS.LOAN = SCM7.LOAN
INNER JOIN (SELECT LOAN, CASE_NO, ACINVESTORCODE
                  FROM   MAS3_CD        MAS3
                  WHERE  MAS3.HISTORY = 'L' AND MAS3.ITEM = 'zzz' AND MAS3.STATUS = '1' AND MAS3.ORIGINATE_TYPE != 'S02'
                 ) MAS3 ON RLPS.LOAN = MAS3.LOAN
INNER JOIN (SELECT BRW1.LOAN,BRW1.FIRST_NAME,BRW1.LAST_NAME
                  FROM   BRW1_CD        BRW1
                  INNER JOIN (SELECT LOAN,BRWR_ID_1
                              FROM   MAS1_CD  MAS1
                              WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                              ) MAS1 ON BRW1.LOAN = MAS1.LOAN AND BRW1.BRWR_NO = MAS1.BRWR_ID_1
                  WHERE BRW1.HISTORY = 'L' AND BRW1.ITEM = 'zzz'	AND BRW1.STATUS = '1'
                  ) BRW1 ON RLPS.LOAN = BRW1.LOAN
LEFT OUTER JOIN (SELECT LOAN
                 FROM   MAS1_CD        MAS1
                 WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1' AND MAS1.ACIDX = '01'
                 ) MAS1 ON RLPS.LOAN = MAS1.LOAN
LEFT OUTER JOIN (SELECT LOAN,FUNDING_DATE
                 FROM   MASV_CD
                 WHERE  MASV_CD.HISTORY  = 'L' AND MASV_CD.ITEM = 'zzz' AND MASV_CD.STATUS = '1'
                 ) MASV ON RLPS.LOAN = MASV.LOAN
LEFT OUTER JOIN (SELECT LOAN,ACALTERNATELOAN
                 FROM   MASK_CD  MASK
                 WHERE  MASK.HISTORY  = 'L' AND MASK.ITEM = 'zzz' AND MASK.STATUS = '1'
                 ) MASK ON RLPS.LOAN = MASK.LOAN
LEFT OUTER JOIN (SELECT LOAN,VENDOR_ID
                 FROM   ORIG_LOAN_ATTRIBUTE   OLA
                 WHERE  OLA.HISTORY  = 'L' AND OLA.ITEM = 'zzz' AND OLA.STATUS = '1'
                 ) OLA ON RLPS.LOAN = OLA.LOAN
WHERE RLPS.HISTORY = 'L' AND  RLPS.ITEM = 'zzz' AND (RLPS.STATUS IN ('1','0','5') OR (RLPS.STATUS = '0' AND RLPS.MOD_DATE IS NOT NULL))  
AND RLPS.POST_DATE >= ? AND RLPS.POST_DATE <= ? --OR (RLPS.MOD_DATE >= '01-NOV-16' AND RLPS.MOD_DATE <= '30-NOV-16'))

UNION ALL

SELECT  
RLPPS.LOAN                                                                        AS loan_no,   
MAS3.CASE_NO                                                                      AS case_no,  
OLA.VENDOR_ID                                                                     AS Vendor_ID,  
MASV.FUNDING_DATE                                                                 AS funding_date,  
RLPPS.IDX                                                                         AS idx,   
CASE WHEN RLPPS.PREPAY_TYPE = '31'   THEN '31 - Payoff Death'
     WHEN RLPPS.PREPAY_TYPE = '32'   THEN '32 - Payoff Borrower Moved'
     WHEN RLPPS.PREPAY_TYPE = '33'   THEN '33 - Payoff Borrower Paid Off'
     WHEN RLPPS.PREPAY_TYPE = '34'   THEN '34 - Payoff Other Reason'
     WHEN RLPPS.PREPAY_TYPE = '35'   THEN '35 - Payoff Unknown Reason'
     WHEN RLPPS.PREPAY_TYPE = '34A'  THEN '34A - HUD Claim Payoff'
     WHEN RLPPS.PREPAY_TYPE = '34B'  THEN '34B - Supplemental Claim Payoff'
     WHEN RLPPS.PREPAY_TYPE = '34C'  THEN '34C - Foreclosure Sale Payoff'
     WHEN RLPPS.PREPAY_TYPE = '65'   THEN '65 - Repurchase Payoff'
     WHEN RLPPS.PREPAY_TYPE = '80'   THEN '80 - Part Pre-Payment-Reduce UPB only'
     WHEN RLPPS.PREPAY_TYPE = '81'   THEN '81 - Part Pre-Payment-Increase Net LOC'
     WHEN RLPPS.PREPAY_TYPE = '82'   THEN '82 - Part Pre-Payment-Increase Repair Set-Aside'
     WHEN RLPPS.PREPAY_TYPE = '83'   THEN '83 - Part Pre-Payment-Increase Taxes and Insurance'
     WHEN RLPPS.PREPAY_TYPE = '84'   THEN '84 - Part Pre-Payment-Increase 1st Year Property Charges'
     WHEN RLPPS.PREPAY_TYPE = '80A'  THEN '80A - Part Pre-Payment-Short Sale Proceeds'
     WHEN RLPPS.PREPAY_TYPE = '80B'  THEN '80B - Part Pre-Payment-Foreclosure Sale'
     WHEN RLPPS.PREPAY_TYPE = '80C'  THEN '80C - Part Pre-Payment-REO'
     WHEN RLPPS.PREPAY_TYPE = '80D'  THEN '80D - Part Pre-Payment-HUD Claim'
     WHEN RLPPS.PREPAY_TYPE = '80E'  THEN '80E - Part Pre-Payment-Supplemental Claim'
     WHEN RLPPS.PREPAY_TYPE = '85'   THEN '85 - Part Pre-Payment-Property Sale Code'
     WHEN RLPPS.PREPAY_TYPE = '86'   THEN '86 - Part Pre-Payment-HUD Claim Received Code'
     WHEN RLPPS.PREPAY_TYPE = '105'  THEN '105 - Adjustment-Non-Cash Charge Off'
     WHEN RLPPS.PREPAY_TYPE = '105A' THEN '105A - Adjustment-Charge Balance/ARM Correction'
     WHEN RLPPS.PREPAY_TYPE = '105B' THEN '105B - Adjustment-Decrease UPB 22 Claims'
     WHEN RLPPS.PREPAY_TYPE = '105C' THEN '105C - Adjustment-Decrease UPB 21/23 Claims'
     WHEN RLPPS.PREPAY_TYPE = '105D' THEN '105D - Adjustment-Non-Cash Investor Write-Off'
     WHEN RLPPS.PREPAY_TYPE = '108'  THEN '108 - Apply to/withdraw from Borrower Suspense'
     WHEN RLPPS.PREPAY_TYPE = '109'  THEN '109 - Apply to/withdraw from Claims Suspense'
     ELSE ''
END                                                                               AS transaction_type,   
TO_CHAR(RLPPS.TRAN_DATE,'MM/DD/YYYY')                                             AS transaction_date,   
TO_CHAR(RLPPS.POST_DATE,'MM/DD/YYYY')                                             AS post_date,   
CASE WHEN RLPPS.MOD_DATE IS NOT NULL AND RLPPS.STATUS = '0' THEN 'Cancelled'  
     ELSE ' '  
END                                                                               AS tran_status,
RLPPS.STATUS,
--CASE WHEN RLPPS.STATUS = 0 THEN 'Cancelled' ELSE ' ' END                          AS tran_status,                       --No Req to Updated logic to account for Cancelled transactions
CASE WHEN RLPPS.MOD_DATE IS NULL THEN ' '
     ELSE TO_CHAR(RLPPS.MOD_DATE, 'MM/DD/YYYY')  
END                                                                               AS tran_status_changed_date,
/*CASE WHEN RLPPS.STATUS = '0' THEN TO_CHAR(UPDATED_ON,'DD-MON-YY')
     ELSE ' ' 
END                                                                               AS tran_status_changed_date,*/          --No Req to Updated logic to account for Cancelled transactions
(CASE WHEN RLPPS.STATUS = '0' THEN RLPPS.AMOUNT*-1 ELSE RLPPS.AMOUNT END)         AS amount,
RLPPS.MISC_SERV_FEE                                                               AS Misc_Servicing_Fee,                --This needs to be added as per Defect# 51054 
RLPPS.LEGAL_FEES                                                                  AS Legal_Fees,
RLPPS.HUD_DISBURSEMENTS                                                           AS HUD_Disbursements,
RLPPS.PROP_PRES_FEES                                                              AS Property_Preservation_Fees, 
RLPPS.LOSS_DRAFT_FUNDS                                                            AS Loss_Draft_Funds,  
RLPPS.TITLE_FEE_AND_RECD_FEES                                                     AS Title_Fee_and_Recording_Fees, 
RLPPS.COUNTY_RECD_FEES                                                            AS County_Recording_Fees,  
RLPPS.WRITEOFF_PAYOFF_AMOUNT                                                      AS writeoff_payoff_amount,
RLPPS.WRITEOFF_COSTCENTER_ASSIGNMENT                                              AS writeoff_payoff_cost_center,       --changed it from writeoff_costcenter_assignment to writeoff_payoff_cost_center
RLPPS.COSTCENTER                                                                  AS Writeoff_Adjs_cost_center,         --Added it as per PBI# 31842
BRW1.FIRST_NAME                                                                   AS first_name,   
BRW1.LAST_NAME                                                                    AS last_name,  
MAS3.ACINVESTORCODE                                                               AS investor_code,  
MASK.ACALTERNATELOAN                                                              AS investor_loan_no,   
'Pre-payment'                                                                     AS payment_type,   
NULL                                                                              AS record_type,  
RLPPS.USER_ID                                                                     AS user_id,  
NULL                                                                              AS pmnt_method,  
NULL                                                                              AS deposit_bank_name,  
NULL                                                                              AS deposit_bank_acnt_no,  
NULL                                                                              AS deposit_bank_rout_no,  
NULL                                                                              AS mailto_street,  
NULL                                                                              AS mailto_city,  
NULL                                                                              AS mailto_state,  
NULL                                                                              AS mailto_zip  
FROM REVLOANPREPAYMENTS         RLPPS
INNER JOIN (SELECT LOAN
            FROM SCM7_CD        SCM7
            WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1' AND SCM7.INVESTOR_CODE  = ?
            ) SCM7 ON RLPPS.LOAN = SCM7.LOAN
INNER JOIN (SELECT LOAN, CASE_NO, ACINVESTORCODE
            FROM MAS3_CD        MAS3
            WHERE MAS3.HISTORY = 'L' AND MAS3.ITEM = 'zzz' AND MAS3.STATUS = '1' AND MAS3.ORIGINATE_TYPE != 'S02'
            ) MAS3 ON RLPPS.LOAN = MAS3.LOAN
INNER JOIN (SELECT BRW1.LOAN,BRW1.FIRST_NAME,BRW1.LAST_NAME
            FROM BRW1_CD        BRW1
            INNER JOIN (SELECT LOAN,BRWR_ID_1
                        FROM MAS1_CD  MAS1
                        WHERE MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                        ) MAS1 ON BRW1.LOAN = MAS1.LOAN AND BRW1.BRWR_NO = MAS1.BRWR_ID_1
            WHERE BRW1.HISTORY = 'L' AND BRW1.ITEM = 'zzz'	AND BRW1.STATUS = '1'
            ) BRW1 ON RLPPS.LOAN = BRW1.LOAN
LEFT OUTER JOIN (SELECT LOAN
            FROM MAS1_CD        MAS1
            WHERE MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1' AND MAS1.ACIDX = '01'
            ) MAS1 ON RLPPS.LOAN = MAS1.LOAN
LEFT OUTER JOIN (SELECT LOAN,FUNDING_DATE
            FROM MASV_CD
            WHERE MASV_CD.HISTORY  = 'L' AND MASV_CD.ITEM = 'zzz' AND MASV_CD.STATUS = '1'
            ) MASV ON RLPPS.LOAN = MASV.LOAN
LEFT OUTER JOIN (SELECT LOAN,ACALTERNATELOAN
            FROM MASK_CD        MASK
            WHERE MASK.HISTORY  = 'L' AND MASK.ITEM = 'zzz' AND MASK.STATUS = '1'
            ) MASK ON RLPPS.LOAN = MASK.LOAN
LEFT OUTER JOIN (SELECT LOAN,VENDOR_ID
                 FROM ORIG_LOAN_ATTRIBUTE   OLA
                 WHERE OLA.HISTORY  = 'L' AND OLA.ITEM = 'zzz' AND OLA.STATUS = '1'
                 ) OLA ON RLPPS.LOAN = OLA.LOAN
WHERE RLPPS.HISTORY = 'L' AND  RLPPS.ITEM = 'zzz' AND (RLPPS.STATUS IN ('1','0','5') OR (RLPPS.STATUS = '0' AND RLPPS.MOD_DATE IS NOT NULL))
AND RLPPS.POST_DATE >= ? AND RLPPS.POST_DATE <= ? --OR (RLPS.MOD_DATE >= '01-NOV-16' AND RLPS.MOD_DATE <= '30-NOV-16'))

UNION ALL

SELECT   
RLCA.LOAN                                                                         AS loan_no,  
MAS3.CASE_NO                                                                      AS case_no,  
OLA.VENDOR_ID                                                                     AS Vendor_ID,  
MASV.FUNDING_DATE                                                                 AS funding_date,  
RLCA.IDX                                                                          AS idx,
CASE WHEN RLCA.CORP_ADV_TYPE = 'PRPTAX' THEN 'PRPTAX - Property Tax'
     WHEN RLCA.CORP_ADV_TYPE = 'FORCLS' THEN 'FORCLS - Foreclosure Expenses'
     WHEN RLCA.CORP_ADV_TYPE = 'PROPIN' THEN 'PROPIN - Property Investigation '
     WHEN RLCA.CORP_ADV_TYPE = 'MISCEL' THEN 'MISCEL - Miscellaneous'
     WHEN RLCA.CORP_ADV_TYPE = 'ATTFEE' THEN 'ATTFEE - Attorney Fees'
     WHEN RLCA.CORP_ADV_TYPE = 'LGLFEE' THEN 'LGLFEE - Legal Fees'
    -- WHEN RLCA.CORP_ADV_TYPE = 'NEGLOC' THEN 'NEGLOC - Negative LOC Payment'                                   --EXCLUDED AS PER DEV INITIATIVE
     WHEN RLCA.CORP_ADV_TYPE = 'FRCPLC' THEN 'FRCPLC - Force Place Insurance'
     WHEN RLCA.CORP_ADV_TYPE = 'HAZINS' THEN 'HAZINS - Hazard Insurance'
     WHEN RLCA.CORP_ADV_TYPE = 'APPDIL' THEN 'APPDIL - Appraisal DIL'
     WHEN RLCA.CORP_ADV_TYPE = 'APPFCL' THEN 'APPFCL - Appraisal FCL'
     WHEN RLCA.CORP_ADV_TYPE = 'APPSHS' THEN 'APPSHS - Appraisal Short Sale'
     WHEN RLCA.CORP_ADV_TYPE = 'ATTCST' THEN 'ATTCST - Attorney Costs'
     ELSE '' END                                                                  AS transaction_type, 
TO_CHAR(RLCA.CORP_ADV_DATE, 'MM/DD/YYYY')                                         AS transaction_date,   
TO_CHAR(RLCA.CORP_ADV_DATE, 'MM/DD/YYYY')                                         AS post_date,   
/*CASE WHEN RLPS.MOD_DATE IS NOT NULL AND RLPS.STATUS = 0 THEN 'Cancelled'  
     ELSE ' '  
END                                                                               AS tran_status,*/
CASE WHEN RLCA.STATUS = '0' THEN 'Cancelled' ELSE ' ' END                         AS tran_status,                       --Updated logic to account for Cancelled transactions
RLCA.STATUS,
/*CASE WHEN RLPS.MOD_DATE IS NULL THEN ' '
     ELSE TO_CHAR(RLPS.MOD_DATE, 'YYYY-MM-DD')  
END                                                                               AS tran_status_changed_date,*/
CASE WHEN RLCA.STATUS = '0' THEN TO_CHAR(RLCA.UPDATED_ON,'DD-MON-YY')
     ELSE ' ' 
END                                                                               AS tran_status_changed_date,          --Updated logic to account for Cancelled transactions
(CASE WHEN RLCA.STATUS = '0' THEN RLCA.AMOUNT*-1 ELSE RLCA.AMOUNT END)            AS amount,
NULL                                                                              AS Misc_Servicing_Fee,                --Added it as per Defect# 51054 
NULL                                                                              AS Legal_Fees,     
NULL                                                                              AS HUD_Disbursements,  
NULL                                                                              AS Property_Preservation_Fees, 
NULL                                                                              AS Loss_Draft_Funds,  
NULL                                                                              AS Title_Fee_and_Recording_Fees, 
NULL                                                                              AS County_Recording_Fees,  
NULL                                                                              AS writeoff_payoff_amount,
NULL                                                                              AS writeoff_payoff_cost_center,       --changed it from writeoff_costcenter_assignment to writeoff_payoff_cost_center
NULL                                                                              AS Writeoff_Adjs_cost_center,         --Added it as per PBI# 31842
BRW1.FIRST_NAME                                                                   AS first_name,   
BRW1.LAST_NAME                                                                    AS last_name,  
MAS3.ACINVESTORCODE                                                               AS investor_code,  
MASK.ACALTERNATELOAN                                                              AS investor_loan_no,   
'Corporate Advance'                                                               AS payment_type,   
NULL                                                                              AS RECORD_TYPE,   
RLCA.USER_ID                                                                      AS user_id,  
NULL                                                                              AS pmnt_method,  
NULL                                                                              AS deposit_bank_name,  
NULL                                                                              AS deposit_bank_acnt_no,  
NULL                                                                              AS deposit_bank_rout_no,  
NULL                                                                              AS mailto_street,  
NULL                                                                              AS mailto_city,  
NULL                                                                              AS mailto_state,  
NULL                                                                              AS mailto_zip  
FROM REVLOANCORPADV   RLCA
INNER JOIN (SELECT LOAN
            FROM   SCM7_CD        SCM7
            WHERE  SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1' AND SCM7.INVESTOR_CODE  = ?
            ) SCM7 ON RLCA.LOAN = SCM7.LOAN
INNER JOIN (SELECT LOAN, CASE_NO, ACINVESTORCODE
            FROM   MAS3_CD        MAS3
            WHERE  MAS3.HISTORY = 'L' AND MAS3.ITEM = 'zzz' AND MAS3.STATUS = '1' AND MAS3.ORIGINATE_TYPE != 'S02'
            ) MAS3 ON RLCA.LOAN = MAS3.LOAN
INNER JOIN (SELECT BRW1.LOAN,BRW1.FIRST_NAME,BRW1.LAST_NAME
            FROM   BRW1_CD        BRW1
            INNER JOIN (SELECT LOAN,BRWR_ID_1
                        FROM   MAS1_CD  MAS1
                        WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                        ) MAS1 ON BRW1.LOAN = MAS1.LOAN AND BRW1.BRWR_NO = MAS1.BRWR_ID_1
            WHERE BRW1.HISTORY = 'L' AND BRW1.ITEM = 'zzz'	AND BRW1.STATUS = '1'
            ) BRW1 ON RLCA.LOAN = BRW1.LOAN
LEFT OUTER JOIN (SELECT LOAN
            FROM   MAS1_CD        MAS1
            WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1' AND MAS1.ACIDX = '01'
            ) MAS1 ON RLCA.LOAN = MAS1.LOAN
LEFT OUTER JOIN (SELECT LOAN,FUNDING_DATE
            FROM   MASV_CD
            WHERE  MASV_CD.HISTORY  = 'L' AND MASV_CD.ITEM = 'zzz' AND MASV_CD.STATUS = '1'
            ) MASV ON RLCA.LOAN = MASV.LOAN
LEFT OUTER JOIN (SELECT LOAN,ACALTERNATELOAN
            FROM   MASK_CD  MASK
            WHERE  MASK.HISTORY  = 'L' AND MASK.ITEM = 'zzz' AND MASK.STATUS = '1'
            ) MASK ON RLCA.LOAN = MASK.LOAN
LEFT OUTER JOIN (SELECT LOAN,VENDOR_ID
                 FROM   ORIG_LOAN_ATTRIBUTE   OLA
                 WHERE  OLA.HISTORY  = 'L' AND OLA.ITEM = 'zzz' AND OLA.STATUS = '1'
                 ) OLA ON RLCA.LOAN = OLA.LOAN
WHERE RLCA.HISTORY = 'L' AND  RLCA.ITEM = 'zzz' AND RLCA.STATUS IN ('1','0')
AND RLCA.CORP_ADV_TYPE NOT IN ('NEGLOC')
AND RLCA.CORP_ADV_DATE >= ? AND RLCA.CORP_ADV_DATE <= ?