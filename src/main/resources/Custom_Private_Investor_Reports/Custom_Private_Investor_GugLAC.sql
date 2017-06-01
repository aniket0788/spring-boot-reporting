/*********************************************************************************************************************** 
                        CUSTOM PRIVATE INVESTORS (GUGLAC000 & IVCOTRUST) CUSTOM MONTHLY REPORT 
***********************************************************************************************************************/
SELECT 
RLSM.LOAN                                                                                   AS Champion_Loan_Number,          --AZ: CHANGED THE NAME FROM nationstar_loanno TO Champion_Loan_Number
SCM7.THEIR_LOAN_NO                                                                          AS Investor_Loan_Number,          --AZ: CHANGED THE NAME FROM pool_name_investor_code TO Investor_Loan_Number
NULL 												                                        AS Purchase_Date,                 --AZ: CHANGED THE NAME FROM purchasedate TO Purchase_Date, UPDATED LOGIC SINCE HISTORICAL BALANCES WERE NOT LOADED IN CHIP
( CASE WHEN RLSM.LOAN_STATUS = '0'   THEN 'Servicing'
       WHEN RLSM.LOAN_STATUS = '01'  THEN 'Payment Suspended'
       WHEN RLSM.LOAN_STATUS = '02'  THEN 'Payment Resumed'
       WHEN RLSM.LOAN_STATUS = '14A' THEN 'Foreclosed: Disrepair'
       WHEN RLSM.LOAN_STATUS = '11'  THEN 'Foreclosed: Death'
       WHEN RLSM.LOAN_STATUS = '12'  THEN 'Foreclosed: Non Occupancy'
       WHEN RLSM.LOAN_STATUS = '13A' THEN 'Foreclosed: Tax'
       WHEN RLSM.LOAN_STATUS = '13B' THEN 'Foreclosed: Insurance'
       WHEN RLSM.LOAN_STATUS = '13C' THEN 'Foreclosed: Tax and Insurance'
       WHEN RLSM.LOAN_STATUS = '14'  THEN 'Foreclosed: Other'
       WHEN RLSM.LOAN_STATUS = '15A' THEN 'Bankrupt: Suspend Pmnt'
       WHEN RLSM.LOAN_STATUS = '15B' THEN 'Bankrupt: No Suspend'
       WHEN RLSM.LOAN_STATUS = '20'  THEN 'Deed in lieu'
       WHEN RLSM.LOAN_STATUS = '50'  THEN 'Default: Non Occupancy'
       WHEN RLSM.LOAN_STATUS = '51C' THEN 'Default: Tax and Insurance'
       WHEN RLSM.LOAN_STATUS = '51F' THEN 'Default: Tax and Insurance - TBD'
       WHEN RLSM.LOAN_STATUS = '52A' THEN 'Default: Other'
       WHEN RLSM.LOAN_STATUS = '53A' THEN 'Default: Tax Valid Payment Plan'
       WHEN RLSM.LOAN_STATUS = '53B' THEN 'Default: Ins Valid Payment Plan'
       WHEN RLSM.LOAN_STATUS = '53C' THEN 'Default: Tax and Insurance Valid Payment Plan'
       WHEN RLSM.LOAN_STATUS = '52B' THEN 'Default: Disrepair'
       WHEN RLSM.LOAN_STATUS = '51A' THEN 'Default: Tax'
       WHEN RLSM.LOAN_STATUS = '51D' THEN 'Default: Tax - TBD'
       WHEN RLSM.LOAN_STATUS = '51B' THEN 'Default: Insurance'
       WHEN RLSM.LOAN_STATUS = '51E' THEN 'Default: Insurance - TBD'
       WHEN RLSM.LOAN_STATUS = '55'  THEN 'Due: Death'
       WHEN RLSM.LOAN_STATUS = '56'  THEN 'Due: Non Occupancy'
       WHEN RLSM.LOAN_STATUS = '57A' THEN 'Due: Tax'
       WHEN RLSM.LOAN_STATUS = '57B' THEN 'Due: Insurance'
       WHEN RLSM.LOAN_STATUS = '57C' THEN 'Due: Tax and Insurance'
       WHEN RLSM.LOAN_STATUS = '58A' THEN 'Due: Sell Property'
       WHEN RLSM.LOAN_STATUS = '58B' THEN 'Due: Convey Title'
       WHEN RLSM.LOAN_STATUS = '58D' THEN 'Due: Other'
       WHEN RLSM.LOAN_STATUS = '70'  THEN 'Liquid: Held Sale'
       WHEN RLSM.LOAN_STATUS = '74'  THEN 'Liquid: Held Sale TBD'
       WHEN RLSM.LOAN_STATUS = '71'  THEN 'Liquid: 3rd Party Sale'
       WHEN RLSM.LOAN_STATUS = '72'  THEN 'Liquid: Assigned to HUD'
       WHEN RLSM.LOAN_STATUS = '71A' THEN 'Short Sale: Claim Pending'
       WHEN RLSM.LOAN_STATUS = '71B' THEN 'Short Sale: Claim Completed'
       WHEN RLSM.LOAN_STATUS = '73'  THEN 'Liquid: Claim Filed'
       WHEN RLSM.LOAN_STATUS = '60'  THEN 'Payoff'
       ELSE RLSM.LOAN_STATUS
END)                                                                                        AS loan_status,
TO_CHAR(CLOSING_DATE.CLOSING_DATE,'MM/DD/YYYY')                                             AS closing_date,
TO_CHAR(MASV.FUNDING_DATE,'MM/DD/YYYY')                                                     AS funding_date,
NULL				                                                                        AS Initial_Loan_Amount,           --AZ: CHANGED NAME FROM initial_loan_bal TO Initial_Loan_Amount
NULL                                                                                        AS Closing_Cost,
--'0.00'                                                                                      AS loan_advance, --HARDCODED in JSON
PREVMONTHBALANCE.PREV_MONTH_BALANCE                                                         AS Beg_Period_Loan_Bal,           --AZ: CHANGED NAME FROM previous_month_loan_balance TO Beg_Period_Loan_Bal
RLSM.MON_INTEREST                                                                           AS Current_Period_Interest,       --AZ: CHANGED NAME FROM interest_last_month TO Current_Period_Interest
NULL					                                                                    AS Accrued_Interest,              --AZ: CHANGED NAME FROM interest_since_loan_begining TO Accrued_Interest
RLSM.MON_UNSCHD_PMNT                                                                        AS Current_Period_Advances,       --AZ: ADDED FIELD
TO_CHAR(LDD.LAST_DRAW_DT,'MM/DD/YYYY')                                                      AS Unscheduled_Advance_Date,
RLSM.MON_SERV_FEE                                                                           AS Current_Period_Service_Fee,    --AZ: ADDED FIELD
--'0.00'                                                                                      AS Carry_Over_Service_Fee,   --HARDCODED in JSON      --AZ: ADDED FIELD
RLSM.SERV_FEE_BAL                                                                           AS Service_fee_to_date,           --AZ: CHANGED NAME FROM Service_fee_till_date TO Service_fee_to_date
RLSM.MON_PREPMNT*-1                                                                         AS Current_Period_Repayments,     --AZ: ADDED FIELD
TO_CHAR(LPPD.LAST_PRE_PMT_DT,'MM/DD/YYYY')                                                  AS Repayment_Date,                --AZ: ADDED FIELD
RLSM.PAYOFF_BAL		                                                                        AS current_period_payoffs,
RLSM.PAYOFF_REFUND                                                                          AS Refund_To_Borrower,            --AZ: CHANGED NAME FROM payoff_refund TO Refund_To_Borrower
TO_CHAR(RLSM.PAYOFF_DATE,'MM/DD/YYYY')                                                      AS Payoff_Date,                   --AZ: CHANGED NAME FROM date_payoff TO Payoff_Date
RLSM.LOAN_BALANCE                                                                           AS End_Bal_Current_Period,        --AZ: CHANGED NAME FROM current_period_loan_balance TO End_Bal_Current_Period
RLSM.INT_RATE                                                                               AS Current_Rate,                  --AZ: CHANGED NAME FROM current_interest_rate TO Current_Rate
PRP1.MKT_VALUE                                                                              AS Min_Appraised_Value,           --AZ: CHANGED NAME FROM appraisal_value TO Min_Appraised_Value
PRP1.MKT_VAL_DATE                                                                           AS Effective_Appraisal_Date,
MAS3.LCLTV                                                                                  AS Initial_LTV,                   --AZ: CHANGED NAME FROM LTV TO Initial_LTV
NULL                                                                                        AS Current_LTV,
PRP1.PROP_TYPE                                                                              AS property_type,
(CASE WHEN BRW1_1.OCCUPY = '1' THEN 'Occupied'
      WHEN BRW1_2.OCCUPY = '1' THEN 'Occupied'
      ELSE 'NON Occupied'
 END)                                                                                       AS Occupancy,                     --AZ: CHANGED NAME FROM occupy TO Occupancy
TO_CHAR(BRW1_1.BRWR_DOB, 'MM/DD/YYYY')                                                      AS borrower_DOB,
TO_CHAR(BRW1_2.BRWR_DOB, 'MM/DD/YYYY')                                                      AS co_borrower_DOB,
(CASE WHEN BRW1_1.BRWR_SEX = '1' THEN 'M'
      WHEN BRW1_1.BRWR_SEX = '2' THEN 'F'
      WHEN BRW1_1.BRWR_SEX = '0' THEN 'U'
      ELSE NULL END)                                                                        AS borrower_gender,
(CASE WHEN BRW1_2.BRWR_SEX = '1' THEN 'M'
      WHEN BRW1_2.BRWR_SEX = '2' THEN 'F'
      WHEN BRW1_2.BRWR_SEX = '0' THEN 'U'
      ELSE NULL END)                                                                        AS co_borrower_gender,
BRW1_1.AGE                                                                                  AS Age_Near_Birth1_Closing,         --AZ: ADDED FIELD
BRW1_2.AGE                                                                                  AS Age_Near_Birth2_Closing,         --AZ: ADDED FIELD
NULL                                                                                        AS Single_Age_Closing,             --AZ: ADDED FIELD | CHANGED NAME FROM Single_Age_AT_Closing TO Single_Age_Current
FLOOR((TRUNC((TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))))
-TRUNC((TO_NUMBER(TO_CHAR(BRW1_1.BRWR_DOB,'YYYYMMDD')))))/10000)                            AS age_birth1_curr,
FLOOR((TRUNC((TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))))
-TRUNC((TO_NUMBER(TO_CHAR(BRW1_2.BRWR_DOB,'YYYYMMDD')))))/10000)                            AS age_birth2_curr,
NULL                                                                                        AS Single_Age_Current,             --AZ: ADDED FIELD
NVL(MASV.INIT_REPAIR_SA,'0.00')                                                             AS original_repair_sa,             --AZ: UPDATED LOGIC
NVL(RLSM.REPAIR_SA,'0.00')                                                                  AS Repair_SA,                      --AZ: CHANGED NAME FROM repair_setAside TO Repair_SA
NVL(MASV.INIT_TAX_INS_SA, '0.00')                                                           AS original_insurance_sa,          --AZ: UPDATED LOGIC
NVL(RLSM.TAX_INS_SA,'0.00')                                                                 AS Tax_Insurance_SA,               --AZ: UPDATED LOGIC & CHANGED NAME FROM mon_tax_ins_SA TO Tax_Insurance_SA
MAS3.LOAN_PURPOSE                                                                           AS loan_purpose,
PRP1.PROP_ADDR                                                                              AS property_address,
PRP1.PROP_CITY                                                                              AS property_city,
PRP1.PROP_STATE                                                                             AS property_sate,
(SUBSTR(PRP1.PROP_ZIP,1,5) ||'-'|| SUBSTR(PRP1.PROP_ZIP,6,5))                               AS property_zip,
NULL						                                                                AS county,                        --AZ: CHAGNE NAME FORM county_name TO County AND UPDATED THE LOGIC
BRW1_1.LAST_NAME                                                                            AS borrowser_last_name,
BRW1_1.FIRST_NAME                                                                           AS borrowser_first_name,
BRW1_2.LAST_NAME                                                                            AS coborrower_last_name,
BRW1_2.FIRST_NAME                                                                           AS coborrower_first_name,
OCCDT.RECEIVED_DATE                                                                         AS occupancy_status_date
FROM SCM7_CD     SCM7 
INNER JOIN(SELECT RLSM.LOAN,RECORD_DATE,LOAN_STATUS, MON_INTEREST, INTEREST_BAL, MON_UNSCHD_PMNT, UNSCHD_PMNT_BAL,SERV_FEE_BAL
                       ,MON_SERV_FEE, PAYOFF_BAL, PAYOFF_REFUND, PAYOFF_DATE, LOAN_BALANCE, INT_RATE ,APPRAISAL_DATE
                       ,MON_PREPMNT,REPAIR_SA, TAX_INS_SA
                 FROM REVLOANSERVICINGMONTH   RLSM
                 WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)
                 AND RLSM.LOAN IN (SELECT SCM7.LOAN
                                   FROM   SCM7_CD SCM7
                                   WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
                 ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT OUTER JOIN (SELECT LOAN, CLOSING_DATE, HUDUPB, LOAN_PURPOSE, LCLTV, L1003CC
                 FROM   MAS3_CD 
                 WHERE  MAS3_CD.HISTORY  = 'L' AND MAS3_CD.ITEM = 'zzz' AND MAS3_CD.STATUS = '1'
                 ) MAS3 ON SCM7.LOAN = MAS3.LOAN
LEFT OUTER JOIN (SELECT  BRW1_1.LOAN, FIRST_NAME, LAST_NAME, AGE, BRWR_DOB, BRWR_SEX, OCCUPY
                 FROM BRW1_CD        BRW1_1
                 INNER JOIN (SELECT MAS1.LOAN,MAS1.BRWR_ID_1
                             FROM   MAS1_CD  MAS1
                             WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                             ) MAS1 ON BRW1_1.LOAN = MAS1.LOAN AND BRW1_1.BRWR_NO = MAS1.BRWR_ID_1
                 WHERE BRW1_1.BRWR_NO = '01' AND BRW1_1.OWN_YN = '1'
                 AND BRW1_1.HISTORY = 'L' AND BRW1_1.ITEM = 'zzz'	AND BRW1_1.STATUS = '1'
                 ) BRW1_1 ON SCM7.LOAN = BRW1_1.LOAN
LEFT OUTER JOIN (SELECT BRW1_2.LOAN, FIRST_NAME, LAST_NAME, AGE, BRWR_DOB, BRWR_SEX, OCCUPY
                 FROM BRW1_CD     BRW1_2
                 INNER JOIN (SELECT MAS1.LOAN,MAS1.BRWR_ID_2
                             FROM   MAS1_CD  MAS1
                             WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                             ) MAS1 ON BRW1_2.LOAN = MAS1.LOAN AND BRW1_2.BRWR_NO = MAS1.BRWR_ID_2
                 WHERE BRW1_2.BRWR_NO = '02' AND BRW1_2.OWN_YN = '1'
                 AND BRW1_2.HISTORY = 'L' AND BRW1_2.ITEM = 'zzz'	AND BRW1_2.STATUS = '1'
                 ) BRW1_2 ON SCM7.LOAN = BRW1_2.LOAN
LEFT OUTER JOIN (SELECT LOAN, FUNDING_DATE, INIT_REPAIR_SA, INIT_TAX_INS_SA, NOTARY_COUNTY_NAME
                 FROM MASV_CD
                 WHERE MASV_CD.HISTORY  = 'L' AND MASV_CD.ITEM = 'zzz' AND MASV_CD.STATUS = '1'
                 ) MASV ON SCM7.LOAN = MASV.LOAN
LEFT OUTER JOIN (SELECT LOAN, PROP_ADDR, PROP_CITY, PROP_STATE, PROP_ZIP, MKT_VALUE, PROP_TYPE,MKT_VAL_DATE,PROP_COUNT_CODE
                 FROM PRP1_CD 
                 WHERE PRP1_CD.HISTORY  = 'L' AND PRP1_CD.ITEM = 'zzz' AND PRP1_CD.PROP_STATUS = '1'
                 ) PRP1 ON SCM7.LOAN = PRP1.LOAN
LEFT OUTER JOIN(SELECT LOAN, LOAN_BALANCE AS PREV_MONTH_BALANCE
                FROM REVLOANSERVICINGMONTH 
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND RECORD_DATE = (SELECT TO_DATE(LAST_DAY(ADD_MONTHS(?,-1)),'DD-MON-YY')+1 AS CurrentMonthFirstDay FROM dual)
                ) PREVMONTHBALANCE ON SCM7.LOAN = PREVMONTHBALANCE.LOAN
LEFT OUTER JOIN(SELECT LOAN, MAX(POST_DATE) AS LAST_PRE_PMT_DT
                FROM REVLOANPREPAYMENTS
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND POST_DATE BETWEEN ? AND ?
                GROUP BY LOAN
                ) LPPD ON SCM7.LOAN = LPPD.LOAN
LEFT JOIN(SELECT LOAN, MAX(POST_DATE) AS LAST_DRAW_DT
                FROM REVLOANPAYMENTS
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND POST_DATE BETWEEN ? AND ?
                GROUP BY LOAN
                ) LDD ON SCM7.LOAN = LDD.LOAN
LEFT OUTER JOIN (SELECT LOAN,
                        MAX(MAS5.DATE_) AS CLOSING_DATE
                 FROM MAS5_CD   MAS5
                 WHERE MAS5.DATE_CDE = 'D15'
                 GROUP BY MAS5.loan
                 ) CLOSING_DATE ON SCM7.LOAN = CLOSING_DATE.LOAN
LEFT OUTER JOIN (SELECT RLOC.LOAN, RLOC.RECEIVED_DATE
                 FROM REVLOANOCCUPANCYCERT   RLOC
                 JOIN (SELECT LOAN, MAX(RECORD_DATE) AS MAXRECORDDATE
                       FROM REVLOANOCCUPANCYCERT
                 GROUP BY LOAN) MAXDT ON RLOC.LOAN = MAXDT.LOAN AND RLOC.RECORD_DATE = MAXDT.MAXRECORDDATE
                 ) OCCDT  ON SCM7.LOAN = OCCDT.LOAN
WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1'
AND SCM7.INVESTOR_CODE = ?
ORDER BY Champion_Loan_Number