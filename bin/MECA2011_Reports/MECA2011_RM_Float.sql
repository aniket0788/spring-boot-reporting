/*********************************************************************************************************************** 
                                        MECA-2011: RM_Float_<SERVICER#>_<YYYYMM>_V<N>
***********************************************************************************************************************/

SELECT 
TO_CHAR(DATERANGE.POST_DATE, 'MM/DD/YYYY')              								 AS Effective_Date,
null                                                    								 AS Non_Cash,
TO_CHAR(NVL(PAYOFF.sumofPayoffs,'0.00'),'FM$999,999,999,990.00')                       	 AS Payoff,
TO_CHAR(NVL(PREPAY.prepaymentamounts,'0.00'),'FM$999,999,999,990.00')                    AS Prepayment,
TO_CHAR(NVL(UNSCHEDULED.sumofunschedule,'0.00'),'FM$999,999,999,990.00')                 AS Unscheduled,
TO_CHAR(NVL(SCHEDULED.schedulesum,'0.00'),'FM$999,999,999,990.00')                       AS Scheduled,
TO_CHAR((NVL(UNSCHEDULED.sumofunschedule,'0.00') + 
 NVL(SCHEDULED.schedulesum,'0.00')),'FM$999,999,999,990.00')                     		 AS Advances,
TO_CHAR((NVL(PAYOFF.sumofPayoffs,'0.00') + 
 NVL(PREPAY.prepaymentamounts,'0.00')),'FM$999,999,999,990.00')                  		 AS Receipts
FROM (SELECT DISTINCT TO_DATE(POST_DATE, 'DD-MON-YY')   AS POST_DATE
      FROM REVLOANPREPAYMENTS	
      WHERE TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
      AND PREPAY_TYPE IN ('31','32','33','34','34A','34B','34C','35','80','80A','80B','80C','80D','80E','81','82','83','84','85','86')
      AND STATUS = '1'
      UNION
      SELECT DISTINCT TO_DATE(POST_DATE, 'DD-MON-YY') AS POST_DATE
      FROM REVLOANPAYMENTS	
      WHERE TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
      AND PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D','45','46','47','48','49',
                       '90','91','92','93','94','95','96','97','98','99','P00')
      AND STATUS = '1'
      ) DATERANGE
LEFT OUTER JOIN (SELECT TO_DATE(POST_DATE, 'DD-MON-YY')  AS payoffdate
                       ,SUM(AMOUNT)*-1                   AS sumofPayoffs
                 FROM  REVLOANPREPAYMENTS  REVPMT
                 WHERE REVPMT.PREPAY_TYPE IN ('31','32','33','34','35')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 AND STATUS = '1'
                 GROUP BY TO_DATE(POST_DATE, 'DD-MON-YY')
                 ) PAYOFF	ON TO_DATE(DATERANGE.POST_DATE, 'DD-MON-YY') = TO_DATE(PAYOFF.payoffdate, 'DD-MON-YY')
LEFT OUTER JOIN (SELECT TO_DATE(POST_DATE, 'DD-MON-YY')  AS prepaydate
                       ,SUM(AMOUNT)*-1                   AS prepaymentamounts
                 FROM REVLOANPREPAYMENTS  REVPMT
                 WHERE REVPMT.PREPAY_TYPE IN ('80','81','82','83','84','85','86','80A','80B','80C','80D','80E')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ?
                 AND STATUS = '1'
                 GROUP BY TO_DATE(POST_DATE, 'DD-MON-YY')
                 ) PREPAY	ON TO_DATE(DATERANGE.POST_DATE, 'DD-MON-YY') = TO_DATE(PREPAY.prepaydate, 'DD-MON-YY')
LEFT OUTER JOIN (SELECT TO_DATE(POST_DATE, 'DD-MON-YY')   AS unscheduledate
                       ,SUM(AMOUNT)                       AS sumofunschedule
                 FROM  REVLOANPAYMENTS  revpmt
                 WHERE revpmt.PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D','45','46',
                                           '47','48','49','90','91','92','93','94','95','96','97','98','99')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 AND STATUS = '1'
                 GROUP BY TO_DATE(POST_DATE, 'DD-MON-YY')
                 ) UNSCHEDULED ON TO_DATE(DATERANGE.POST_DATE, 'DD-MON-YY') = TO_DATE(UNSCHEDULED.unscheduledate, 'DD-MON-YY')
LEFT OUTER JOIN (SELECT TO_DATE(POST_DATE, 'DD-MON-YY')   AS scheduledate
                       ,SUM(AMOUNT)                       AS schedulesum
                 FROM REVLOANPAYMENTS  revpmt
                 WHERE revpmt.PAY_TYPE IN ('P00')	
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 AND STATUS = '1'
                 GROUP BY TO_DATE(POST_DATE, 'DD-MON-YY')
                 ) SCHEDULED	ON TO_DATE(DATERANGE.POST_DATE, 'DD-MON-YY') = TO_DATE(SCHEDULED.scheduledate, 'DD-MON-YY')
ORDER BY TO_DATE(DATERANGE.POST_DATE, 'DD-MON-YY')