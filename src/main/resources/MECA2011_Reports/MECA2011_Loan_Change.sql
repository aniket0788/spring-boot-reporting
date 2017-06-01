SELECT SCM7.their_loan_no       AS Fannie_Mae_Loan_Identifier, 
       NULL                     AS Prevs_Fannie_Mae_Loan_Identfr, 
       NULL                     AS Mers_Identification, 
       NULL                     AS Number_of_Borrowers, 
       NULL                     AS "Borrower's_Age", 
       NULL                     AS "Borrower's_Birthday", 
       NULL                     AS "Borrower's_Ethnics_Code", 
       NULL                     AS "Borrower's_race_code_1", 
       NULL                     AS "Borrower's_race_code_2", 
       NULL                     AS "Borrower's_race_code_3", 
       NULL                     AS "Borrower's_race_code_4", 
       NULL                     AS "Borrower's_race_code_5", 
       NULL                     AS "Borrower's_SSN", 
       NULL                     AS "Borrower's_Gender", 
       NULL                     AS "Borrower's_Gross_Mnthly_Income", 
       0                        AS "CoBorrower's_Age",
       NULL                     AS "CoBorrower's_Birthday", 
       NULL                     AS "CoBorrower's_Ethnics_Code", 
       NULL                     AS "CoBorrower's_Race_Code1", 
       NULL                     AS "CoBorrower's_Race_Code2", 
       NULL                     AS "CoBorrower's_Race_Code3", 
       NULL                     AS "CoBorrower's_Race_Code4", 
       NULL                     AS "CoBorrower's_Race_Code5", 
       NULL                     AS "CoBorrower's_SSN", 
       NULL                     AS "CoBorrower's_Gender", 
       NULL                     AS Structure_Built_Year, 
       NULL                     AS Property_Dwelling_Type, 
       NULL                     AS Property_Street_Address, 
       NULL                     AS Property_City, 
       NULL                     AS Property_State, 
       NULL                     AS Property_Zip_Code, 
       NULL                     AS Number_of_Bedrooms, 
       NULL                     AS Number_of_Units, 
       NULL                     AS Property_Adjustment_Value, 
       NULL                     AS Property_Appraisal_Value, 
       NULL                     AS "Property_Appraiser's_Identfr", 
       NULL                     AS The_Sup_Identfr_of_Prop_Appr, 
       NULL                     AS Property_Sales_Amount, 
       NULL                     AS Contrat_Commitment_Period, 
       NULL                     AS Contract_Number, 
       NULL                     AS Contract_Type_Code, 
       NULL                     AS Contract_Org_Region_Code, 
       NULL                     AS DDF_Document_Certified_Date, 
       NULL                     AS DDF_Document_Received_Date, 
       NULL                     AS Loan_Originator_comp_ID, 
       NULL                     AS Loan_Originator_ID, 
       NULL                     AS Lender_loan_number, 
       NULL                     AS "FHA/VA_Case_Number", 
       NULL                     AS "FHA/VA_Case_No_Assignment_Dt", 
       NULL                     AS Loan_Funding_Date, 
       NULL                     AS Loan_Purchase_Date, 
       NULL                     AS Loan_Rounding_Indicator, 
       NULL                     AS Loan_Scheduled_Closing_Dt, 
       NULL                     AS Loan_Purpose, 
       NULL                     AS Loan_Prod_and_Intrst_rate_type, 
       NULL                     AS Loan_first_Disburse_Date, 
       NULL                     AS "1st_P_and_I_Paymnt_Chng_Dt", 
       NULL                     AS Disburse_Amount, 
       NULL                     AS Disburse_Date, 
       NULL                     AS Loan_Origination_Fee_Amount, 
       NULL                     AS Loan_Other_Closing_Cost_Amt, 
       NULL                     AS Loan_Total_Closing_Cost_Amt, 
       NULL                     AS Loan_Maturity_Terms, 
       NULL                     AS Loan_Maturity_and_LOC_ratio, 
       NULL                     AS Seasonal_loan_fee, 
       NULL                     AS Loan_Product_type_code, 
       NULL                     AS Loan_Intrst_Rate_type_code, 
       NULL                     AS Loan_Initial_Interest_Rate, 
       NULL                     AS Loan_ARM_Plan_Number, 
       NULL                     AS Loan_Original_Index_Rate, 
       NULL                     AS Mortgage_Margin_Rate, 
       NULL                     AS Mortgage_Ceiling_Interest_Rate, 
       NULL                     AS Mortgage_Floor_Interest_Rate, 
       NULL                     AS Expected_Average_Index_Rate, 
       NULL                     AS Expected_Average_Interest_Rate, 
       NULL                     AS Loan_Original_UPB, 
       NULL                     AS Org_1stYr_Prop_Ex_St_Aside_Amt, 
       NULL                     AS Lien_Advance_Amount, 
       NULL                     AS Loan_Other_Draw_Amount, 
       NULL                     AS Loan_Financial_Max_Claim_Amt, 
       NULL                     AS Loan_Orig_Principle_Limit_Amt, 
       MASV.old_orig_prin_limit AS Loan_Orig_Net_Principle_Amt, 
       NULL                     AS Loan_Orig_Repair_St_Aside_Amt, 
       NULL                     AS Loan_Orig_Scheduled_Paymnt_Amt, 
       NULL                     AS Loan_Servicer_Fee_Amount, 
       MASV.init_serv_fee_sa    AS Loan_Init_Svr_Fee_St_Aside_Amt, 
       '268800000'              AS Seller_Rd_Contact_Info_Idntfr, 
       '268800000'              AS Seller_Svr_Rd_Cont_Info_Idntfr, 
       '268800000'              AS Servicer_Rd_Cont_Info_Idntfr, 
       MASV.init_loc_reserve    AS Original_LOC_Reserve_Amount, 
       MASV.init_loc_reserve    AS Orig_Net_LOC_Reserve_Amount, 
       NULL                     AS Orig_Monthly_TI_withheld_Amt 
FROM   scm7_cd SCM7 
INNER JOIN      ( 
                ( 
                       SELECT loan
                       FROM   revloanservicingmonth RLSM 
                       WHERE  rlsm.history='L' 
                       AND    rlsm.item='zzz' 
                       AND    rlsm.status='1' 
                       AND    rlsm.record_date = 
                              ( 
                                     SELECT To_date(Last_day(?),'DD-MON-YY')+1 AS nextmonthfirstday 
                                     FROM   dual) ) rlsm ) 
ON              SCM7.loan = rlsm.loan 
       LEFT OUTER JOIN (SELECT masv_cd.loan, 
                               masv_cd.old_orig_prin_limit, 
                               masv_cd.init_serv_fee_sa, 
                               masv_cd.init_loc_reserve 
                        FROM   masv_cd masv_cd 
                        WHERE  masv_cd.history = 'L' 
                               AND masv_cd.item = 'zzz' 
                               AND masv_cd.status = '1') MASV 
                    ON SCM7.loan = MASV.loan 
WHERE  SCM7.history = 'L' 
       AND SCM7.item = 'zzz' 
       AND SCM7.status = '1' 
AND SCM7.INVESTOR_CODE = ? 