create or replace PROCEDURE USP_DAILY_DISBURSEMENTS 
(
  START_DT IN VARCHAR2 
, END_DT IN VARCHAR2 
, STATUS OUT VARCHAR2 
) AS 
BEGIN

STATUS := 'failure';

/*********************************************************************************************************************************************
                                                TRUNCATING  TEMP TABLES IF THEY EXISTS
*********************************************************************************************************************************************/
FOR PAYEE_TEMP_TABLE IN (SELECT table_name FROM user_tables WHERE table_name = 'PAYEE_TEMP_TABLE') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE PAYEE_TEMP_TABLE';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR LOAN_POPULATION IN (SELECT table_name FROM user_tables WHERE table_name = 'LOAN_POPULATION') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE LOAN_POPULATION';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR TRANSACTION_INFORMATION IN (SELECT table_name FROM user_tables WHERE table_name = 'TRANSACTION_INFORMATION') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE TRANSACTION_INFORMATION';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR CHECK_TOTAL_RECORD IN (SELECT table_name FROM user_tables WHERE table_name = 'CHECK_TOTAL_RECORD') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE CHECK_TOTAL_RECORD';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR ACH_TOTAL_RECORD IN (SELECT table_name FROM user_tables WHERE table_name = 'ACH_TOTAL_RECORD') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE ACH_TOTAL_RECORD';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR CHECK_FILE_DATA IN (SELECT table_name FROM user_tables WHERE table_name = 'CHECK_FILE_DATA') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE CHECK_FILE_DATA';
END LOOP;
------------------------------------------------------------------------------------------------------------------------
FOR NACHA_FILE_DATA IN (SELECT table_name FROM user_tables WHERE table_name = 'NACHA_FILE_DATA') LOOP
EXECUTE IMMEDIATE 'TRUNCATE TABLE NACHA_FILE_DATA';
END LOOP;

/*********************************************************************************************************************************************
                                  TRUNCATING DATA IN CASE DISBURSEMENT'S RECORDS IS RE-RUN ON THE SAME DAY
*********************************************************************************************************************************************/

/*** DELETING RECORDS FROM DAILY_DISBURSEMENTS TABLE ***/
DELETE DAILY_DISBURSEMENTS WHERE PROCESS_DATE = (SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL);

/*** DELETING RECORDS FROM CHECK_NBR_TRACKING TABLE ***/
DELETE CHECK_NBR_TRACKING WHERE ASSIGNED_DATE = (SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL);

/*** DELETING RECORDS FROM ACH_NBR_TRACKING TABLE ***/
DELETE ACH_NBR_TRACKING WHERE ASSIGNED_DATE = (SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL);

/*********************************************************************************************************************************************
                                                          DETERMINE BORROWER(S) NAMES
*********************************************************************************************************************************************/
INSERT INTO PAYEE_TEMP_TABLE (LOAN,PAYEE,BORR_NAME1)
SELECT PAYEENAME.LOAN
      ,SUBSTR(CASE WHEN PAYEENAME.BORR_NAME2 IS NULL           THEN PAYEENAME.BORR_NAME1
                     WHEN LENGTH(PAYEENAME.BORR_NAME1) <= '31' THEN RPAD(PAYEENAME.BORR_NAME1 ||' '|| ANDWORD,35,' ') || ' ' || PAYEENAME.BORR_NAME2 
                     WHEN LENGTH(PAYEENAME.BORR_NAME1) >= '31' THEN RPAD(PAYEENAME.BORR_NAME1,35,' ') ||''|| ANDWORD ||' '|| PAYEENAME.BORR_NAME1
                     ELSE PAYEENAME.BORR_NAME2 END,1,75) AS PAYEE
      ,PAYEENAME.BORR_NAME1
FROM (SELECT BRW1_CD.LOAN
            ,FIRST_NAME || ' ' || LAST_NAME AS BORR_NAME1
            ,'and'                          AS ANDWORD
            ,COBORR.BORR_NAME2
            ,BRW1_CD.BRWR_NO
            ,REVBRWRSERVICING.DATE_OF_DEATH
            ,ROW_NUMBER () OVER (PARTITION BY BRW1_CD.LOAN ORDER BY BRW1_CD.BRWR_NO) rn
      FROM BRW1_CD
      LEFT OUTER JOIN REVBRWRSERVICING ON BRW1_CD.LOAN = REVBRWRSERVICING.LOAN AND BRW1_CD.BRWR_NO = REVBRWRSERVICING.BRWR_NO
      LEFT OUTER JOIN (SELECT BRW1_CD.LOAN
                             ,CASE WHEN FIRST_NAME IS NULL THEN '' ELSE FIRST_NAME || ' ' || LAST_NAME END AS BORR_NAME2
                             ,BRW1_CD.BRWR_NO
                             ,REVBRWRSERVICING.DATE_OF_DEATH
                       FROM BRW1_CD
                       LEFT OUTER JOIN REVBRWRSERVICING ON BRW1_CD.LOAN = REVBRWRSERVICING.LOAN AND BRW1_CD.BRWR_NO = REVBRWRSERVICING.BRWR_NO
                       WHERE REVBRWRSERVICING.DATE_OF_DEATH IS NULL
                       AND BRW1_CD.BRWR_NO > '01'
                       AND BRW1_CD.BRWR_STATUS = '1' 
                       ORDER BY BRW1_CD.LOAN,BRW1_CD.BRWR_NO) COBORR ON BRW1_CD.LOAN = COBORR.LOAN --AND BRW1_CD.BRWR_NO = COBORR.BRWR_NO
      WHERE REVBRWRSERVICING.DATE_OF_DEATH IS NULL
      AND BRW1_CD.BRWR_STATUS = '1'
      ORDER BY BRW1_CD.LOAN,BRW1_CD.BRWR_NO) PAYEENAME
WHERE PAYEENAME.RN = '1';

/*********************************************************************************************************************************************
                                                GATHERING LOAN POPULATION FROM PAYMENTS  ADV TABLES
*********************************************************************************************************************************************/
INSERT INTO LOAN_POPULATION
SELECT LOAN
      ,IDX
      ,STATUS
      ,PAY_TYPE
      ,TRAN_DATE
      ,POST_DATE
      ,AMOUNT
      ,PMNT_METHOD
      ,MAILTO_STREET
      ,MAILTO_CITY
      ,MAILTO_STATE
      ,MAILTO_ZIP
      ,DEPOSIT_BANK_NAME
      ,DEPOSIT_BANK_ACNT_NO
      ,DEPOSIT_BANK_ROUT_NO
      ,CAST(NULL AS VARCHAR(2))         AS DEPOSIT_BANK_ACNT_TYPE
      ,PAY_TO
      ,VENDOR_CODE                      --ADDED AS PER PBI 31706
--      ,VENDOR_NAME                    --INCLUDED AS PART OF PBI 39997 /*NEED TO UN-COMMENT THIS PART*/
      ,INVOICE_NO
FROM REVLOANPAYMENTS
WHERE PAY_TYPE IN ('44','90','91','92','93','94','95','96','P00'/*,'40'*//*,'41'*//*,'42','43A','43B','44A','44B','44C','44D'*//*,'45'*//*,'46','47','48','49'*/) --EXCLUDED 40's TRANS  90, 91, 96 TRANS AS PER PBI 42389 
AND STATUS = '1'
AND PMNT_METHOD IN('MC','DD')
AND TO_CHAR(POST_DATE,'YYYY-MM-DD') BETWEEN START_DT AND END_DT

UNION ALL

SELECT LOAN
      ,IDX
      ,STATUS
      ,CORP_ADV_TYPE
      ,CORP_ADV_DATE AS CORP_ADV_CRT_DT
      ,CORP_ADV_DATE AS CORP_ADV_POST_DT
      ,AMOUNT
      ,'MC'                             AS PMNT_METHOD
      ,VENDOR_PAYMENT_INFO.ADDRESS1     AS MAILTO_STREET
      ,VENDOR_PAYMENT_INFO.CITY         AS MAILTO_CITY
      ,VENDOR_PAYMENT_INFO.STATE        AS MAILTO_STATE
      ,VENDOR_PAYMENT_INFO.ZIP          AS MAILTO_ZIP
      ,VENDOR_PAYMENT_INFO.BANK_NAME    AS DEPOSIT_BANK_NAME
      ,VENDOR_PAYMENT_INFO.ACCOUNT_NBR  AS DEPOSIT_BANK_ACNT_NO
      ,VENDOR_PAYMENT_INFO.ROUTING_NBR  AS DEPOSIT_BANK_ROUT_NO
      ,CAST(NULL AS VARCHAR(3))         AS DEPOSIT_BANK_ACNT_TYPE
      ,PAYABLE_TO
      ,CAST(NULL AS VARCHAR(8))         AS VENDOR_CODE              --ADDED AS PER PBI 31706
--      ,CAST(NULL AS VARCHAR(55))        AS VENDOR_NAME            --ADDED AS PER PBI 39997 /*NEED TO UN-COMMENT THIS PART*/
      ,NOTE
FROM REVLOANCORPADV
LEFT OUTER JOIN VENDOR_PAYMENT_INFO ON REVLOANCORPADV.PAYABLE_TO = VENDOR_PAYMENT_INFO.VENDOR_CODE
WHERE STATUS = '1'
AND CORP_ADV_TYPE != 'NEGLOC'   /*THIS PIECE WILL ALLOW US TO OMIT THE CORP ADV CREATED WHEN A 90'S TRAN IS INTRODUCED AND THE LOC IS NOT ENOUGH TO COVER THE AMT*/
AND TO_CHAR(CORP_ADV_DATE,'YYYY-MM-DD') BETWEEN START_DT AND END_DT;


/*********************************************************************************************************************************************
                                                          CREATING TRANSACTION_INFORMATION TABLE
*********************************************************************************************************************************************/
INSERT INTO TRANSACTION_INFORMATION
SELECT 
  (SELECT TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD')FROM DUAL)                                     AS PROCESS_DATE
  ,'Y'                                                                                      AS RECORD_INCLUDED
  ,'I'                                                                                      AS RECORD_TYPE
  ,LOAN_POPULATION.LOAN
  ,LOAN_POPULATION.IDX
  ,LOAN_POPULATION.STATUS
  ,PAY_TYPE
  ,CASE --WHEN PAY_TYPE = '40'   THEN '40 - Tax payment'                                                  --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '41'   THEN '41 - Repairs set-aside (not final payment)'                        --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '42'   THEN '42 - First-year property charges set-aside (not final payment)'    --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '43A'  THEN '43A - Unscheduled taxes  set-aside'                                --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '43B'  THEN '43B - Unscheduled insurance set-aside'                             --EXCLUDED AS PER PBI 42389
        WHEN PAY_TYPE = '44'     THEN '44 - Net line of credit set-aside'
        --WHEN PAY_TYPE = '44A'  THEN '44A - Net line of credit  repair (not final payment)'              --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '44B'  THEN '44B - Net line of credit repair (Final Payment)'                   --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '44C'  THEN '44C - Net line of credit Tax  set-aside'                           --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '44D'  THEN '44D - Net line of credit Insurance set-aside'                      --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '45'   THEN '45 - Repair set-aside (final payment)'                             --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '46'   THEN '46 - First-year property charges set-aside (final payment)'        --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '47'   THEN '47 - Appraisal fee set-aside'                                      --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '48'   THEN '48 - Tax payment from line of credit'                              --EXCLUDED AS PER PBI 42389
        --WHEN PAY_TYPE = '49'   THEN '49 - Payment Plan Change Fee'                                      --EXCLUDED AS PER PBI 42389
        WHEN PAY_TYPE = '90'     THEN '90 - Force Tax Payment'                                            --ADDED AS PER PBI 42389
        WHEN PAY_TYPE = '91'     THEN '91 - Force Insurance Payment'                                      --ADDED AS PER PBI 42389
        WHEN PAY_TYPE = '92'     THEN '92 - Corp. Adv. Inspection Payment'
        WHEN PAY_TYPE = '93'     THEN '93 - Corp. Adv. Appraisal Payment'
        WHEN PAY_TYPE = '94'     THEN '94 - Corp. Adv. Property Preservations Payment'
        WHEN PAY_TYPE = '95'     THEN '95 - Corp. Adv. Attorney Fees/Costs Payment'
        WHEN PAY_TYPE = '96'     THEN '96 - Corp. Adv. Delinquent HOA Dues Payment'                       --ADDED AS PER PBI 42389
        WHEN PAY_TYPE = 'P00'    THEN 'P00 - Monthly Scheduled Payment'
        WHEN PAY_TYPE = 'PRPTAX' THEN 'PRPTAX - Property Tax'
        WHEN PAY_TYPE = 'FORCLS' THEN 'FORCLS - Foreclosure Expenses'
        WHEN PAY_TYPE = 'PROPIN' THEN 'PROPIN - Property Investigation '
        WHEN PAY_TYPE = 'MISCEL' THEN 'MISCEL - Miscellaneous'
        WHEN PAY_TYPE = 'ATTFEE' THEN 'ATTFEE - Attorney Fees'
        WHEN PAY_TYPE = 'LGLFEE' THEN 'LGLFEE - Legal Fees'
--        WHEN PAY_TYPE = 'NEGLOC' THEN 'NEGLOC - Negative LOC Payment'                                   --EXCLUDED AS PER DEV INITIATIVE
        WHEN PAY_TYPE = 'FRCPLC' THEN 'FRCPLC - Force Place Insurance'
        WHEN PAY_TYPE = 'HAZINS' THEN 'HAZINS - Hazard Insurance'
        WHEN PAY_TYPE = 'APPDIL' THEN 'APPDIL - Appraisal DIL'
        WHEN PAY_TYPE = 'APPFCL' THEN 'APPFCL - Appraisal FCL'
        WHEN PAY_TYPE = 'APPSHS' THEN 'APPSHS - Appraisal Short Sale'
        WHEN PAY_TYPE = 'ATTCST' THEN 'ATTCST - Attorney Costs'
        ELSE '' END                                                                           AS PAY_TYPE_DESC
  ,TO_CHAR(TO_DATE(TRAN_DATE),'YYYY-MM-DD')                                                   AS TRAN_CRT_DATE
  ,TO_CHAR(TO_DATE(POST_DATE),'YYYY-MM-DD')                                                   AS TRAN_POST_DATE
  ,AMOUNT                                                                                     AS AMOUNT
  ,LOAN_POPULATION.PMNT_METHOD                                                                AS PMNT_METHOD  
  ,CASE WHEN LOAN_POPULATION.PMNT_METHOD = 'MC' 
        THEN 'CHECK' ELSE 'ACH' END                                                           AS DISBURSED_TYPE
  ,CAST(NULL AS VARCHAR2(12))                                                                 AS CHECK_NUMBER
  ,CAST(NULL AS VARCHAR2(12))                                                                 AS ACH_NUMBER
  ,CASE WHEN PAY_TYPE IN ('44','P00') THEN PAYEE_TEMP_TABLE.PAYEE
--        WHEN PAY_TYPE IN ('41','45')  THEN PAYEE_TEMP_TABLE.PAYEE ||''|| VENDOR_NAME            --INCLUDED AS PART OF PBI 39997 /*JUST NEED TO UN-COMMENT THIS PART WHEN 39997 IS APPROVED*/
        ELSE VENDOR_PAYMENT_INFO.NAME1 ||''|| VENDOR_PAYMENT_INFO.NAME2 
   END                                                                                        AS PAYEE_NAME
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN MAILTO_STREET
        ELSE VENDOR_PAYMENT_INFO.ADDRESS1 
   END                                                                                        AS PAYEE_STREET
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN MAILTO_CITY
        ELSE VENDOR_PAYMENT_INFO.CITY 
   END                                                                                        AS PAYEE_TOWN
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN MAILTO_STATE
        ELSE VENDOR_PAYMENT_INFO.STATE 
   END                                                                                        AS PAYEE_STATE
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN MAILTO_ZIP
        ELSE VENDOR_PAYMENT_INFO.ZIP 
   END                                                                                        AS PAYEE_ZIP
  ,LOAN_POPULATION.DEPOSIT_BANK_NAME                                                          AS DEPOSIT_BANK_NAME
  ,LOAN_POPULATION.DEPOSIT_BANK_ACNT_NO                                                       AS DEPOSIT_BANK_ACNT_NO
  ,LOAN_POPULATION.DEPOSIT_BANK_ROUT_NO                                                       AS DEPOSIT_BANK_ROUT_NO
/*  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN LOAN_POPULATION.DEPOSIT_BANK_NAME
        ELSE VENDOR_PAYMENT_INFO.BANK_NAME 
   END                                                                    AS DEPOSIT_BANK_NAME
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN LOAN_POPULATION.DEPOSIT_BANK_ACNT_NO
        ELSE VENDOR_PAYMENT_INFO.ACCOUNT_NBR 
   END                                                                    AS DEPOSIT_BANK_ACNT_NO
  ,CASE WHEN PAY_TYPE IN ('44','P00') 
        THEN LOAN_POPULATION.DEPOSIT_BANK_ROUT_NO
        ELSE VENDOR_PAYMENT_INFO.ROUTING_NBR 
   END                                                                    AS DEPOSIT_BANK_ROUT_NO       -- ONCE THE BUSINESS DETERMINES TO ACH MONEY TO VENDORS THE FIELDS ON THE TOP WILL NEED TO BE DELETED AND THESE ONES ACTIVATED
*/  
  ,CASE WHEN REVLOANSERVICING.DEPOSIT_BANK_ACNT_TYPE = 'SAV' THEN '32'
        WHEN REVLOANSERVICING.DEPOSIT_BANK_ACNT_TYPE = 'CHA' THEN '22'
        ELSE CAST(NULL AS VARCHAR2(2)) 
   END                                                                    AS ACCT_TYPE
  ,INVOICE_NO                                                             AS INVOICE_NO
  ,CAST(NULL AS VARCHAR2(10))                                             AS CHECK_GROUP_NBR
  ,CAST(NULL AS VARCHAR2(10))                                             AS ACH_GROUP_NBR
FROM LOAN_POPULATION
LEFT OUTER JOIN PAYEE_TEMP_TABLE    ON LOAN_POPULATION.LOAN = PAYEE_TEMP_TABLE.LOAN
LEFT OUTER JOIN VENDOR_PAYMENT_INFO ON LOAN_POPULATION.PAY_TO = VENDOR_PAYMENT_INFO.VENDOR_CODE         --NEED TO DELETE THIS LINE WHEN PBI 31706 IS COMPLETED
LEFT OUTER JOIN REVLOANSERVICING    ON LOAN_POPULATION.LOAN = REVLOANSERVICING.LOAN AND LOAN_POPULATION.DEPOSIT_BANK_ACNT_NO = REVLOANSERVICING.DEPOSIT_BANK_ACNT_NO;
--LEFT OUTER JOIN VENDOR_PAYMENT_INFO ON LOAN_POPULATION.VENDOR_CODE = VENDOR_PAYMENT_INFO.VENDOR_CODE  --NEED TO UN-COMMENT THIS OUT WHEN PBI 31706 IS COMPLETED

/*********************************************************************************************************************************************
                                                          FLAGGING RECORDS TO EXCLUDE FROM CHECK_FILE
*********************************************************************************************************************************************/
UPDATE TRANSACTION_INFORMATION
SET
RECORD_INCLUDED = 'N'
WHERE (PMNT_METHOD = 'MC' AND (PAYEE_NAME   IS NULL
OR     PAYEE_STREET IS NULL
OR     PAYEE_TOWN   IS NULL
OR     PAYEE_STATE  IS NULL 
OR     PAYEE_ZIP    IS NULL))
OR
(PMNT_METHOD = 'DD' AND (PAYEE_NAME   IS NULL
OR     DEPOSIT_BANK_ACNT_NO IS NULL
OR     DEPOSIT_BANK_ROUT_NO IS NULL
OR     ACCT_TYPE            IS NULL
));

/*********************************************************************************************************************************************
                                                    CREATING TOTAL RECORDS FOR CHECK PAYMENTS
*********************************************************************************************************************************************/
INSERT INTO CHECK_TOTAL_RECORD 
SELECT DISTINCT PROCESS_DATE
      ,RECORD_INCLUDED
      ,'T'                                                                      AS RECORD_TYPE
      ,LOAN
      ,CAST(NULL AS VARCHAR2(12))                                               AS IDX
      ,CAST(NULL AS VARCHAR2(1))                                                AS STATUS
      ,CAST(NULL AS VARCHAR2(6))                                                AS PAY_TYPE
      ,CAST(NULL AS VARCHAR2(90))                                               AS PAY_TYPE_DESC
      ,CAST(NULL AS VARCHAR2(10))                                               AS TRAN_CRT_DATE
      ,CAST(NULL AS VARCHAR2(10))                                               AS TRAN_POST_DATE
      ,SUM(AMOUNT)                                                              AS AMOUNT
      ,PMNT_METHOD  
      ,DISBURSED_TYPE
      ,CHECK_NUMBER
      ,CAST(NULL AS VARCHAR2(12))                                               AS ACH_NUMBER
      ,PAYEE_NAME
      ,PAYEE_STREET
      ,PAYEE_TOWN
      ,PAYEE_STATE
      ,PAYEE_ZIP
      ,CAST(NULL AS VARCHAR2(50))                                               AS DEPOSIT_BANK_NAME
      ,CAST(NULL AS VARCHAR2(17))                                               AS DEPOSIT_BANK_ACNT_NO
      ,CAST(NULL AS VARCHAR2(9))                                                AS DEPOSIT_BANK_ROUT_NO
      ,CAST(NULL AS VARCHAR2(2))                                                AS ACCT_TYPE
      ,INVOICE_NO
      ,ROW_NUMBER () OVER (PARTITION BY PROCESS_DATE ORDER BY LOAN)             AS CHECK_GROUP_NBR
      ,CAST(NULL AS VARCHAR2(10))                                               AS ACH_GROUP_NBR
FROM TRANSACTION_INFORMATION
WHERE RECORD_INCLUDED = 'Y'
AND PMNT_METHOD = 'MC'
GROUP BY PROCESS_DATE,LOAN,PMNT_METHOD,DISBURSED_TYPE,CHECK_NUMBER,PAYEE_NAME,PAYEE_STREET,PAYEE_TOWN,PAYEE_STATE
,PAYEE_ZIP,INVOICE_NO,RECORD_INCLUDED,CHECK_GROUP_NBR
ORDER BY LOAN;

/*********************************************************************************************************************************************
                                    ASSIGNING CHECK_NUMBER IN THE CHECK_TOTAL_RECORD WITH 
*********************************************************************************************************************************************/
UPDATE CHECK_TOTAL_RECORD
SET CHECK_NUMBER      = LPAD((SELECT SUM(CHECK_TABLE.CHECK_NBR + CHECK_GROUP_NBR) AS CHECK_NBR
                              FROM (SELECT MAX(CHECK_NBR) AS CHECK_NBR
                                    FROM CHECK_NBR_TRACKING
                                    WHERE CHECK_NBR_ASSINGED = 'Y'
                                    ) CHECK_TABLE
                              WHERE PMNT_METHOD = 'MC'
                              GROUP BY PAYEE_NAME
                              ),10,'0');

/*********************************************************************************************************************************************
                            UPDATING THE CHECK_NBR_TRACKING TABLE WITH CHECK NUMBERS ASSIGNED AS PER THE CURRENT RUN
*********************************************************************************************************************************************/
INSERT INTO CHECK_NBR_TRACKING
(CHECK_NBR, CHECK_NBR_ASSINGED,ASSIGNED_DATE)
SELECT CHECK_TOTAL_RECORD.CHECK_NUMBER
       ,'Y'
       ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM CHECK_TOTAL_RECORD
WHERE CHECK_NUMBER NOT IN (SELECT CHECK_NBR FROM CHECK_NBR_TRACKING)
AND CHECK_TOTAL_RECORD.PMNT_METHOD = 'MC';

/*********************************************************************************************************************************************
                                      INSERT TOTAL CHECK RECORDS INTO THE TRANSACTION_INFORMATION TABLE
*********************************************************************************************************************************************/
INSERT INTO TRANSACTION_INFORMATION
SELECT *
FROM CHECK_TOTAL_RECORD;

/*********************************************************************************************************************************************
                    UPDATING THE TRANSACTION_INFORMATION TABLE WITH CHECK_NUMBER FOR EACH INDIVIDAUL TRANSACTION
*********************************************************************************************************************************************/
UPDATE  TRANSACTION_INFORMATION
SET CHECK_NUMBER      = (SELECT DISTINCT CHECK_TOTAL_RECORD.CHECK_NUMBER
                         FROM CHECK_TOTAL_RECORD
                         WHERE CHECK_TOTAL_RECORD.LOAN        IN TRANSACTION_INFORMATION.LOAN
                         AND CHECK_TOTAL_RECORD.PAYEE_NAME    IN TRANSACTION_INFORMATION.PAYEE_NAME
                         AND CHECK_TOTAL_RECORD.PAYEE_STREET  IN TRANSACTION_INFORMATION.PAYEE_STREET
                         AND CHECK_TOTAL_RECORD.PAYEE_STATE   IN TRANSACTION_INFORMATION.PAYEE_STATE
                         AND CHECK_TOTAL_RECORD.PAYEE_TOWN    IN TRANSACTION_INFORMATION.PAYEE_TOWN
                         AND CHECK_TOTAL_RECORD.PAYEE_ZIP     IN TRANSACTION_INFORMATION.PAYEE_ZIP
                         AND CHECK_TOTAL_RECORD.PMNT_METHOD = 'MC')
WHERE TRANSACTION_INFORMATION.CHECK_NUMBER IS NULL
AND TRANSACTION_INFORMATION.RECORD_INCLUDED IN ('Y')
AND TRANSACTION_INFORMATION.RECORD_TYPE IN ('I')
AND TRANSACTION_INFORMATION.PMNT_METHOD IN ('MC')
AND TRANSACTION_INFORMATION.LOAN IN (SELECT DISTINCT LOAN FROM CHECK_TOTAL_RECORD);

/*********************************************************************************************************************************************
                                                    CREATING TOTAL RECORDS FOR ACH PAYMENTS
*********************************************************************************************************************************************/
INSERT INTO ACH_TOTAL_RECORD
SELECT DISTINCT PROCESS_DATE
      ,RECORD_INCLUDED
      ,'T'                                                                    AS RECORD_TYPE
      ,LOAN
      ,CAST(NULL AS VARCHAR2(12))                                             AS IDX
      ,CAST(NULL AS VARCHAR2(1))                                              AS STATUS
      ,CAST(NULL AS VARCHAR2(6))                                              AS PAY_TYPE
      ,CAST(NULL AS VARCHAR2(90))                                             AS PAY_TYPE_DESC
      ,CAST(NULL AS VARCHAR2(10))                                             AS TRAN_CRT_DATE
      ,CAST(NULL AS VARCHAR2(10))                                             AS TRAN_POST_DATE
      ,SUM(AMOUNT)                                                            AS AMOUNT
      ,PMNT_METHOD  
      ,DISBURSED_TYPE
      ,CAST(NULL AS VARCHAR2(12))                                             AS CHECK_NUMBER
      ,ACH_NUMBER
      ,PAYEE_NAME
      ,CAST(NULL AS VARCHAR2(70))                                             AS PAYEE_STREET
      ,CAST(NULL AS VARCHAR2(35))                                             AS PAYEE_TOWN
      ,CAST(NULL AS VARCHAR2(2))                                              AS PAYEE_STATE
      ,CAST(NULL AS VARCHAR2(9))                                              AS PAYEE_ZIP
      ,DEPOSIT_BANK_NAME
      ,DEPOSIT_BANK_ACNT_NO
      ,DEPOSIT_BANK_ROUT_NO
      ,ACCT_TYPE
      ,INVOICE_NO
      ,CAST(NULL AS VARCHAR2(10))                                             AS CHECK_GROUP_NBR
      ,ROW_NUMBER () OVER (PARTITION BY PROCESS_DATE ORDER BY LOAN)           AS ACH_GROUP_NBR
FROM TRANSACTION_INFORMATION
WHERE RECORD_INCLUDED = 'Y'
AND PMNT_METHOD = 'DD'
GROUP BY PROCESS_DATE,LOAN,PMNT_METHOD,DISBURSED_TYPE,PAYEE_NAME,DEPOSIT_BANK_NAME,DEPOSIT_BANK_ACNT_NO
,DEPOSIT_BANK_ROUT_NO,ACCT_TYPE,INVOICE_NO,RECORD_INCLUDED,CHECK_GROUP_NBR,ACH_NUMBER
ORDER BY LOAN;

/*********************************************************************************************************************************************
                                    ASSIGNING CHECK_NUMBER IN THE ACH_TOTAL_RECORD WITH 
*********************************************************************************************************************************************/
UPDATE ACH_TOTAL_RECORD
SET ACH_NUMBER        = LPAD((SELECT SUM(ACH_TABLE.ACH_NBR + ACH_GROUP_NBR) AS ACH_NUMBER
                              FROM (SELECT MAX(ACH_NBR) AS ACH_NBR
                                    FROM ACH_NBR_TRACKING
                                    WHERE ACH_NBR_ASSINGED = 'Y'
                                    ) ACH_TABLE
                              WHERE PMNT_METHOD = 'DD'
                              GROUP BY PAYEE_NAME
                              ),10,'0');

/*********************************************************************************************************************************************
                            UPDATING THE ACH_NBR_TRACKING TABLE WITH ACH_NUMBERS ASSIGNED AS PER THE CURRENT RUN
*********************************************************************************************************************************************/
INSERT INTO ACH_NBR_TRACKING
(ACH_NBR, ACH_NBR_ASSINGED,ASSIGNED_DATE)
SELECT ACH_TOTAL_RECORD.ACH_NUMBER
       ,'Y'
       ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM ACH_TOTAL_RECORD
WHERE ACH_NUMBER NOT IN (SELECT ACH_NBR FROM ACH_NBR_TRACKING)
AND ACH_TOTAL_RECORD.PMNT_METHOD = 'DD';

/*********************************************************************************************************************************************
                                      INSERT TOTAL CHECK RECORDS INTO THE TRANSACTION_INFORMATION TABLE
*********************************************************************************************************************************************/
INSERT INTO TRANSACTION_INFORMATION
SELECT *
FROM ACH_TOTAL_RECORD;

/*********************************************************************************************************************************************
                    UPDATING THE TRANSACTION_INFORMATION TABLE WITH ACH_NUMBER FOR EACH INDIVIDAUL TRANSACTION
*********************************************************************************************************************************************/
UPDATE  TRANSACTION_INFORMATION
SET ACH_NUMBER = (SELECT DISTINCT ACH_TOTAL_RECORD.ACH_NUMBER
                  FROM ACH_TOTAL_RECORD
                  WHERE ACH_TOTAL_RECORD.LOAN                IN TRANSACTION_INFORMATION.LOAN
                  AND ACH_TOTAL_RECORD.PAYEE_NAME            IN TRANSACTION_INFORMATION.PAYEE_NAME
                  AND ACH_TOTAL_RECORD.DEPOSIT_BANK_NAME     IN TRANSACTION_INFORMATION.DEPOSIT_BANK_NAME
                  AND ACH_TOTAL_RECORD.DEPOSIT_BANK_ACNT_NO  IN TRANSACTION_INFORMATION.DEPOSIT_BANK_ACNT_NO
                  AND ACH_TOTAL_RECORD.DEPOSIT_BANK_ROUT_NO  IN TRANSACTION_INFORMATION.DEPOSIT_BANK_ROUT_NO
                  AND ACH_TOTAL_RECORD.ACCT_TYPE             IN TRANSACTION_INFORMATION.ACCT_TYPE
                  AND ACH_TOTAL_RECORD.PMNT_METHOD = 'DD')
WHERE TRANSACTION_INFORMATION.CHECK_NUMBER IS NULL
AND TRANSACTION_INFORMATION.RECORD_INCLUDED IN ('Y')
AND TRANSACTION_INFORMATION.RECORD_TYPE IN ('I')
AND TRANSACTION_INFORMATION.PMNT_METHOD IN ('DD')
AND TRANSACTION_INFORMATION.LOAN IN (SELECT DISTINCT LOAN FROM ACH_TOTAL_RECORD);

/*********************************************************************************************************************************************
                                                          CREATING CHECK DATA TABLE
*********************************************************************************************************************************************/
INSERT INTO  CHECK_FILE_DATA
SELECT 
 PROCESS_DATE
,RECORD_INCLUDED
,RECORD_TYPE
,LOAN
,IDX
,STATUS
,PAY_TYPE
,PAY_TYPE_DESC
,TRAN_CRT_DATE
,TRAN_POST_DATE
,AMOUNT                                                                 AS FINAL_AMOUNT
,PMNT_METHOD
,DEPOSIT_BANK_NAME
,ACH_NUMBER
--------------------------------------------------- CHECK INFO FIELDS --------------------------------------------------
,(SELECT SYS_GUID() FROM DUAL)                                          AS CLIENT_ID
,CHECK_NUMBER                                                           AS CLIENT_TRANS_REF_NBR
,DISBURSED_TYPE                                                         AS TRANSACTION_TYPE
------------------------------------------------------------------------------------------------------------------------ 
,CAST(AMOUNT AS VARCHAR2(18))                                           AS AMOUNT
,(SELECT TO_CHAR(CURRENT_DATE+1, 'YYYY-MM-DD') FROM DUAL)               AS CHECK_DATE
,CHECK_NUMBER
,PAYEE_NAME
,PAYEE_STREET
,PAYEE_TOWN
,PAYEE_STATE
,PAYEE_ZIP
,CAST(NULL AS VARCHAR2(35))                                             AS CH_REMITTANCE_INFO
---------------------------------------------- PAYMENT STUB FIELDS -----------------------------------------------------
,TRAN_POST_DATE                                                         AS DOCUMENT_DATE
,SUBSTR(INVOICE_NO,1,25)                                                AS INVOICE_NO
,CASE WHEN PAY_TYPE IN ('44','P00') THEN CAST(NULL AS VARCHAR2(12))
      ELSE LOAN 
 END                                                                    AS REMITTANCE_INFO
,CASE WHEN RECORD_TYPE = 'I' THEN CAST(AMOUNT AS VARCHAR2(18))
      ELSE CAST(NULL AS VARCHAR2(18)) 
 END                                                                    AS REMIT_AMOUNT
---------------------------------------------- NACHA FILE DATA POINTS --------------------------------------------------
---------------------------------------------- FILE HEADER RECORDS -----------------------------------------------------
,CAST(NULL AS VARCHAR2(10))                                             AS FH_File_Creation_Date
---------------------------------------------- BATCH HEADER RECORDS ----------------------------------------------------
,CAST(NULL AS VARCHAR2(6))                                              AS BH_Company_Description_Date
,CAST(NULL AS VARCHAR2(6))                                              AS BH_Effective_Entry_Date
---------------------------------------------- ENTRY DETAIL RECORDS ----------------------------------------------------
,CAST(NULL AS VARCHAR2(2))                                              AS ED_Transaction_Code
,CAST(NULL AS VARCHAR2(9))                                              AS ED_Receiving_DFI_ID_NBR
,CAST(NULL AS VARCHAR2(17))                                             AS ED_DFI_Acct_Number
,CAST(NULL AS VARCHAR2(18))                                             AS ED_Amount
,CAST(NULL AS VARCHAR2(7))                                              AS ED_Individual_Id_Number
,CAST(NULL AS VARCHAR2(22))                                             AS ED_Individual_Payee_name
,CAST(NULL AS VARCHAR2(7))                                              AS ED_Sequence_Number
---------------------------------------------- BATCH CONTROL RECORD ----------------------------------------------------
,CAST(NULL AS VARCHAR2(6))                                              AS BC_Entry_Addenda_Count
,CAST(NULL AS VARCHAR2(12))                                             AS BC_Total_Debit_Entry_Dol_Amt
,CAST(NULL AS VARCHAR2(12))                                             AS BC_Total_Credit_Entry_Dol_Amt
---------------------------------------------- FILE CONTROL RECORD -----------------------------------------------------
,CAST(NULL AS VARCHAR2(6))                                              AS FC_Block_Count
,CAST(NULL AS VARCHAR2(8))                                              AS FC_Entry_Count
,CAST(NULL AS VARCHAR2(12))                                             AS FC_Total_Debit_Entry_Dol_Amt
,CAST(NULL AS VARCHAR2(12))                                             AS FC_Total_Credit_Entry_Dol_Amt                                             
FROM TRANSACTION_INFORMATION
WHERE PMNT_METHOD = 'MC'
ORDER BY LOAN,PAYEE_NAME,PAYEE_STREET,PAYEE_TOWN,PAYEE_ZIP,RECORD_TYPE DESC;


/*********************************************************************************************************************************************
                                                          CREATING NACHA DATA TABLE
*********************************************************************************************************************************************/
INSERT INTO NACHA_FILE_DATA
SELECT
 PROCESS_DATE
,RECORD_INCLUDED
,RECORD_TYPE
,TRANSACTION_INFORMATION.LOAN
,IDX
,STATUS
,PAY_TYPE
,PAY_TYPE_DESC
,TRAN_CRT_DATE
,TRAN_POST_DATE
,AMOUNT                                                         AS FINAL_AMOUNT
,PMNT_METHOD
,DEPOSIT_BANK_NAME
,ACH_NUMBER
----------------------------------------------- CHECK FILE DATA POINTS -------------------------------------------------
,CAST(NULL AS VARCHAR2(32))                                                    AS CLIENT_ID
,CAST(NULL AS VARCHAR2(12))                                                    AS CLIENT_TRANS_REF_NBR
,CAST(NULL AS VARCHAR2(5))                                                     AS TRANSACTION_TYPE
,CAST(NULL AS VARCHAR2(18))                                                    AS AMOUNT
,CAST(NULL AS VARCHAR2(10))                                                    AS CHECK_DATE
,CAST(NULL AS VARCHAR2(12))                                                    AS CHECK_NUMBER
,CAST(NULL AS VARCHAR2(70))                                                    AS PAYEE_NAME
,CAST(NULL AS VARCHAR2(70))                                                    AS PAYEE_STREET
,CAST(NULL AS VARCHAR2(35))                                                    AS PAYEE_TOWN
,CAST(NULL AS VARCHAR2(2))                                                     AS PAYEE_STATE
,CAST(NULL AS VARCHAR2(9))                                                     AS PAYEE_ZIP
,CAST(NULL AS VARCHAR2(35))                                                    AS CH_REMITTANCE_INFO
,CAST(NULL AS VARCHAR2(10))                                                    AS DOCUMENT_DATE
,CAST(NULL AS VARCHAR2(20))                                                    AS INVOICE_NO
,CAST(NULL AS VARCHAR2(12))                                                    AS REMITTANCE_INFO
,CAST(NULL AS VARCHAR2(18))                                                    AS REMIT_AMOUNT
----------------------------------------------- FILE HEADER RECORD ----------------------------------------------------
,(SELECT (TO_CHAR(SYSDATE, 'YYMMDDHHMM')) FROM DUAL)                           AS FH_File_Creation_Date
----------------------------------------------- BATCH HEADER RECORD ----------------------------------------------------
,(SELECT (TO_CHAR(SYSDATE, 'MMDDYY')) FROM DUAL)                               AS BH_Company_Description_Date
,(SELECT (TO_CHAR(SYSDATE, 'YYMMDD')) FROM DUAL)                               AS BH_Effective_Entry_Date
----------------------------------------------- ENTRY DETAIL RECORD ----------------------------------------------------
,ACCT_TYPE                                                                     AS ED_Transaction_Code       --If the value for the ACC_TYPE = SVA then Set value to "32" | If the value for the ACC_TYPE = CHA then Set value to "22"
,SUBSTR(RPAD(DEPOSIT_BANK_ROUT_NO,9),1,9)                                      AS ED_Receiving_DFI_ID_NBR
,SUBSTR(RPAD(DEPOSIT_BANK_ACNT_NO,17),1,17)                                    AS ED_DFI_Acct_Number
,SUBSTR(RPAD(REPLACE(AMOUNT,'.',''),18),1,18)                                  AS ED_Amount
,'0000PPD'                                                                     AS ED_Individual_Id_Number   --0000PPD ? creditor is individual | 0000CTX ? creditor is corp
,SUBSTR(RPAD(CASE WHEN PAYEE_NAME IN (SELECT PAYEE FROM PAYEE_TEMP_TABLE)
                  THEN SUBSTR(PAYEE_TEMP_TABLE.BORR_NAME1,1,22)
                  ELSE PAYEE_NAME
                  END,22),1,22)                                                AS ED_Individual_Payee_name  --PAYEE THAT IS NOT DEATH
,SUBSTR(LPAD(NVL(ACH_GROUP_NBR,0),7,0),1,7)                                    AS ED_Sequence_Number        --COUNT ALL THE RECORDS WITH A RECORD_INCLUDED = 'Y'
----------------------------------------------- BATCH CONTROL RECORD ---------------------------------------------------
,SUBSTR(LPAD((SELECT COUNT(LOAN) AS Sequence_Number
              FROM TRANSACTION_INFORMATION
              WHERE RECORD_INCLUDED = 'Y'
              AND PMNT_METHOD = 'DD'
              AND RECORD_TYPE = 'T'),6,0),1,6)                                 AS BC_Entry_Addenda_Count    --COUNT ALL THE RECORDS WITH A RECORD_INCLUDED = 'Y'
,SUBSTR(REPLACE(LPAD(NVL((SELECT SUM(AMOUNT) AS DEBIT_AMT
                          FROM TRANSACTION_INFORMATION
                          WHERE RECORD_INCLUDED = 'Y'
                          AND PMNT_METHOD = 'DD'
                          AND RECORD_TYPE = 'T'
                          AND ACCT_TYPE IN ('27','37')),0),12,0),'.',''),1,12) AS BC_Total_Debit_Entry_Dol_Amt   --SUM OF ALL AMTS FOR 27/37'S
,SUBSTR(REPLACE(LPAD(NVL((SELECT SUM(AMOUNT) AS DEBIT_AMT
                          FROM TRANSACTION_INFORMATION
                          WHERE RECORD_INCLUDED = 'Y'
                          AND PMNT_METHOD = 'DD'
                          AND RECORD_TYPE = 'T'
                          AND ACCT_TYPE IN ('22','32')),0),12,0),'.',''),1,12) AS BC_Total_Credit_Entry_Dol_Amt   --SUM OF ALL AMTs FOR 22/32'S
----------------------------------------------- FILE CONTROL RECORD ----------------------------------------------------
,LPAD(CEIL((SELECT (COUNT(LOAN)/10) AS Sequence_Number
            FROM TRANSACTION_INFORMATION
            WHERE RECORD_INCLUDED = 'Y'
            AND PMNT_METHOD = 'DD'
            AND RECORD_TYPE = 'T')),6,0)                                       AS FC_Block_Count
,LPAD((SELECT COUNT(LOAN) AS Sequence_Number
       FROM TRANSACTION_INFORMATION
       WHERE RECORD_INCLUDED = 'Y'
       AND PMNT_METHOD = 'DD'
       AND RECORD_TYPE = 'T'),8,0)                                             AS FC_Entry_Count
,SUBSTR(REPLACE(LPAD(NVL((SELECT SUM(AMOUNT) AS DEBIT_AMT
                          FROM TRANSACTION_INFORMATION
                          WHERE RECORD_INCLUDED = 'Y'
                          AND PMNT_METHOD = 'DD'
                          AND RECORD_TYPE = 'T'
                          AND ACCT_TYPE IN ('27','37')),0),12,0),'.',''),1,12) AS BC_Total_Debit_Entry_Dol_Amt   --SUM OF ALL AMTS FOR 27/37'S
,SUBSTR(REPLACE(LPAD(NVL((SELECT SUM(AMOUNT) AS DEBIT_AMT
                          FROM TRANSACTION_INFORMATION
                          WHERE RECORD_INCLUDED = 'Y'
                          AND PMNT_METHOD = 'DD'
                          AND RECORD_TYPE = 'T'
                          AND ACCT_TYPE IN ('22','32')),0),12,0),'.',''),1,12) AS BC_Total_Credit_Entry_Dol_Amt   --SUM OF ALL AMTs FOR 22/32'S
FROM TRANSACTION_INFORMATION
LEFT OUTER JOIN PAYEE_TEMP_TABLE ON TRANSACTION_INFORMATION.LOAN = PAYEE_TEMP_TABLE.LOAN
ORDER BY LOAN, RECORD_TYPE DESC;

/*********************************************************************************************************************************************
                    UPDATING THE TRANSACTION_INFORMATION TABLE WITH ACH_NUMBER FOR EACH INDIVIDAUL TRANSACTION
*********************************************************************************************************************************************/
UPDATE  NACHA_FILE_DATA
SET ED_Individual_Id_Number = '0000CTX'
WHERE ED_Individual_Payee_name NOT IN (SELECT BORR_NAME1 FROM PAYEE_TEMP_TABLE)
AND PAY_TYPE IN ('90','91','92','93','94','95','96','PRPTAX','PROPIN','FORCLS','MISCEL','ATTFEE','LGLFEE','FRCPLC','HAZINS','APPDIL','APPFCL','APPSHS','ATTCST');

/*********************************************************************************************************************************************
                                              INSERTING NACHA_FILE_DATA INTO THE DAILY_DISBURSEMENTS TABLE
*********************************************************************************************************************************************/
INSERT INTO DAILY_DISBURSEMENTS
(PROCESS_DATE,RECORD_INCLUDED,RECORD_TYPE,LOAN,IDX,STATUS,PAY_TYPE,PAY_TYPE_DESC,TRAN_CRT_DATE,TRAN_POST_DATE,FINAL_AMOUNT,PMNT_METHOD,DEPOSIT_BANK_NAME
,ACH_NUMBER,CLIENT_ID,CLIENT_TRANS_REF_NBR,TRANSACTION_TYPE,AMOUNT,CHECK_DATE,CHECK_NUMBER,PAYEE_NAME,PAYEE_STREET,PAYEE_TOWN,PAYEE_STATE,PAYEE_ZIP,CH_REMITTANCE_INFO
,DOCUMENT_DATE,INVOICE_NO,REMITTANCE_INFO,REMIT_AMOUNT,FH_File_Creation_Date,BH_Company_Description_Date,BH_Effective_Entry_Date,ED_Transaction_Code
,ED_Receiving_DFI_ID_NBR,ED_DFI_Acct_Number,ED_Amount,ED_Individual_Id_Number,ED_Individual_Payee_name,ED_Sequence_Number,BC_Entry_Addenda_Count
,BC_Total_Debit_Entry_Dol_Amt ,BC_Total_Credit_Entry_Dol_Amt,FC_Block_Count,FC_Entry_Count,FC_Total_Debit_Entry_Dol_Amt,FC_Total_Credit_Entry_Dol_Amt)

SELECT *
FROM NACHA_FILE_DATA;

/*********************************************************************************************************************************************
                                        INSERTING CHECK_FILE_DATA INTO THE DAILY_DISBURSEMENTS TABLE
*********************************************************************************************************************************************/
INSERT INTO DAILY_DISBURSEMENTS
(PROCESS_DATE,RECORD_INCLUDED,RECORD_TYPE,LOAN,IDX,STATUS,PAY_TYPE,PAY_TYPE_DESC,TRAN_CRT_DATE,TRAN_POST_DATE,FINAL_AMOUNT,PMNT_METHOD,DEPOSIT_BANK_NAME
,ACH_NUMBER,CLIENT_ID,CLIENT_TRANS_REF_NBR,TRANSACTION_TYPE,AMOUNT,CHECK_DATE,CHECK_NUMBER,PAYEE_NAME,PAYEE_STREET,PAYEE_TOWN,PAYEE_STATE,PAYEE_ZIP,CH_REMITTANCE_INFO
,DOCUMENT_DATE,INVOICE_NO,REMITTANCE_INFO,REMIT_AMOUNT,FH_File_Creation_Date,BH_Company_Description_Date,BH_Effective_Entry_Date,ED_Transaction_Code
,ED_Receiving_DFI_ID_NBR,ED_DFI_Acct_Number,ED_Amount,ED_Individual_Id_Number,ED_Individual_Payee_name,ED_Sequence_Number,BC_Entry_Addenda_Count
,BC_Total_Debit_Entry_Dol_Amt ,BC_Total_Credit_Entry_Dol_Amt,FC_Block_Count,FC_Entry_Count,FC_Total_Debit_Entry_Dol_Amt,FC_Total_Credit_Entry_Dol_Amt)
SELECT *
FROM CHECK_FILE_DATA;

/*********************************************************************************************************************************************
                                              UPDATING REVLOANSERVICING 
*********************************************************************************************************************************************/

----- UPDATING THE MAILTO_CHECK_NO FIELD IN THE REVLOANPAYMENTS ------
UPDATE REVLOANPAYMENTS
SET MAILTO_CHECK_NO   = (SELECT DISTINCT DAILY_DISBURSEMENTS.CHECK_NUMBER
                         FROM DAILY_DISBURSEMENTS
                         WHERE DAILY_DISBURSEMENTS.LOAN        IN REVLOANPAYMENTS.LOAN
                         AND DAILY_DISBURSEMENTS.PAY_TYPE      IN REVLOANPAYMENTS.PAY_TYPE
                         AND DAILY_DISBURSEMENTS.PAYEE_STREET  IN REVLOANPAYMENTS.MAILTO_STREET
                         AND DAILY_DISBURSEMENTS.PAYEE_STATE   IN REVLOANPAYMENTS.MAILTO_STATE
                         AND DAILY_DISBURSEMENTS.PAYEE_TOWN    IN REVLOANPAYMENTS.MAILTO_CITY
                         AND DAILY_DISBURSEMENTS.PAYEE_ZIP     IN REVLOANPAYMENTS.MAILTO_ZIP
                         AND DAILY_DISBURSEMENTS.FINAL_AMOUNT  IN REVLOANPAYMENTS.AMOUNT
                         AND DAILY_DISBURSEMENTS.PMNT_METHOD = 'MC'
                         AND DAILY_DISBURSEMENTS.PROCESS_DATE = (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')FROM DUAL)
                         AND DAILY_DISBURSEMENTS.RECORD_INCLUDED = 'Y')
WHERE REVLOANPAYMENTS.PMNT_METHOD = 'MC' 
AND   REVLOANPAYMENTS.LOAN IN (SELECT DISTINCT LOAN FROM DAILY_DISBURSEMENTS)
AND   REVLOANPAYMENTS.IDX  IN (SELECT DISTINCT IDX FROM DAILY_DISBURSEMENTS);

----- UPDATING THE CORP_ADV_CHECK_NUMBER  IN THE REVLOANCORPADVPAYMENT ------
UPDATE  REVLOANCORPADVPAYMENT
SET CORP_ADV_CHECK_NUMBER   = (SELECT DISTINCT DAILY_DISBURSEMENTS.CHECK_NUMBER
                               FROM DAILY_DISBURSEMENTS
                               WHERE DAILY_DISBURSEMENTS.LOAN        IN REVLOANCORPADVPAYMENT.LOAN
                               AND DAILY_DISBURSEMENTS.PAY_TYPE      IN REVLOANCORPADVPAYMENT.TRAN_TYPE
                               AND DAILY_DISBURSEMENTS.IDX           IN REVLOANCORPADVPAYMENT.CORP_ADV_IDX
                               AND DAILY_DISBURSEMENTS.TRAN_CRT_DATE IN REVLOANCORPADVPAYMENT.TRAN_DATE
                               AND DAILY_DISBURSEMENTS.FINAL_AMOUNT  IN REVLOANCORPADVPAYMENT.CORP_ADV_AMOUNT
                               AND DAILY_DISBURSEMENTS.PMNT_METHOD = 'MC'
                               AND DAILY_DISBURSEMENTS.PROCESS_DATE = (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')FROM DUAL)
                               AND DAILY_DISBURSEMENTS.RECORD_INCLUDED = 'Y')
WHERE REVLOANCORPADVPAYMENT.LOAN IN (SELECT DISTINCT LOAN FROM DAILY_DISBURSEMENTS)
AND   REVLOANCORPADVPAYMENT.IDX  IN (SELECT DISTINCT IDX FROM DAILY_DISBURSEMENTS);


UPDATE  REVLOANCORPADVPAYMENT
SET
CORP_ADV_CHECK_DATE = (SELECT DISTINCT DAILY_DISBURSEMENTS.CHECK_DATE
                          FROM DAILY_DISBURSEMENTS
                          WHERE DAILY_DISBURSEMENTS.LOAN        IN REVLOANCORPADVPAYMENT.LOAN
                          AND DAILY_DISBURSEMENTS.PAY_TYPE      IN REVLOANCORPADVPAYMENT.TRAN_TYPE
                          AND DAILY_DISBURSEMENTS.IDX           IN REVLOANCORPADVPAYMENT.CORP_ADV_IDX
                          AND DAILY_DISBURSEMENTS.TRAN_CRT_DATE IN REVLOANCORPADVPAYMENT.TRAN_DATE
                          AND DAILY_DISBURSEMENTS.FINAL_AMOUNT  IN REVLOANCORPADVPAYMENT.CORP_ADV_AMOUNT
                          AND DAILY_DISBURSEMENTS.PMNT_METHOD = 'MC'
                          AND DAILY_DISBURSEMENTS.PROCESS_DATE = (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')FROM DUAL)
                          AND DAILY_DISBURSEMENTS.RECORD_INCLUDED = 'Y')
WHERE REVLOANCORPADVPAYMENT.LOAN IN (SELECT DISTINCT LOAN FROM DAILY_DISBURSEMENTS)
AND REVLOANCORPADVPAYMENT.IDX  IN (SELECT DISTINCT IDX FROM DAILY_DISBURSEMENTS);

STATUS := 'Success';

    
END USP_DAILY_DISBURSEMENTS;