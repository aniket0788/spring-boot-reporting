package com.nationstar.reportengine.util;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportRequest;

@Component
public class ReportRequestValidator {

	public void validate(ReportRequest req) {

		
		StringBuffer errorMsg = new StringBuffer();

		String deliveryMethod = req.getDeliveryMethod();
		String emailAddress = req.getEmailAddress();
		String endDate = req.getEndDate();
		String reportExportFormat = req.getReportExportFormat();
		String startDate = req.getStartDate();
		String userId = req.getUserID();

		if (deliveryMethod == null || deliveryMethod.trim().isEmpty() ) {
			errorMsg.append("Delivery Method is empty ::");

		}
		if (emailAddress == null || emailAddress.trim().isEmpty()) {
			errorMsg.append("Email Address is empty ::");

		}
		if (endDate == null || endDate.trim().isEmpty()) {
			errorMsg.append(" End Date is empty::");;
		}
		if (reportExportFormat == null || reportExportFormat.trim().isEmpty()) {
			errorMsg.append("Report Export Format is empty::");

		}
		if (startDate == null || startDate.trim().isEmpty()) {
			errorMsg.append("Start Date is empty::");

		}
		if (userId == null || userId.trim().isEmpty()) {
			errorMsg.append("User Id is empty::");
		}

		if(errorMsg.length() > 0){
 		   
		   	ReportException reportException = new ReportException();
		   
		   	reportException.setDeliveryMethod(req.getDeliveryMethod());
		   	reportException.setEmailAddress(req.getEmailAddress());
		   	reportException.setEndDate(req.getEndDate());
		   	reportException.setErrorCode(Constants.REQUEST_PARAMETERS_MISSING_ERROR_CODE);
		   	reportException.setErrorMessage(errorMsg.toString());
		   	reportException.setStartDate(req.getStartDate());
		   	reportException.setUserID(req.getUserID());
		   	
		   	reportException.setPoolName(req.getPoolName());
		   	
		   	//reportException.setErrorStatus(errorStatus);
		   	//reportException.setErrorType(errorType);
		   	
		   	throw reportException;
		   
	   }
		
	
	}
	
	

}
