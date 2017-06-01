SELECT DISTINCT
  (dd.CHECK_NUMBER)            AS check_number,
  dd.CLIENT_ID                 AS client_id,
  dd.CLIENT_TRANS_REF_NBR      AS client_trans_ref_nbr,
  dd.TRANSACTION_TYPE          AS transaction_type,
  '826195385'                  AS debit_account_number,
  '111300880'                  AS debit_routing_number,
  checkdata.amount             AS amount,
  checkdata.check_date         AS check_date,
  checkdata.check_number       AS check_no,
  '00000'                      AS delivery_method,
  'A2'                         AS form_code,
  checkdata.payee_name         AS payee_name,
  checkdata.payee_street       AS payee_street,
  checkdata.payee_town         AS payee_town,
  checkdata.payee_state        AS payee_state,
  checkdata.payee_zip          AS payee_zip,
  checkdata.ch_remittance_info AS ch_remittance_info,
  pmntstub.document_date       AS document_date,
  pmntstub.invoice_no          AS invoice_no,
  pmntstub.remittance_info     AS remittance_info,
  pmntstub.remit_amount        AS remit_amount,
  pmntstub.PAY_TYPE            AS remit_pay_type
FROM DAILY_DISBURSEMENTS    DD 
INNER JOIN (SELECT DISTINCT DD1.LOAN,DD1.AMOUNT,DD1.CHECK_DATE,DD1.IDX,DD1.CHECK_NUMBER,DD1.PAYEE_NAME,DD1.PAYEE_STREET
                            ,DD1.PAYEE_TOWN,DD1.PAYEE_STATE,DD1.PAYEE_ZIP,DD1.CH_REMITTANCE_INFO,DD1.RECORD_TYPE
            FROM  DAILY_DISBURSEMENTS    DD1
            WHERE RECORD_INCLUDED = 'Y'
            AND   RECORD_TYPE   = 'T'
            AND   PMNT_METHOD   = 'MC'
            ) CHECKDATA ON CHECKDATA.PAYEE_NAME = dd.PAYEE_NAME AND checkdata.CHECK_NUMBER = DD.CHECK_NUMBER AND checkdata.RECORD_TYPE = 'T' --CHANGE AS PER DEFECT# 60844
INNER JOIN (SELECT DISTINCT DD2.LOAN,DD2.CHECK_NUMBER,DD2.IDX,DD2.DOCUMENT_DATE,DD2.INVOICE_NO,DD2.REMITTANCE_INFO
                                ,DD2.REMIT_AMOUNT,DD2.PAY_TYPE,DD2.PAYEE_NAME, DD2.RECORD_TYPE
                 FROM  DAILY_DISBURSEMENTS    DD2
                 WHERE RECORD_INCLUDED = 'Y'
                 AND   RECORD_TYPE   = 'I'
                 AND   PMNT_METHOD   = 'MC'
                 ) pmntstub ON pmntstub.loan = dd.loan AND PMNTSTUB.IDX = DD.IDX AND pmntstub.CHECK_NUMBER = DD.CHECK_NUMBER AND pmntstub.RECORD_TYPE = 'I'
WHERE dd.RECORD_INCLUDED = 'Y'
AND dd.PMNT_METHOD = 'MC'
AND dd.RECORD_TYPE = 'I'
AND dd.process_date = ? --NEEDS TO LOOK AT THE END_DT - DEFECT# 60730
ORDER BY DD.CHECK_NUMBER