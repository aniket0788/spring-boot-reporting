package com.nationstar.reportengine.reportpublisher;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.util.CSVUtils;
import com.nationstar.reportengine.util.Constants;
import com.nationstar.reportengine.util.ResponseBuilderUtil;

@Component
public class JSONReportPublisher implements ReportPublisher {	


	
	private static final Logger log = LoggerFactory.getLogger(JSONReportPublisher.class);
	
	@Autowired
	private CSVUtils csvUtils;
	
	@Autowired 
	private ResponseBuilderUtil responseBuilder;
	
	@Autowired 
	private Constants constants;
	


	@Override
	public ReportResponse publishReport(ReportDTO repDTO) {
		
		// TODO Auto-generated method stub
		ReportResponse response = null;
		ReportException reportException = null;
		
		try{						
			
			response = responseBuilder.buildSuccessResponse(repDTO);
			response = responseBuilder.addReportDataToResponse(response, csvUtils.writeToList(repDTO));
			
					
		
		}catch(IOException io) {

			reportException = new ReportException();
			log.info("<JSONReportPublisher -> publishReport >  exception occurred!");
			
			reportException.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
			reportException.setEmailAddress(repDTO.getReportReq().getEmailAddress());
			reportException.setEndDate(repDTO.getReportReq().getEndDate());
			reportException.setErrorMessage(Constants.PROBLEM_IN_WRITING_DATA_TO_JSON_ERROR_MESSAGE);
			reportException.setErrorCode(Constants.PROBLEM_IN_WRITING_DATA_TO_JSON);
			reportException.setErrorStackMsg(io.getLocalizedMessage());
			//reportException.setErrorStatus("");
			reportException.setErrorType("Data to list Creation Problem");
			reportException.setUserID(repDTO.getReportReq().getUserID());
			reportException.setStartDate(repDTO.getReportReq().getStartDate());
			
			throw reportException;
			
		}catch(Exception exp){

			if(exp instanceof ReportException){
				reportException = (ReportException)exp;
			} else {
				reportException = new ReportException();
			}
			
			reportException.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
			reportException.setEmailAddress(repDTO.getReportReq().getEmailAddress());
			reportException.setEndDate(repDTO.getReportReq().getEndDate());
			reportException.setErrorMessage(Constants.PROBLEM_IN_WRITING_DATA_TO_JSON_ERROR_MESSAGE);
			reportException.setErrorCode(Constants.PROBLEM_IN_WRITING_DATA_TO_JSON);
			reportException.setErrorStackMsg(exp.getLocalizedMessage() +  " " + exp.getMessage());
			//reportException.setErrorStatus("");
			reportException.setErrorType("Data to list Creation Problem");
			reportException.setUserID(repDTO.getReportReq().getUserID());
			reportException.setStartDate(repDTO.getReportReq().getStartDate());
			
			throw reportException;
		}
		
		return response;
		
	}


}
