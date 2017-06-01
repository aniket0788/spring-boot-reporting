/*********************************************************************************************************************** 
                                      MECA-2011 RM_TXNS_<SERVICER#>_<YYYYMM>_V<N> REPORT
***********************************************************************************************************************/
--SET DEFINE ON

--DEFINE POOL_NAME  = "'FNMA00000'"
--DEFINE START_DATE = "'01-APR-17'"
--DEFINE END_DATE   = "'30-APR-17'" 

/******* GETTING UNSCHEDULED PAYMENT DATA *****/
SELECT (CASE WHEN RLPS.PAY_TYPE IN ('P01','P02','P03')                                                    THEN '0'
             WHEN RLPS.PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D','45','46'
                                    ,'47','48','49',/*'50','51',*/'90','91','92','93','94','95','96',
                                    '97')                                                            THEN '2'
             WHEN RLPS.PAY_TYPE IN ('P00')                                                                THEN '7'
             --WHEN RLPS.PAY_TYPE IN('00' , '01' , '02','11', '12','13','14', '15','20','50','51','52','53','54','55','56','57','58','70','71','72','73') THEN  '3'
             ELSE NULL
        END)                                                                AS Transaction_Designator,
--RLPS.LOAN                                                                   AS CHAMPION_LOAN_NUMBER,
SCM7.THEIR_LOAN_NO                                                          AS Fannie_Mae_Loan_Number,   
TO_CHAR(RLPS.POST_DATE,'YYYYMM')                                            AS RMSS_Last_Completed_EOM_Period,     
'268800000'                                                                 AS Servicer_Number,
TO_CHAR(RLPS.POST_DATE, 'MM/DD/YYYY')                                       AS Effective_Date,                          --AZ: CHANGE FIELD NAME FROM post_date TO Effective_Date
(CASE WHEN RLPS.AMOUNT IS NULL THEN 0 ELSE RLPS.AMOUNT END)                 AS amount,
/*(CASE WHEN RLPS.AMOUNT IS NULL
      THEN 0 
      ELSE REPLACE(TO_CHAR(RLPS.AMOUNT,'9999999999999999.99'),' ' ,'') 
 END)                                                                       AS amount,*/
(CASE WHEN RLPS.PAY_TYPE IN ('41')                          THEN '41'
      WHEN RLPS.PAY_TYPE IN ('42')                          THEN '42'
      WHEN RLPS.PAY_TYPE IN ('43A','43B')                   THEN '43'
      WHEN RLPS.PAY_TYPE IN ('44','44A','44B','44C','44D')  THEN '44'
      WHEN RLPS.PAY_TYPE IN ('45')                          THEN '45'
      WHEN RLPS.PAY_TYPE IN ('46')                          THEN '46'
      WHEN RLPS.PAY_TYPE IN ('47')                          THEN '47'
      WHEN RLPS.PAY_TYPE IN ('48')                          THEN '48'
      WHEN RLPS.PAY_TYPE IN ('49')                          THEN '49'
      --WHEN RLPS.PAY_TYPE IN('50')                          THEN ''
      --WHEN RLPS.PAY_TYPE IN('51')                          THEN ''
      WHEN RLPS.PAY_TYPE IN ('40','90')                     THEN '90'
      WHEN RLPS.PAY_TYPE IN ('91')                          THEN '91'
      WHEN RLPS.PAY_TYPE IN ('92')                          THEN '92'
      WHEN RLPS.PAY_TYPE IN ('93')                          THEN '93'
      WHEN RLPS.PAY_TYPE IN ('94','96')                     THEN '94'
      WHEN RLPS.PAY_TYPE IN ('95','99')                     THEN '95'
      WHEN RLPS.PAY_TYPE IN ('P01')                         THEN '102'
      WHEN RLPS.PAY_TYPE IN ('P02')                         THEN '100'
      WHEN RLPS.PAY_TYPE IN ('P03')                         THEN '110'
      WHEN RLPS.PAY_TYPE IN ('P00')                         THEN '103'
      --WHEN RLPS.PAY_TYPE IN( 'M00' )  THEN ''
      --WHEN RLPS.PAY_TYPE IN( 'M01' )  THEN ''
      --WHEN RLPS.PAY_TYPE IN( 'M02' )  THEN ''
      --WHEN RLPS.PAY_TYPE IN( 'M03' )  THEN ''
      ELSE NULL
    END)                                                                    AS action_code
FROM  REVLOANPAYMENTS     RLPS
INNER JOIN SCM7_CD        SCM7 ON RLPS.LOAN = SCM7.LOAN
AND   RLPS.HISTORY = 'L' AND RLPS.ITEM = 'zzz' AND RLPS.STATUS = '1'  
--AND   PAY_TYPE NOT IN ('50','51','M00','M01','M02','M03')
AND   RLPS.PAY_TYPE IN ('40','41','42','43A','43B','44','44A','44B','44C','44D','45','46','47','48','49',/*'50','51',*/
                        '90','91','92','93','94','95','96','97','99','P00','P01','P02','P03')
AND   RLPS.POST_DATE BETWEEN ? AND ?
AND   SCM7.INVESTOR_CODE = ?
--AND   RLPS.post_date BETWEEN ? AND ?
--AND   SCM7.investor_code = ?

UNION ALL

/******* GETTING PRE-PAYMENT DATA *****/
SELECT (CASE WHEN RLPPS.PREPAY_TYPE IN ('31','32','33','34','34A','34B','34C','35')                       THEN '6'
             WHEN RLPPS.PREPAY_TYPE IN ('80','80A','80B','80C','80D','80E','81','82','83','84') THEN '1'
             ELSE NULL
        END)                                                                AS Transaction_Designator,
--RLPPS.LOAN                                                                  AS CHAMPION_LOAN_NUMBER,
SCM7.THEIR_LOAN_NO                                                          AS Fannie_Mae_Loan_Number,    
TO_CHAR(RLPPS.POST_DATE,'YYYYMM')                                           AS RMSS_Last_Completed_EOM_Period,     
'268800000'                                                                 AS Servicer_Number,
TO_CHAR(RLPPS.POST_DATE, 'MM/DD/YYYY')                                      AS Effective_Date,
(CASE WHEN RLPPS.AMOUNT IS NULL THEN 0 ELSE RLPPS.AMOUNT*-1 END)            AS amount,
(CASE WHEN RLPPS.action_code IN ('31')              THEN '31'
      WHEN RLPPS.action_code IN ('32')              THEN '32'
      WHEN RLPPS.action_code IN ('33')              THEN '33'
      WHEN RLPPS.action_code IN ('34','35')         THEN '35'
      WHEN RLPPS.action_code IN ('80','85','86')    THEN '80'
      WHEN RLPPS.action_code IN ('81')              THEN '81'
      WHEN RLPPS.action_code IN ('82')              THEN '82'
      WHEN RLPPS.action_code IN ('83')              THEN '83'
      WHEN RLPPS.action_code IN ('84')              THEN '84'
      WHEN RLPPS.action_code IN ('34C','80A','80B') THEN '85'
      --WHEN RLPPS.action_code IN ('65')            THEN '65'
      WHEN RLPPS.action_code IN ('80C')             THEN '86'
      WHEN RLPPS.action_code IN ('34A','80D')       THEN '87'  
      WHEN RLPPS.action_code IN ('34B','80E')       THEN '88'
      ELSE NULL
    END)                                                                    AS action_code
FROM REVLOANPREPAYMENTS   RLPPS
INNER JOIN SCM7_CD        SCM7  ON RLPPS.LOAN = SCM7.LOAN
WHERE RLPPS.HISTORY = 'L' AND RLPPS.ITEM = 'zzz' AND RLPPS.STATUS = '1'
--AND   RLPPS.PREPAY_TYPE NOT IN ('65','105','105A','105B','105C','105D','108','109','M00','M01','M02','M03')
AND   RLPPS.PREPAY_TYPE IN ('31','32','33','34','34A','34B','34C','35','80','80A','80B','80C','80D','80E','81','82',
                            '83','84','85','86')
AND   RLPPS.POST_DATE BETWEEN ? AND ?
AND   SCM7.INVESTOR_CODE = ?
--AND RLPPS.POST_DATE BETWEEN ? AND ?
--AND SCM7.INVESTOR_CODE = ?

UNION ALL

/******* GETTING STATUS CHANGES DATA *****/
SELECT (CASE WHEN RLS.NEW_LOAN_STATUS IN ('0','01','02','11','12','13','13A','13B','13C','14','14A','15A','15B',
                                          '20','50','51A','51B','51C','51D','51E','52A','52B','53A','53B','53C',
                                          '55','56','57','57A','57B','57C','58','58A','58B','58C','58D','70','71',
                                          '71A','71B','72','73','74')                 THEN '3'
        ELSE NULL
        END)                                                                AS Transaction_Designator,
--RLS.LOAN                                                                    AS CHAMPION_LOAN_NUMBER,
SCM7.THEIR_LOAN_NO                                                          AS Fannie_Mae_Loan_Number,    
TO_CHAR(RLS.POST_DATE,'YYYYMM')                                             AS RMSS_Last_Completed_EOM_Period,     
'268800000'                                                                 AS Servicer_Number,
TO_CHAR(RLS.POST_DATE, 'MM/DD/YYYY')                                        AS Effective_Date,
0                                                                           AS amount,
(CASE WHEN RLS.NEW_LOAN_STATUS IN ('0')                         THEN '0'
      WHEN RLS.NEW_LOAN_STATUS IN ('01')                        THEN '1'
      WHEN RLS.NEW_LOAN_STATUS IN ('02')                        THEN '2'
      WHEN RLS.NEW_LOAN_STATUS IN ('11')                        THEN '11'
      WHEN RLS.NEW_LOAN_STATUS IN ('12')                        THEN '12'
      WHEN RLS.NEW_LOAN_STATUS IN ('13A','13B','13C')           THEN '13'
      WHEN RLS.NEW_LOAN_STATUS IN ('14','14A')                  THEN '14'
      WHEN RLS.NEW_LOAN_STATUS IN ('15A','15B')                 THEN '15'
      WHEN RLS.NEW_LOAN_STATUS IN ('20')                        THEN '20'
      WHEN RLS.NEW_LOAN_STATUS IN ('50')                        THEN '50'
      WHEN RLS.NEW_LOAN_STATUS IN ('51A','51C','51E','51F')     THEN '51'
      WHEN RLS.NEW_LOAN_STATUS IN ('51B','51D','52A','52B')     THEN '52'
      WHEN RLS.NEW_LOAN_STATUS IN ('53A','53B','53C')           THEN '53'
      WHEN RLS.NEW_LOAN_STATUS IN ('55')                        THEN '55'
      WHEN RLS.NEW_LOAN_STATUS IN ('56')                        THEN '56'
      WHEN RLS.NEW_LOAN_STATUS IN ('57A','57B','57C')           THEN '57'
      WHEN RLS.NEW_LOAN_STATUS IN ('58A','58B','58C','58D')     THEN '58'
      WHEN RLS.NEW_LOAN_STATUS IN ('70','74')                   THEN '70'
      WHEN RLS.NEW_LOAN_STATUS IN ('71','71A','71B')            THEN '71'
      WHEN RLS.NEW_LOAN_STATUS IN ('72')                        THEN '72'
      WHEN RLS.NEW_LOAN_STATUS IN ('73')                        THEN '73'
      ELSE NULL
    END)                                                                    AS action_code
FROM REVLOANSTATUS  RLS
INNER JOIN SCM7_CD  SCM7 ON RLS.LOAN = SCM7.LOAN
WHERE RLS.HISTORY = 'L' AND RLS.ITEM = 'zzz' AND RLS.STATUS = '1'
AND   RLS.POST_DATE BETWEEN ? AND ?
AND   SCM7.INVESTOR_CODE = ?
--AND   RLS.NEW_LOAN_STATUS NOT IN ('60','R03')
AND   RLS.NEW_LOAN_STATUS IN ('0','01','02','11','12','13','13A','13B','13C','14','14A','15A','15B','20','50','51A',
                              '51B','51C','51D','51E','52A','52B','53A','53B','53C','55','56','57','57A','57B','57C',
                              '58','58A','58B','58C','58D','70','71','71A','71B','72','73','74')
--AND RLS.POST_DATE BETWEEN ? AND ?
--AND SCM7.INVESTOR_CODE = ?