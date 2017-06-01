package com.nationstar.reportengine.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class Constants {

	@Value("${scheduler.enable}")
	public boolean isSchedulerEnabled;
	@Value("${report.nationstar.meca.report.path}")
	public String MECAREPORTPATH;
	
	@Value("${report.nationstar.meca.report.basepath}")
	public String MECA_REPORT_BASEPATH;

	public static String SUCCESS = "SUCCESS";
	public static String FAILURE = "FAILURE";
	public static String FILE_CREATION_PROBLEM = "File Creation Problem";

	public static String INVALID_JSON_FORMAT_ERROR_CODE = "201";
	public static String INVALID_JSON_FORMAT_ERROR_MESSAGE = "Invalid JSON Report Format";
	
	public static String INVALID_SYNTAX_IN_SQL_QUERY_ERROR_CODE = "202";
	public static String INVALID_SYNTAX_IN_SQL_QUERY_MESSAGE = "Invalid Syntax in SQL Query";
	
	public static String REQUEST_PARAMETERS_MISSING_ERROR_CODE = "203";
	
	public static String PROBLEM_IN_FILE_NAME_OR_FILE_IS_NOT_PRESENT_ERROR_CODE = "204";
	public static String PROBLEM_IN_FILE_NAME_OR_FILE_IS_NOT_PRESENT_ERROR_MESSAGE = "Problem in file name or file is not present.";
	
	public static String NOT_ALLOWED_COLUMN_TYPE_ERROR_CODE = "205";
	public static String NOT_ALLOWED_COLUMN_TYPE_ERROR_MESSAGE = "This Column type is not allowed in JSON file.";
	
	
	public static String PROBLEM_IN_CREATING_A_FILE_ERROR_CODE = "206";
	public static String PROBLEM_IN_CREATING_A_FILE_ERROR_MESSAGE = "Problem in creating a file";
	
	public static String PROBLEM_IN_WRITING_TO_A_CSV_FILE_ERROR_CODE = "207";
	public static String PROBLEM_IN_WRITING_TO_A_CSV_FILE_ERROR_MESSAGE = "Problem in writing to a CSV file";
	
	
	public static String INVALID_SQL_ARGUMENTS_PARAMETERS_ERROR_CODE = "208";
	public static String INVALID_SQL_ARGUMENTS_PARAMETERS_ERROR_MESSAGE = "Invalid SQL Arguments Parameters.";
	
	public static String PROBLEM_IN_WRITING_DATA_TO_JSON = "209";
	public static String PROBLEM_IN_WRITING_DATA_TO_JSON_ERROR_MESSAGE = "Problem in writing data to list of array of strings";
	
	public static String CLIENT_ID = "Client ID";
	public static String CLIENT_TRANSACTION_REFERENCE_NUMBER ="Client Transaction Reference Number";
	public static String TRANSACTION_TYPE = "Transaction Type";
	public static String CHECK_DATE = "Check Date";
	public static String USD = "USD";
	public static String AMOUNT = "Amount";
	public static String DEBIT_ACCOUNT_NUMBER = "Debit Account Number";
	public static String DEBIT_ROUTING_NUMBER = "Debit Routing Number";
	public static String PAYEE_NAME = "Payee Name";
	public static String PAYEE_STREET = "Payee Street";
	public static String PAYEE_TOWN = "Payee Town";
	public static String PAYEE_STATE = "Payee State";
	public static String PAYEE_ZIP = "Payee Zip";
	public static String CHECK_NUMBER = "Check Number";
	public static String DELIVERY_METHOD = "Delivery Method";
	public static String FORM_CODE = "Form Code";
	public static String DOCUMENT_DATE = "Document Date";
	public static String NUMBER = "Number";
	public static String REMITTANCE_INFO = "Remittance Info";
	public static String REMIT_AMOUNT = "Remit Amount";
	public static String REMIT_PAY_TYPE = "Remit Pay Type";
	
	public static String ERROR_MSG = "Data Issue... Please Contact Support !";

}
