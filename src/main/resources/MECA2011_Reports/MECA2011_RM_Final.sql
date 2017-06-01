---------------------------------- Final --------------------------------------------------------
select 

RLSM.LOAN                                                   as Loan_Number,
SCM7.THEIR_LOAN_NO                                          as LOANHIST_TEMPLATE_CSV,
loaninfo.PRIOR_SERVICER_NUM                                 as Servicer_Loan_Number,     --- take the new mapping most likely loan_info.prior_servicer_number 
'600'                                                       as Investor_Number,
'1'                                                         as Sale_Number,
(CASE WHEN PREVMONTHBALANCE.PREV_MONTH_BALANCE is null THEN 0.00
      ELSE PREVMONTHBALANCE.PREV_MONTH_BALANCE
 END)                                                       as Beginning_Balance,  
 
--(MAX(REVLOANPAYMENTS.POST_DATE)*-1) as Last_Unscheduled_Draw_Date,  --  How date can be negative
--  (MAX(REVLOANPAYMENTS.POST_DATE)) as Last_Unscheduled_Draw_Date,
TO_CHAR(LUDD.last_unscheduled_date,'dd-Mon-yy')          	as Last_Unscheduled_Draw_Date,
(CASE WHEN RLSM.MON_UNSCHD_PMNT is null THEN 0.00
      ELSE RLSM.MON_UNSCHD_PMNT*-1
 END)                                                       as Unscheduled_Draws, 
TO_CHAR(LSDD.last_scheduled_date,'dd-Mon-yy')   	        as Last_Scheduled_Draw_Date,
(CASE WHEN RLSM.MON_SCHD_PMNT is null THEN 0.00
      ELSE RLSM.MON_SCHD_PMNT*-1
 END)                                                       as Scheduled_Draws,
(CASE WHEN RLSM.LEN_OF_TERM is null THEN 0.00
      ELSE RLSM.LEN_OF_TERM
 END)                                                       as Sch_Draw_Rem_Term,
to_char(RLSM.PAYOFF_DATE,'dd-Mon-yy')                       as Payoff_Liquidation_Date,
(CASE WHEN RLSM.PAYOFF_BAL is null THEN 0.00                -- TAKEN PAYOFF_BAL INSTEAD OF PAYOFF_AMOUNT
      ELSE RLSM.PAYOFF_BAL*-1
 END)                                                       as Payoff_Liquidation,      
--MAX(revloanprepayments.POST_DATE) as Borrower_Funds_Received_Date,
TO_CHAR(BFRD.borr_funds_recvd_dt,'dd-Mon-yy')   		    as Borrower_Funds_Received_Date,
(CASE WHEN BFR.borr_funds_recvd is null THEN 0.00
      ELSE BFR.borr_funds_recvd*-1
 END)                                                       as Borrower_Funds_Received,
null                                                        as Servicer_Credits_Date,
0.00                                                        as Servicer_Credits,
to_char(DRRD.updated_on,'dd-Mon-yy')      			        as Disburmnt_Rept_Reversals_Date,
(CASE WHEN DRR.disbursmnt_receipt_reversals is null THEN 0.00
      ELSE DRR.disbursmnt_receipt_reversals
 END)                                                       as Disbursement_Receipt_Reversals,
null                                                        as Servicer_Advances_Date,
null                                                        as Servicer_Advances,
(CASE WHEN RLSM.MON_INTEREST is null THEN 0.00
      ELSE RLSM.MON_INTEREST*-1
 END)                                                       as Accrued_Interest,
(CASE WHEN RLSM.MON_SERV_FEE is null THEN 0.00
      ELSE RLSM.MON_SERV_FEE*-1
 END)                                                       as Accrued_Service_Fees,
(CASE WHEN RLSM.MON_MIP is null THEN 0.00
      ELSE RLSM.MON_MIP*-1
 END)                                                       as Accrued_MIP,
(CASE WHEN RLSM.LOAN_BALANCE is null THEN 0.00
      ELSE RLSM.LOAN_BALANCE
 END)                                                       as Current_Balance,
(CASE WHEN RLSM.NET_PRIN_LIMIT is null THEN 0.00
      ELSE RLSM.NET_PRIN_LIMIT
 END)                                                       as Current_Loan_Limit,
(CASE WHEN RLSM.NET_LOC is null THEN 0.00
      ELSE RLSM.NET_LOC
 END)                                                       as Curr_Availble_Line_of_Credit,
RLSM.INT_RATE                                               as Current_Rate,
MAS3.INT_CH_RATE		 									as Rate_Adjustment_Frequency,
null                                                        as Next_Rate_Adjustment_Date, --TBD
MAS3.INDEX_TYPE                                             as "Index",
MAS3.MARGIN                                                 as Margin,
MAS3.LIFE_CAP                                               as Ceiling_Rate,
MAS3.LIFE_FLOOR                                             as Floor_Rate,
(CASE WHEN MAS3.INDEX_TYPE = '1K' AND MAS3.INT_CH_RATE = '12' THEN 'ARM 856'
      WHEN MAS3.INDEX_TYPE = '1K' AND MAS3.INT_CH_RATE = '1' THEN 'ARM 857'
      WHEN MAS3.INDEX_TYPE = '20' THEN 'ARM 858'
      WHEN MAS3.INDEX_TYPE = '21' THEN 'ARM 1526'
      WHEN MAS3.INDEX_TYPE = '28' THEN 'ARM 860'
      else null 
   END)                                                     as Rate_Type,   
--MAS3_CD.INDEX_TYPE as Rate_Type_Description,
(CASE WHEN MAS3.INDEX_TYPE = '1G' THEN '1 MONTH CD WTA'
      WHEN MAS3.INDEX_TYPE = '31' THEN '1 MONTH COFI'
      WHEN MAS3.INDEX_TYPE = '20' THEN '1 MONTH HECM LIBOR'
      WHEN MAS3.INDEX_TYPE = '21' THEN '1 MONTH LIBOR'
      WHEN MAS3.INDEX_TYPE = '41' THEN '1 MONTH MTA'
      WHEN MAS3.INDEX_TYPE = '11' THEN '1 MONTH T BILL'
      WHEN MAS3.INDEX_TYPE = 'Z1' THEN '1 MONTH TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '27' THEN '1 YEAR  LIBOR'
      WHEN MAS3.INDEX_TYPE = '17' THEN '1 YEAR CMT'
      WHEN MAS3.INDEX_TYPE = '1K' THEN '1 YEAR CMT WTA'
      WHEN MAS3.INDEX_TYPE = '37' THEN '1 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '28' THEN '1 YEAR HECM LIBOR'
      WHEN MAS3.INDEX_TYPE = '47' THEN '1 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = 'T1' THEN '1 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '3J' THEN '10 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '2J' THEN '10 YEAR LIBOR'
      WHEN MAS3.INDEX_TYPE = '2K' THEN '10 YEAR LIBOR SWAP'
      WHEN MAS3.INDEX_TYPE = '4J' THEN '10 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = '1J' THEN '10 YEAR T BILL'
      WHEN MAS3.INDEX_TYPE = '1L' THEN '10 YEAR T BILL WT'
      WHEN MAS3.INDEX_TYPE = 'TA' THEN '10 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = 'C1' THEN '11TH DISTRICT COFI'
      WHEN MAS3.INDEX_TYPE = 'M1' THEN '12 MAT/MTA-MONTHLY TREASURY'
      WHEN MAS3.INDEX_TYPE = 'Z2' THEN '2 MONTH TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '39' THEN '2 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '29' THEN '2 YEAR LIBOR'
      WHEN MAS3.INDEX_TYPE = '49' THEN '2 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = '19' THEN '2 YEAR T BILL'
      WHEN MAS3.INDEX_TYPE = 'T2' THEN '2 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = 'TK' THEN '20 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '33' THEN '3 MONTH COFI'
      WHEN MAS3.INDEX_TYPE = '23' THEN '3 MONTH LIBOR'
      WHEN MAS3.INDEX_TYPE = '43' THEN '3 MONTH MTA'
      WHEN MAS3.INDEX_TYPE = '13' THEN '3 MONTH T BILL'
      WHEN MAS3.INDEX_TYPE = 'Z3' THEN '3 MONTH TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '3B' THEN '3 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '2B' THEN '3 YEAR LIBOR'
      WHEN MAS3.INDEX_TYPE = '4B' THEN '3 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = '1B' THEN '3 YEAR T BILL'
      WHEN MAS3.INDEX_TYPE = 'T3' THEN '3 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = 'TU' THEN '30 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '3D' THEN '5 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '2D' THEN '5 YEAR LIBOR'
      WHEN MAS3.INDEX_TYPE = '4D' THEN '5 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = '1D' THEN '5 YEAR T BILL'
      WHEN MAS3.INDEX_TYPE = 'T5' THEN '5 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '35' THEN '6 MONTH COFI'
      WHEN MAS3.INDEX_TYPE = '24' THEN '6 MONTH LIBOR -FNMA'
      WHEN MAS3.INDEX_TYPE = '25' THEN '6 MONTH LIBOR -WSJ'
      WHEN MAS3.INDEX_TYPE = '45' THEN '6 MONTH MTA'
      WHEN MAS3.INDEX_TYPE = '15' THEN '6 MONTH T BILL'
      WHEN MAS3.INDEX_TYPE = 'Z6' THEN '6 MONTH TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = '3F' THEN '7 YEAR COFI'
      WHEN MAS3.INDEX_TYPE = '2F' THEN '7 YEAR LIBOR'
      WHEN MAS3.INDEX_TYPE = '4F' THEN '7 YEAR MTA'
      WHEN MAS3.INDEX_TYPE = '1F' THEN '7 YEAR T BILL'
      WHEN MAS3.INDEX_TYPE = 'T7' THEN '7 YEAR TREASURY YIELD'
      WHEN MAS3.INDEX_TYPE = 'C7' THEN '7TH DISTRICT COFI'
      WHEN MAS3.INDEX_TYPE = 'L1' THEN 'CONTRACT INT RATE, PURCHASE OF PREV OCCUPIED HOMES, NATIONAL AVE FOR ALL MAJOR TYPES OF LENDERS'
      WHEN MAS3.INDEX_TYPE = 'U9' THEN 'FHLMC 15 YEAR 90 DAY INDEX-commit'
      WHEN MAS3.INDEX_TYPE = 'U3' THEN 'FHLMC 30 YEAR 90 DAY INDEX-predatory tes'
      WHEN MAS3.INDEX_TYPE = 'U7' THEN 'FNMA 15 YEAR 90 DAY INDEX-commit'
      WHEN MAS3.INDEX_TYPE = 'U4' THEN 'FNMA 30 YEAR 90 DAY INDEX-mandatory'
      WHEN MAS3.INDEX_TYPE = 'HF' THEN 'HECM FIXED'
      WHEN MAS3.INDEX_TYPE = '50' THEN 'NATIONAL MEDIAN COFI'
      WHEN MAS3.INDEX_TYPE = 'P1' THEN 'PRIME'
      WHEN MAS3.INDEX_TYPE = 'L2' THEN 'T BILL WEEKLY'
      WHEN MAS3.INDEX_TYPE = 'RF' THEN 'TODAY RETAIL FHA INTEREST RATE'
      WHEN MAS3.INDEX_TYPE = 'TN' THEN 'TREASURY NOTE'
     
      ELSE NULL
END)                                                            as Rate_Type_Description,

(CASE WHEN revchange.NEW_PMNT_PLAN  = 'LC' THEN '5'
      WHEN revchange.NEW_PMNT_PLAN  = 'MN' THEN '4'
      WHEN revchange.NEW_PMNT_PLAN  = 'MM' THEN '3'
      WHEN revchange.NEW_PMNT_PLAN  = 'TN' THEN '2'
      WHEN revchange.NEW_PMNT_PLAN  = 'TM' THEN '1'
      else null 
   END)                                         				as Product_Type,
(CASE WHEN revchange.NEW_PMNT_PLAN  = 'LC' THEN 'Line of Credit'
      WHEN revchange.NEW_PMNT_PLAN  = 'MN' THEN 'Modified Tenure'
      WHEN revchange.NEW_PMNT_PLAN  = 'MM' THEN 'Modified Term'
      WHEN revchange.NEW_PMNT_PLAN  = 'TN' THEN 'Tenure'
      WHEN revchange.NEW_PMNT_PLAN  = 'TM' THEN 'Term'
      else null 
   END)					                                        as Product_Type_Description,
to_char(BRW1_1.BRWR_DOB,'dd-Mon-yy')                            as Borrower_1_Date_of_Death,
to_char(BRW1_2.BRWR_DOB,'dd-Mon-yy')                            as Borrower_2_Date_of_Death,
RLSM.LOAN_STATUS                                                as Loan_Status,
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
END)                                                 			as Loan_Status_Description,
(CASE WHEN RLSM.SERV_FEE_SA is null THEN 0.00
      ELSE RLSM.SERV_FEE_SA
 END)                                                           as Current_Service_Fee_Set_Aside,
(CASE WHEN RLSM.REPAIR_SA is null THEN 0.00
      ELSE RLSM.REPAIR_SA
 END)                                                           as Current_Repair_Admin_Set_Aside,
(CASE WHEN RLSM.TAX_INS_SA is null THEN 0.00
      ELSE RLSM.TAX_INS_SA
 END)                                                           as Current_TnI_Set_Aside

from 

  SCM7_CD SCM7
  --REVLOANSERVICINGMONTH, SCM7_CD, REVLOANPAYMENTS, REVLOANPREPAYMENTS, MAS3_CD , REVPLANCHANGE , BRW1_CD
  
  INNER JOIN(SELECT RLSM.LOAN,LOAN_BALANCE,MON_UNSCHD_PMNT,MON_SCHD_PMNT,LEN_OF_TERM, PAYOFF_BAL , 
                    MON_INTEREST, MON_SERV_FEE , MON_MIP , NET_PRIN_LIMIT, NET_LOC ,
                    LOAN_STATUS, SERV_FEE_SA, REPAIR_SA, TAX_INS_SA , INT_RATE, PAYOFF_DATE
                 FROM REVLOANSERVICINGMONTH   RLSM
                 WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(?),'DD-MON-YY')+1 AS NextMonthFirstDay FROM DUAL)
                 AND RLSM.LOAN IN (SELECT SCM7.LOAN
                                   FROM   SCM7_CD SCM7
                                   WHERE  SCM7.INVESTOR_CODE = ?)
                 AND RLSM.HISTORY ='L' AND RLSM.ITEM = 'zzz' AND RLSM.STATUS = '1'
                 ) RLSM ON SCM7.LOAN = RLSM.LOAN
  
  LEFT OUTER JOIN (SELECT  BRW1_1.LOAN, BRWR_DOB
                   FROM BRW1_CD        BRW1_1
                     INNER JOIN (SELECT MAS1.LOAN,MAS1.BRWR_ID_1
                                  FROM   MAS1_CD  MAS1
                                  WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                                ) MAS1 ON BRW1_1.LOAN = MAS1.LOAN AND BRW1_1.BRWR_NO = MAS1.BRWR_ID_1
                    WHERE BRW1_1.BRWR_NO = '01' --AND BRW1_1.OWN_YN = '1'
                    AND BRW1_1.HISTORY = 'L' AND BRW1_1.ITEM = 'zzz'	AND BRW1_1.STATUS = '1'
                  ) BRW1_1 ON SCM7.LOAN = BRW1_1.LOAN
  
  LEFT OUTER JOIN (SELECT BRW1_2.LOAN, BRWR_DOB
                    FROM BRW1_CD     BRW1_2
                     INNER JOIN (SELECT MAS1.LOAN,MAS1.BRWR_ID_2
                                   FROM   MAS1_CD  MAS1
                                   WHERE  MAS1.HISTORY = 'L' AND MAS1.ITEM = 'zzz' AND MAS1.STATUS = '1'
                                ) MAS1 ON BRW1_2.LOAN = MAS1.LOAN AND BRW1_2.BRWR_NO = MAS1.BRWR_ID_2
                   WHERE BRW1_2.BRWR_NO = '02' --AND BRW1_2.OWN_YN = '1'
                   AND BRW1_2.HISTORY = 'L' AND BRW1_2.ITEM = 'zzz'	AND BRW1_2.STATUS = '1'
                 ) BRW1_2 ON SCM7.LOAN = BRW1_2.LOAN
                 
  LEFT OUTER JOIN(SELECT LOAN, NEW_PMNT_PLAN,
  					Row_number() over (PARTITION BY revplanchange.loan ORDER BY revplanchange.idx DESC) AS rn
                FROM REVPLANCHANGE 
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND history='L' 
                AND item='zzz' 
                AND status='1'
                AND POST_DATE BETWEEN ? AND ?
                --GROUP BY LOAN
                ) revchange ON SCM7.LOAN = revchange.LOAN               
  
  LEFT OUTER JOIN(SELECT LOAN, MAX(TO_DATE(POST_DATE, 'DD-MON-YY')) AS last_unscheduled_date
                 FROM  REVLOANPAYMENTS  revpmt
                 WHERE revpmt.PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D','45','46',
                                           '47','48','49','90','91','92','93','94','95','96','97','98','99')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 GROUP BY LOAN
                ) LUDD ON SCM7.LOAN = LUDD.LOAN
  LEFT OUTER JOIN(SELECT LOAN, MAX(TO_DATE(POST_DATE, 'DD-MON-YY')) AS last_scheduled_date
                 FROM  REVLOANPAYMENTS  revpmt
                 WHERE revpmt.PAY_TYPE = 'P00'
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 GROUP BY LOAN
                ) LSDD ON SCM7.LOAN = LSDD.LOAN
                
  LEFT OUTER JOIN(SELECT LOAN, MAX(TO_DATE(POST_DATE, 'DD-MON-YY')) AS borr_funds_recvd_dt
                 FROM  REVLOANPREPAYMENTS  revprepmt
                 WHERE revprepmt.PREPAY_TYPE IN ('80','81','82','83','84','85','86','80A','80B','80C','80D','80E')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 GROUP BY LOAN
                ) BFRD ON SCM7.LOAN = BFRD.LOAN 
                
  LEFT OUTER JOIN(SELECT LOAN, SUM(AMOUNT) AS borr_funds_recvd
                 FROM  REVLOANPREPAYMENTS  revprepmt
                 WHERE revprepmt.PREPAY_TYPE IN ('80','81','82','83','84','85','86','80A','80B','80C','80D','80E')
                 AND TO_DATE(POST_DATE, 'DD-MON-YY') BETWEEN ? AND ? 
                 GROUP BY LOAN
                ) BFR ON SCM7.LOAN = BFR.LOAN 
                
  LEFT OUTER JOIN(SELECT LOAN,MAX(UPDATED_ON) as updated_on
                FROM REVLOANPAYMENTS
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND POST_DATE BETWEEN ? AND ?
                AND status='0'
                group BY LOAN
                ) DRRD ON SCM7.LOAN = DRRD.LOAN             
   
   LEFT OUTER JOIN(SELECT LOAN,SUM(AMOUNT) as disbursmnt_receipt_reversals
                FROM REVLOANPAYMENTS
                WHERE LOAN IN (SELECT SCM7.LOAN
                               FROM   SCM7_CD SCM7
                               WHERE  SCM7.INVESTOR_CODE = ?)
                AND POST_DATE BETWEEN ? AND ?
                AND status='0'
                group BY LOAN
                ) DRR ON SCM7.LOAN = DRR.LOAN
   
 LEFT OUTER JOIN (SELECT LOAN, INDEX_TYPE, MARGIN, LIFE_CAP, LIFE_FLOOR, INT_CH_RATE
                 FROM   MAS3_CD   MAS3_CD
                 WHERE  MAS3_CD.HISTORY  = 'L' AND MAS3_CD.ITEM = 'zzz' AND MAS3_CD.STATUS = '1'
                 ) MAS3 ON SCM7.LOAN = MAS3.LOAN
       
 LEFT OUTER JOIN (SELECT LOAN, PRIOR_SERVICER_NUM
                 FROM   LOAN_INFO
                 ) loaninfo ON SCM7.LOAN = loaninfo.LOAN
                 
 LEFT OUTER JOIN(SELECT RLSM.LOAN
                      ,RLSM.LOAN_BALANCE AS PREV_MONTH_BALANCE
                FROM REVLOANSERVICINGMONTH   RLSM 
                WHERE RLSM.RECORD_DATE = (SELECT TO_DATE(LAST_DAY(ADD_MONTHS(?,-1)),'DD-MON-YY')+1 AS CurrentMonthFirstDay FROM dual)
                ) PREVMONTHBALANCE ON SCM7.LOAN = PREVMONTHBALANCE.LOAN
 
 where 
 
  revchange.rn='1' AND
  SCM7.HISTORY  = 'L' AND 
  SCM7.ITEM = 'zzz' AND 
  SCM7.STATUS = '1' AND
  SCM7.INVESTOR_CODE = ?