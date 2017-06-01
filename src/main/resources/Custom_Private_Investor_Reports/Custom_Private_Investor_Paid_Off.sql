/*********************************************************************************************************************** 
                                     CUSTOM PRIVATE INVESTOR'S METSCRDEN MONTHLY PAYOFF REPORT 
***********************************************************************************************************************/
SELECT
SCM7.INVESTOR_CODE                                                              AS Pool_Name,
SCM7.THEIR_LOAN_NO                                                              AS Loan_Number,
SCM7.LOAN                                                                       AS Champion_Loan_Number,
(BRW1.FIRST_NAME || ' ' || BRW1.MIDDLE_NAME || ' ' || BRW1.LAST_NAME)           AS Name_of_Borrower,
(RLS.SERV_FEE_BAL-RLSM.SERV_FEE_BAL)                                            AS Servicing_Fee,
(RLS.MIP_BAL-RLSM.MIP_BAL)                                                      AS MIP_interest_accrued,
(RLPP.LEGAL_FEES + RLPP.HUD_DISBURSEMENTS + RLPP.PROP_PRES_FEES
 + RLPP.LOSS_DRAFT_FUNDS + RLPP.TITLE_FEE_AND_RECD_FEES + RLPP.COUNTY_RECD_FEES
 + RLPP.MISC_SERV_FEE)                                                          AS payoff_fees,
RLS.PAYOFF_BAL                                                                  AS payoff_amount,
RLS.PAYOFF_REFUND                                                               AS Excess_or_Shortfall,
RLPP.LOAN_BALANCE                                                               AS Ending_Balance,
RLSM.PAYOFF_DATE                                                                AS PayoffDate,
RLS.INT_RATE                                                                    AS current_interest_rate,
--'Payoff'                                                                        AS loan_status,      --HARDCODED in JSON
PRP1.PROP_ADDR                                                                  AS Property_Adress,                    --AZ: ADDED FIELD
PRP1.PROP_CITY                                                                  AS Property_City,                      --AZ: ADDED FIELD
PRP1.PROP_STATE                                                                 AS Property_State,                     --AZ: ADDED FIELD
PRP1.PROP_ZIP                                                                   AS Property_Zip                        --AZ: ADDED FIELD
FROM SCM7_CD     SCM7
INNER JOIN (SELECT RLPP.LOAN,RLPP.PREPAY_TYPE,RLPP.POST_DATE,RLPP.LEGAL_FEES,RLPP.HUD_DISBURSEMENTS,RLPP.PROP_PRES_FEES
                  ,RLPP.LOSS_DRAFT_FUNDS,RLPP.TITLE_FEE_AND_RECD_FEES,RLPP.COUNTY_RECD_FEES,RLPP.MISC_SERV_FEE
                  ,LOAN_BALANCE,STATUS
            FROM REVLOANPREPAYMENTS RLPP
            ) RLPP ON SCM7.LOAN = RLPP.LOAN
LEFT OUTER JOIN (SELECT RLS.LOAN,RLS.MIP_BAL,RLS.SERV_FEE_BAL,RLS.PAYOFF_BAL,RLS.PAYOFF_REFUND,INT_RATE
                 FROM REVLOANSERVICING RLS
                 ) RLS ON SCM7.LOAN = RLS.LOAN
LEFT OUTER JOIN (SELECT RLSM.LOAN,MON_PAYOFF,PAYOFF_REFUND,INT_RATE,PAYOFF_DATE,LOAN_STATUS,SERV_FEE_BAL
                       ,MIP_BAL
                 FROM REVLOANSERVICINGMONTH RLSM
                 WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(ADD_MONTHS(?,-1)),'DD-MON-YY')+1 AS CurrentMonthFirstDay FROM DUAL)
                 AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
                 ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT OUTER JOIN (SELECT LOAN,FIRST_NAME,MIDDLE_NAME,LAST_NAME
                 FROM   BRW1_CD   BRW1
                 WHERE  BRW1.HISTORY = 'L' AND BRW1.ITEM = 'zzz' AND BRW1.STATUS = '1' AND BRW1.BRWR_NO = '01'
                 ) BRW1 ON SCM7.LOAN = BRW1.LOAN
LEFT OUTER JOIN (SELECT LOAN,PROP_ADDR, PROP_CITY, PROP_STATE, PROP_ZIP
                 FROM    PRP1_CD   PRP1
                 WHERE  PRP1.HISTORY  = 'L' AND PRP1.ITEM = 'zzz' AND PRP1.PROP_STATUS = '1'
                 ) PRP1 ON SCM7.LOAN = PRP1.LOAN
WHERE SCM7.HISTORY  = 'L' AND SCM7.ITEM = 'zzz' AND SCM7.STATUS = '1'
AND ((RLPP.POST_DATE >= ? AND RLPP.POST_DATE <= ?) AND RLPP.PREPAY_TYPE IN ('31','32','33','34','35','65'))
AND RLPP.STATUS = '1'
AND SCM7.INVESTOR_CODE IN (?)
ORDER BY LOAN_NUMBER