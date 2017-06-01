SELECT 
----  FILE HEADER RECORD ----------------------
FH_File_Creation_Date 			AS File_Creation_Time,
----- BATCH HEADER RECORDs --------------------
BH_Company_Description_Date 	AS Company_Description_Date,
BH_Effective_Entry_Date 		AS Effective_Entry_Date,
----- ENTRY DETAIL RECORDS --------------------
ED_Transaction_Code 			AS Transaction_Code,
ED_Receiving_DFI_ID_NBR 		AS Receiving_DFI_ID_NBR,
ED_DFI_Acct_Number 				AS DFI_Account_Number,     
ED_Amount 						AS Amount,              
ED_Individual_Id_Number 		AS Individual_Id_Number,
ED_Individual_Payee_name 		AS Individual_Payee_name,
ED_Sequence_Number 				AS  Sequence_Number,
---- BATCH CONTROL RECORD ---------------------
BC_Entry_Addenda_Count 			AS Entry_or_Addenda_Count,       
BC_Total_Debit_Entry_Dol_Amt 	AS Total_Debit_Entry_Dollar_Amt, 
BC_Total_Credit_Entry_Dol_Amt 	AS Total_Credit_Entry_Dollar_Amt,
---- FILE CONTROL RECORD ----------------------
FC_Block_Count 					AS Block_Count,                
FC_Entry_Count 					AS Entry_Count,                
FC_Total_Debit_Entry_Dol_Amt 	AS Total_Debit_Entry_Amount, 	
FC_Total_Credit_Entry_Dol_Amt 	AS Total_Credit_Entry_Amount
FROM DAILY_DISBURSEMENTS
where RECORD_INCLUDED = 'Y' 
AND RECORD_TYPE = 'T' 
AND PMNT_METHOD = 'DD' 
AND PROCESS_DATE = ?