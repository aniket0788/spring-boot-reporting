/*********************************************************************************************************************** 
                                        CUSTOM PRIVATE INVESTOR'S MONTHLY ACTIVITY REPORT ALL POOLS
***********************************************************************************************************************/

SELECT
SCM7.INVESTOR_CODE                                                              AS Pool_Name,
SCM7.THEIR_LOAN_NO                                                              AS Investor_Loan_Number,
RLSM.LOAN                                                                       AS Champion_Loan_Number,
(BRW1.FIRST_NAME || ' ' || BRW1.MIDDLE_NAME || ' ' || BRW1.LAST_NAME)           AS Name_of_Borrower,
TO_CHAR(MASV.FUNDING_DATE,'MM/DD/YYYY')                                         AS DateFunded,
NULL/*TO_CHAR(SCM7.ACDELIVERYDATE,'MM/DD/YYYY')*/                               AS DateSold,
PREVMONTHBALANCE.PREV_MONTH_BALANCE                                             AS beginning_balance,
PRP1.PURCHASE_PRICE                                                             AS Balance_Purchased,
NVL(ADJUSTMENTS.ADJUSTMENTS,'0.00')                                             AS CMA_Prior_Period_Adj_Prin,
--'0.00'        		                                                              AS CMA_Pror_Period_Adjust_Inte, -- HARDCODED in JSON
--'0.00'         		                                                              AS CMA_Pror_Period_Adjust_MIP,  -- HARDCODED in JSON
RLSM.MON_PMNT                                                                   AS schedule_advances,
RLSM.MON_UNSCHD_PMNT                                                            AS unscheduled_advances,
RLSM.MON_PREPMNT                                                                AS prepayments,
RLSM.MON_SERV_FEE                                                               AS Servicing_Fee,
RLSM.MON_MIP                                                                    AS MIP_interest_accrued,
RLSM.MON_INTEREST                                                               AS contr_interest_accrued,
RLSM.MON_PAYOFF_FEE                                                             AS payoff_fees,
RLSM.MON_PAYOFF                                                                 AS payoff_amount,
RLSM.PAYOFF_REFUND                                                              AS Excess_or_Shortfall,
RLSM.LOAN_BALANCE                                                               AS Ending_Balance,
/*MAS3.HUDUPB                                                                     AS initial_loan_balance,
RLSM.SCHD_PMNT_BAL                                                              AS IDA_schedule_advances,
RLSM.UNSCHD_PMNT_BAL                                                            AS IDA_unscheduled_advances,
RLSM.PREPMNT_BAL                                                                AS IDA_prepayments,
RLSM.SERV_FEE_BAL                                                               AS IDA_service_fee,
RLSM.MIP_BAL                                                                    AS IDA_MIP_interest_accrued,
RLSM.INTEREST_BAL                                                               AS IDA_contra_Interest_accrued,
RLSM.PAYOFF_FEE_BAL                                                             AS IDA_payoff_fees,
RLSM.PAYOFF_BAL                                                                 AS IDA_payoff_amount,
RLSM.PAYOFF_REFUND                                                              AS IDA_Excess_Shortfall,
RLSM.LOAN_BALANCE                                                               AS IDA_Ending_Balance,*/                  --AZ: ADDED THIS FIELD
RLSM.PAYOFF_DATE                                                                AS PayoffDate,
RLSM.INT_RATE                                                                   AS current_interest_rate,
--NULL                                                                            AS NextScheduledAdvance,
( CASE WHEN RLSM.LOAN_STATUS = '0' THEN 'Servicing'
       WHEN RLSM.LOAN_STATUS = '01' THEN 'Payment Suspended'
       WHEN RLSM.LOAN_STATUS = '02' THEN 'Payment Resumed'
       WHEN RLSM.LOAN_STATUS = '14A' THEN 'Foreclosed: Disrepair'
       WHEN RLSM.LOAN_STATUS = '11' THEN 'Foreclosed: Death'
       WHEN RLSM.LOAN_STATUS = '12' THEN 'Foreclosed: Non Occupancy'
       WHEN RLSM.LOAN_STATUS = '13A' THEN 'Foreclosed: Tax'
       WHEN RLSM.LOAN_STATUS = '13B' THEN 'Foreclosed: Insurance'
       WHEN RLSM.LOAN_STATUS = '13C' THEN 'Foreclosed: Tax and Insurance'
       WHEN RLSM.LOAN_STATUS = '14' THEN 'Foreclosed: Other'
       WHEN RLSM.LOAN_STATUS = '15A' THEN 'Bankrupt: Suspend Pmnt'
       WHEN RLSM.LOAN_STATUS = '15B' THEN 'Bankrupt: No Suspend'
       WHEN RLSM.LOAN_STATUS = '20' THEN 'Deed in lieu'
       WHEN RLSM.LOAN_STATUS = '50' THEN 'Default: Non Occupancy'
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
       WHEN RLSM.LOAN_STATUS = '55' THEN 'Due: Death'
       WHEN RLSM.LOAN_STATUS = '56' THEN 'Due: Non Occupancy'
       WHEN RLSM.LOAN_STATUS = '57A' THEN 'Due: Tax'
       WHEN RLSM.LOAN_STATUS = '57B' THEN 'Due: Insurance'
       WHEN RLSM.LOAN_STATUS = '57C' THEN 'Due: Tax and Insurance'
       WHEN RLSM.LOAN_STATUS = '58A' THEN 'Due: Sell Property'
       WHEN RLSM.LOAN_STATUS = '58B' THEN 'Due: Convey Title'
       WHEN RLSM.LOAN_STATUS = '58D' THEN 'Due: Other'
       WHEN RLSM.LOAN_STATUS = '70' THEN 'Liquid: Held Sale'
       WHEN RLSM.LOAN_STATUS = '74' THEN 'Liquid: Held Sale TBD'
       WHEN RLSM.LOAN_STATUS = '71' THEN 'Liquid: 3rd Party Sale'
       WHEN RLSM.LOAN_STATUS = '72' THEN 'Liquid: Assigned to HUD'
       WHEN RLSM.LOAN_STATUS = '71A' THEN 'Short Sale: Claim Pending'
       WHEN RLSM.LOAN_STATUS = '71B' THEN 'Short Sale: Claim Completed'
       WHEN RLSM.LOAN_STATUS = '73' THEN 'Liquid: Claim Filed'
       ELSE RLSM.LOAN_STATUS
END)                                                                            AS loan_status
/*TO_CHAR(LDD.LAST_DRAW_DT,'MM/DD/YYYY')                                          AS last_draw_date,
RLSM.NEXT_MONTH_INDEX                                                           AS next_interest_rate,
RLSM.PRIN_LIMIT                                                                 AS current_gross_princpal_limit,        --AZ:CHANGED THE NAME FROM current_princpal_limit TO current_gross_princpal_limit
RLSM.LEN_OF_TERM                                                                AS months_remaining*/
FROM SCM7_CD     SCM7
INNER JOIN (SELECT RLSM.LOAN, RLSM.MON_SCHD_PMNT, RLSM.MON_UNSCHD_PMNT, RLSM.MON_PREPMNT, RLSM.MON_SERV_FEE, RLSM.MON_MIP
                       ,RLSM.MON_INTEREST, RLSM.MON_PAYOFF_FEE ,RLSM.MON_PAYOFF, RLSM.PAYOFF_REFUND, RLSM.SCHD_PMNT_BAL
                       ,RLSM.UNSCHD_PMNT_BAL ,RLSM.PREPMNT_BAL, RLSM.SERV_FEE_BAL, RLSM.MIP_BAL,RLSM.INTEREST_BAL
                       ,RLSM.PAYOFF_FEE_BAL, RLSM.PAYOFF_BAL, RLSM.PAYOFF_DATE, RLSM.INT_RATE,RLSM.LOAN_BALANCE
                       ,RLSM.LOAN_STATUS, RLSM.NEXT_MONTH_INDEX, RLSM.PRIN_LIMIT, RLSM.LEN_OF_TERM,RLSM.MON_PMNT,RECORD_DATE
                 FROM REVLOANSERVICINGMONTH RLSM
                 WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)                 
                 ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT OUTER JOIN (SELECT LOAN, ACINVESTORCODE, HUDUPB,ORIG_LOAN_AMT,INDEX_TYPE
                 FROM   MAS3_CD   MAS3_CD
                 WHERE  MAS3_CD.HISTORY  = 'L' AND MAS3_CD.ITEM = 'zzz' AND MAS3_CD.STATUS = '1'
                 ) MAS3 ON SCM7.LOAN = MAS3.LOAN
LEFT OUTER JOIN (SELECT LOAN,FIRST_NAME,MIDDLE_NAME,LAST_NAME
                 FROM   BRW1_CD   BRW1
                 WHERE  BRW1.HISTORY = 'L' AND BRW1.ITEM = 'zzz'	AND BRW1.STATUS = '1' AND BRW1.BRWR_NO = '01'
                 ) BRW1 ON SCM7.LOAN = BRW1.LOAN
LEFT OUTER JOIN (SELECT LOAN,FUNDING_DATE
                 FROM   MASV_CD   MASV
                 WHERE  MASV.HISTORY  = 'L' AND MASV.ITEM = 'zzz' AND MASV.STATUS = '1'
                 ) MASV ON SCM7.LOAN = MASV.LOAN
LEFT OUTER JOIN (SELECT LOAN,PURCHASE_PRICE
                 FROM   PRP1_CD   PRP1
                 WHERE  PRP1.HISTORY  = 'L' AND PRP1.ITEM = 'zzz' AND PRP1.PROP_STATUS = '1'
                 ) PRP1 ON SCM7.LOAN = PRP1.LOAN
LEFT OUTER JOIN(SELECT RLPP.LOAN
                      ,SUM(CASE WHEN RLPP.PREPAY_TYPE IN ('105A')                     THEN AMOUNT
                                WHEN RLPP.PREPAY_TYPE IN ('105','105B','105C','105D') THEN -1*AMOUNT
                           END) AS ADJUSTMENTS
                 FROM REVLOANPREPAYMENTS   RLPP
                 WHERE RLPP.POST_DATE BETWEEN ? AND ?
                 AND RLPP.HISTORY = 'L' AND  RLPP.ITEM = 'zzz' AND RLPP.STATUS = '1'
                 GROUP BY RLPP.LOAN
                 ) ADJUSTMENTS ON SCM7.LOAN = ADJUSTMENTS.LOAN
LEFT OUTER JOIN(SELECT RLSM.LOAN
                      ,RLSM.LOAN_BALANCE AS PREV_MONTH_BALANCE
                FROM REVLOANSERVICINGMONTH   RLSM 
                WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(ADD_MONTHS(?,-1)),'DD-MON-YY')+1 AS CurrentMonthFirstDay FROM dual)
                ) PREVMONTHBALANCE ON SCM7.LOAN = PREVMONTHBALANCE.LOAN
WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1'
AND RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)
--AND SCM7.INVESTOR_CODE IN (?)     --To Include All the Pools
AND RLSM.LOAN_STATUS != '60'
ORDER BY INVESTOR_LOAN_NUMBER,POOL_NAME