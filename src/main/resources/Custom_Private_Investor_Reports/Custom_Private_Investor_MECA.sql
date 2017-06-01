/*********************************************************************************************************************** 
                CUSTOM PRIVATE INVESTORS (MECA20061 | MECA20062 | MECA20063) CUSTOM MONTHLY REPORT 
***********************************************************************************************************************/
SELECT 
LAST_DAY(ADD_MONTHS(?,-1))                              		  AS Process_Date,                    --AZ: ADDED FIELD
TO_CHAR(LAST_DAY(ADD_MONTHS(?,-1)),'MMDDYYYY')          		  AS Process_Int,                     --AZ: ADDED FIELD
RLSM.LOAN                                                         AS Loan_Nbr,                        --AZ: CHANGED NAME FROM loanno TO Loan_Nbr 
NULL                                                              AS Real_Claim_Type,                 --AZ: ADDED FIELD
NULL                                                              AS Initial_Claim_File_Date,         --AZ: UPDATED LOGIC
INIT_CLAIM_AMT.INIT_CLAIM_PMT_AMT                                 AS initial_claim_payment_amount,
INIT_CLAIM_DT.INIT_CLAIM_PMT_DT                                   AS initial_claim_payment_date,
NULL                                                              AS Sup_Claim_File_Date,             --AZ: ADDED FIELD
SUPP_CLAIM_AMT.SUPP_CLAIM_PMT_AMT                                 AS sup_claim_pmnt_amt,
SUPP_CLAIM_DT.SUPP_CLAIM_PMT_DT                                   AS sup_claim_pmnt_date,
RLSM.MON_PREPMNT                                                  AS Prepayments,
RLSM.MON_SCHD_PMNT                                                AS schedule_advances,
RLSM.MON_UNSCHD_PMNT                                              AS unschedule_advances,
RLSM.MON_MIP                                                      AS MIP_accrued,
RLSM.MON_SERV_FEE                                                 AS service_fee_accrued,
RLSM.LOAN_BALANCE                                                 AS Current_Balance,                 --AZ: CHANGED MAPPING AND NAME FROM UPB TO Current_Balance
NULL                                                              AS DAP_App_Order_Date,              --AZ: ADDED FIELD
NULL                                                              AS DAP_UPB,                         --AZ: ADDED FIELD
First_Legal_Dt.First_Legal_Dt                                     AS First_legal_completed_date,      --AZ: CHANGED MAPPING AND NAME FROM legal_completed_date TO First_legal_completed_date
FCL_DATE.FCL_DATE		                                          AS forclosure_sale_date,
Third_Party_Sale.Third_Party_Sale                                 AS Third_party_sale_date,           --AZ: CHANGED NAME FROM party_sale_date TO Third_party_sale_date
NULL                                                              AS PRE_FCL_SS_Liquid_Dt,            --AZ: ADDED FIELD
HUD_Assig_Dt.HUD_Assig_Dt 	                                      AS hud_assignment_date,
Deed_Record_Dt.Deed_Record_Dt                                     AS deed_recorded_date,
NULL                                                              AS ABC_Claim_Flag                   --AS: ADDED FIELD
FROM SCM7_CD     SCM7 
INNER JOIN (SELECT RLSM.LOAN,RECORD_DATE,MON_PREPMNT,MON_SCHD_PMNT,MON_UNSCHD_PMNT,MON_MIP,MON_SERV_FEE,LOAN_BALANCE
            FROM REVLOANSERVICINGMONTH   RLSM
            WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)
            AND RLSM.LOAN IN (SELECT SCM7.LOAN
                              FROM   SCM7_CD SCM7
                              WHERE  SCM7.INVESTOR_CODE = ?)
            AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
            ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        SUM(RLPPS.AMOUNT) AS INIT_CLAIM_PMT_AMT
                 FROM REVLOANPREPAYMENTS RLPPS
                 WHERE RLPPS.LOAN IN (SELECT SCM7.LOAN
                                      FROM   SCM7_CD SCM7
                                      WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLPPS.POST_DATE BETWEEN ? AND ?
                 AND RLPPS.HISTORY = 'L' AND RLPPS.ITEM = 'zzz' AND RLPPS.STATUS = '1'
                 AND RLPPS.PREPAY_TYPE IN ('80D','34A')
                 GROUP BY RLPPS.LOAN
                 ) INIT_CLAIM_AMT ON RLSM.LOAN = INIT_CLAIM_AMT.LOAN                 
LEFT OUTER JOIN (SELECT LOAN,
                        MIN(RLPPS.POST_DATE) AS INIT_CLAIM_PMT_DT
                 FROM REVLOANPREPAYMENTS RLPPS
                 WHERE RLPPS.LOAN IN (SELECT SCM7.LOAN
                                      FROM   SCM7_CD SCM7
                                      WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLPPS.POST_DATE BETWEEN ? AND ?
                 AND RLPPS.HISTORY = 'L' AND RLPPS.ITEM = 'zzz' AND RLPPS.STATUS = '1'
                 AND RLPPS.PREPAY_TYPE IN ('80D','34A')
                 GROUP BY RLPPS.LOAN
                 ) INIT_CLAIM_DT ON RLSM.LOAN = INIT_CLAIM_DT.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        SUM(RLPPS.AMOUNT) AS SUPP_CLAIM_PMT_AMT
                 FROM REVLOANPREPAYMENTS RLPPS
                 WHERE RLPPS.LOAN IN (SELECT SCM7.LOAN
                                      FROM   SCM7_CD SCM7
                                      WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLPPS.post_date BETWEEN ? AND ?
                 AND RLPPS.HISTORY = 'L' AND RLPPS.ITEM = 'zzz' AND RLPPS.STATUS = '1'
                 AND RLPPS.PREPAY_TYPE IN ('80E','34B')
                 GROUP BY RLPPS.loan
                 ) SUPP_CLAIM_AMT ON RLSM.LOAN = SUPP_CLAIM_AMT.LOAN                 
LEFT OUTER JOIN (SELECT LOAN,
                        MIN(RLPPS.POST_DATE) AS SUPP_CLAIM_PMT_DT
                 FROM REVLOANPREPAYMENTS RLPPS
                 WHERE RLPPS.LOAN IN (SELECT SCM7.LOAN
                                      FROM   SCM7_CD SCM7
                                      WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLPPS.post_date BETWEEN ? AND ?
                 AND RLPPS.HISTORY = 'L' AND RLPPS.ITEM = 'zzz' AND RLPPS.STATUS = '1'
                 AND RLPPS.PREPAY_TYPE IN ('80E','34B')
                 GROUP BY RLPPS.loan
                 ) SUPP_CLAIM_DT ON RLSM.LOAN = SUPP_CLAIM_DT.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS First_Legal_Dt
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'F87'
                 GROUP BY MAS5.loan
                 ) First_Legal_Dt ON RLSM.LOAN = First_Legal_Dt.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS FCL_DATE
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'F75'
                 GROUP BY MAS5.loan
                 ) FCL_DATE ON RLSM.LOAN = FCL_DATE.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS Third_Party_Sale
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'F62'
                 GROUP BY MAS5.loan
                 ) Third_Party_Sale ON RLSM.LOAN = Third_Party_Sale.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS HUD_Assig_Dt
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'F79'
                 GROUP BY MAS5.loan
                 ) HUD_Assig_Dt ON RLSM.LOAN = HUD_Assig_Dt.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS Deed_Record_Dt
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'F76'
                 GROUP BY MAS5.loan
                 ) Deed_Record_Dt ON RLSM.LOAN = Deed_Record_Dt.LOAN
WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1'
AND RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)
AND SCM7.INVESTOR_CODE = ?
ORDER BY Loan_Nbr