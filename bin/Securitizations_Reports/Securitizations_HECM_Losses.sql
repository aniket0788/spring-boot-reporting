select 
revmon.LOAN         as loanno ,
revmon.LOAN_BALANCE as UBP_Deal ,
revmon.LOAN_STATUS  as statusDeal,
--Accruals ?--
revmon.MON_SERV_FEE as attorney_fees,
--Servicing Advances ?--
--Principal Payments ?--
--Paid in Full Proceeds ?--
--Short Sale/ 3RD Party  Proceeds ?--
-- REO Sales Proceeds ?--
--revhdcl.POSTDATE    as initial_claim_date,
--Supplemental  Claim  Proceeds ?--
--Current UPB ?--
revmon.LOAN_BALANCE as UBP,
--UPB Adj ?--
--Funds (Due to Trust) ?--
--NSM Losses ?--
--Investor Losses ?--
--Total Losses ?--
revhdcl.CLAIMTYPE as claimtype
from REVLOANSERVICINGMONTH revmon 
inner join MASV_CD masvcd on revmon.LOAN=masvcd.LOAN
inner join REVLOANHUDCLAIM revhdcl on revmon.LOAN=revhdcl.LOAN
inner join  SCM7_CD scm7cd on revmon.LOAN=scm7cd.LOAN
where 
scm7cd.investor_code = ? and 
revmon.RECORD_DATE BETWEEN ? and ?