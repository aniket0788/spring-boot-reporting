SELECT
  revmon.LOAN           AS nationstar_loanno,
  SCM7_CD.INVESTOR_CODE AS investor,
  revmon.LOAN_BALANCE 	AS current_UPB
  -- NSM losses ???
  --revmon.LOAN_STATUS AS claim_type
FROM
  REVLOANSERVICINGMONTH  revmon
JOIN SCM7_CD
ON
  revmon.LOAN = SCM7_CD.LOAN
WHERE
  revmon.HISTORY        ='L'
AND revmon.ITEM         = 'zzz'
AND revmon.STATUS       = '1'
AND SCM7_CD.HISTORY     ='L'
AND SCM7_CD.ITEM        = 'zzz'
AND SCM7_CD.STATUS      = '1'
AND revmon.RECORD_DATE BETWEEN ? and ?

AND
scm7_cd.investor_code = ?
