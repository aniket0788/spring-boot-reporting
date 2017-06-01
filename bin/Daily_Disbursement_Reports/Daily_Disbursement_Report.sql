/*********************************************************************************************************************** 
                                                DAILY DISBURSEMENTS REPORT 
***********************************************************************************************************************/
SELECT
 DAILY_DISBURSEMENTS.PROCESS_DATE                                      AS "PROCESS DATE"
,DAILY_DISBURSEMENTS.RECORD_INCLUDED                                   AS "RECORD INCLUDED"
,DAILY_DISBURSEMENTS.RECORD_TYPE                                       AS "RECORD TYPE"
,DAILY_DISBURSEMENTS.LOAN
,DAILY_DISBURSEMENTS.IDX
,CASE WHEN DAILY_DISBURSEMENTS.STATUS = '2' THEN 'PENDING'
      WHEN DAILY_DISBURSEMENTS.STATUS = '1' THEN 'ACTIVE'
      WHEN DAILY_DISBURSEMENTS.STATUS = '0' THEN 'CANCELLED'
 ELSE '' END                                                           AS "TRANSACTION STATUS"
,DAILY_DISBURSEMENTS.PAY_TYPE                                          AS "PAYMENT TYPE"
,DAILY_DISBURSEMENTS.PAY_TYPE_DESC                                     AS "PAYMENT TYPE DESC"
,DAILY_DISBURSEMENTS.INVOICE_NO                                        AS "INVOICE NUMBER"
,DAILY_DISBURSEMENTS.TRAN_CRT_DATE                                     AS "TRAN CREATED DATE"
,DAILY_DISBURSEMENTS.TRAN_POST_DATE                                    AS "TRAN POSTED DATE"
,DAILY_DISBURSEMENTS.FINAL_AMOUNT                                      AS "AMOUNT"
,DAILY_DISBURSEMENTS.TRANSACTION_TYPE                                  AS "PAYMENT METHOD"
,DAILY_DISBURSEMENTS.CHECK_DATE                                        AS "DISBURSEMENT_DATE"
,DAILY_DISBURSEMENTS.CHECK_NUMBER                                      AS "CHECK NUMBER"
,DAILY_DISBURSEMENTS.PAYEE_NAME                                        AS "PAYEE NAME"
,DAILY_DISBURSEMENTS.PAYEE_STREET                                      AS "MAIL TO STREET"
,DAILY_DISBURSEMENTS.PAYEE_TOWN                                        AS "MAIL TO CITY"
,DAILY_DISBURSEMENTS.PAYEE_STATE                                       AS "MAIL TO STATE"
,DAILY_DISBURSEMENTS.PAYEE_ZIP                                         AS "MAIL TO ZIP"
,DAILY_DISBURSEMENTS.ACH_NUMBER                                        AS "ACH NUMBER"
,DAILY_DISBURSEMENTS.DEPOSIT_BANK_NAME                                 AS "DEPOSIT BANK NAME"
,DAILY_DISBURSEMENTS.ED_DFI_ACCT_NUMBER                                AS "DEPOSIT BANK ACNT NO"
,DAILY_DISBURSEMENTS.ED_RECEIVING_DFI_ID_NBR                           AS "DEPOSIT_BANK_ROUT_NO"
,CASE WHEN DAILY_DISBURSEMENTS.ED_TRANSACTION_CODE = '22'
      THEN 'CHECKING'
      WHEN DAILY_DISBURSEMENTS.ED_TRANSACTION_CODE = '32'
      THEN 'SAVINGS'
 ELSE '' END                                                           AS "ACCT TYPE"
,NOTES.NOTE                                                            AS NOTE
FROM DAILY_DISBURSEMENTS
LEFT OUTER JOIN (SELECT RLP.LOAN,RLP.IDX, RLP.NOTE
            FROM REVLOANPAYMENTS   RLP
            UNION
            SELECT RLCA.LOAN,RLCA.IDX, RLCA.NOTE
            FROM REVLOANCORPADV    RLCA
            ) NOTES  ON DAILY_DISBURSEMENTS.LOAN = NOTES.LOAN AND DAILY_DISBURSEMENTS.IDX = NOTES.IDX
WHERE DAILY_DISBURSEMENTS.PROCESS_DATE = ? --NEEDS TO LOOK AT THE END_DT
ORDER BY DAILY_DISBURSEMENTS.LOAN,DAILY_DISBURSEMENTS.PAYEE_NAME,DAILY_DISBURSEMENTS.PAYEE_STREET
,DAILY_DISBURSEMENTS.PAYEE_TOWN,DAILY_DISBURSEMENTS.PAYEE_ZIP,DAILY_DISBURSEMENTS.RECORD_TYPE
,DAILY_DISBURSEMENTS.RECORD_INCLUDED DESC