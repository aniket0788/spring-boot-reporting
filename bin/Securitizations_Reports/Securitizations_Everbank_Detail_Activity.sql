/*********************************************************************************************************************** 
                                          PRIVATE INVESTOR'S MONTHLY DETAIL REPORT 
***********************************************************************************************************************/
SELECT 
SCM7.THEIR_LOAN_NO                                                              AS Loan_Number,
RLP.POST_DATE                                                                   AS draw_date,
RLP.AMOUNT                                                                      AS amount,
'Unscheduled'                                                                   AS transaction_type,
(CASE WHEN RLP.PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D'
                           ,'45','46','47','48','49','90','91','92','93','94','95'
                           ,'96','43')
      THEN (SELECT TRIM(BOTH ' ' FROM TO_CHAR(((RLP.AMOUNT*RLSM.INT_RATE*(SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')-TO_DATE(?,'DD-MON-YY') AS DATEDIFF FROM DUAL))/'36500'),'9999.99')) AS interest_due
            FROM DUAL)
      ELSE '0.00'
 END)                                                                           AS interest_due,
RLSM.PAYOFF_DATE                                                                AS payoff_date, 
RLSM.PAYOFF_BAL                                                                 AS payoff_amount
FROM SCM7_CD       SCM7
LEFT JOIN (SELECT LOAN,MON_INTEREST,PAYOFF_DATE,PAYOFF_BAL,RECORD_DATE,INT_RATE
           FROM REVLOANSERVICINGMONTH RLSM
           WHERE RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1  AS NextMonthFirstDay FROM DUAL)                
           AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
           ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT JOIN(SELECT LOAN,POST_DATE,AMOUNT,PAY_TYPE
          FROM REVLOANPAYMENTS   RLP
          WHERE RLP.HISTORY = 'L' and  RLP.item = 'zzz' AND RLP.STATUS = '1'
          ) RLP ON SCM7.LOAN = RLP.LOAN
WHERE RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1  AS NextMonthFirstDay FROM DUAL)
AND RLP.POST_DATE BETWEEN ? AND ?
AND RLP.PAY_TYPE NOT IN ('P00','P01','P02','P03')
AND SCM7.INVESTOR_CODE IN (?)

UNION ALL

SELECT 
SCM7.THEIR_LOAN_NO                                                              AS Loan_Number,
RLPP.POST_DATE                                                                  AS draw_date,
RLPP.AMOUNT*-1                                                                  AS amount,
'Repayment'                                                                     AS transaction_type,
(CASE WHEN PREPAY_TYPE IN ('31','32','33','35','34A','34B','34C','65','80','81'
                       ,'82','83','84','80A','80B','80C','80D','80E')
      THEN (SELECT TRIM(BOTH ' ' FROM TO_CHAR(((RLPP.AMOUNT*-1*RLSM.INT_RATE*(SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')-TO_DATE(?,'DD-MON-YY') AS DATEDIFF FROM DUAL))/'36500'),'9999.99')) AS interest_due
            FROM DUAL)
      ELSE '0.00'
 END)                                                                           AS interest_due,
RLSM.PAYOFF_DATE                                                                AS payoff_date, 
RLSM.PAYOFF_BAL                                                                 AS payoff_amount
FROM SCM7_CD       SCM7
LEFT JOIN (SELECT LOAN,MON_INTEREST,PAYOFF_DATE,PAYOFF_BAL,RECORD_DATE,INT_RATE
                 FROM REVLOANSERVICINGMONTH RLSM
                 WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)                
                 AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
                 ) RLSM ON SCM7.LOAN = RLSM.LOAN
LEFT JOIN (SELECT LOAN,POST_DATE,AMOUNT,PREPAY_TYPE
                 FROM REVLOANPREPAYMENTS   RLPP
                 WHERE RLPP.HISTORY = 'L' and  RLPP.item = 'zzz' AND RLPP.STATUS = '1'
                ) RLPP ON SCM7.LOAN = RLPP.LOAN
WHERE RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1  AS NextMonthFirstDay FROM DUAL)
AND RLPP.POST_DATE BETWEEN ? AND ?
AND SCM7.INVESTOR_CODE IN (?)
ORDER BY LOAN_NUMBER