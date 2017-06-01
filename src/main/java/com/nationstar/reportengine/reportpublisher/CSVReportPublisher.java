package com.nationstar.reportengine.reportpublisher;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.service.ReportsService;
import com.nationstar.reportengine.util.CSVUtils;
import com.nationstar.reportengine.util.Constants;
import com.nationstar.reportengine.util.ResponseBuilderUtil;

@Component
public class CSVReportPublisher implements ReportPublisher{
	
	private static final Logger log = LoggerFactory.getLogger(CSVReportPublisher.class);
	
	@Autowired
	private CSVUtils csvUtils;
	
	@Autowired 
	private ResponseBuilderUtil responseBuilder;
	
	@Autowired 
	private Constants constants;
	

	@Autowired
	private ReportsService reportService;
	

	@Override
	public ReportResponse publishReport(ReportDTO repDTO) {
		
		// TODO Auto-generated method stub
		ReportResponse response = null;
		ReportException reportException = null;
		String filePath = reportService.getReportDownloadLoaction(repDTO);
		FileWriter writer = null;
		try{
			writer = csvUtils.getFileWriter(filePath);
			//csvUtils.writeToCVS(repDTO.getMappedOutputData(), writer);
			csvUtils.writeToCVS(repDTO, writer);  // repDTO should contain MappedOutputData
			response = responseBuilder.buildSuccessResponse(repDTO);
		}catch(IOException io) {
			reportException = new ReportException();
			log.error("<CSVReportPublisher -> publishReport >  IOException occurred!",io);
			
			reportException.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
			reportException.setEmailAddress(repDTO.getReportReq().getEmailAddress());
			reportException.setEndDate(repDTO.getReportReq().getEndDate());
			reportException.setErrorMessage(Constants.PROBLEM_IN_CREATING_A_FILE_ERROR_MESSAGE);
			reportException.setErrorCode(Constants.PROBLEM_IN_CREATING_A_FILE_ERROR_CODE);
			reportException.setErrorStackMsg(io.getLocalizedMessage());
			//reportException.setErrorStatus("");
			reportException.setErrorType(Constants.FILE_CREATION_PROBLEM);
			reportException.setUserID(repDTO.getReportReq().getUserID());
			reportException.setStartDate(repDTO.getReportReq().getStartDate());
			
			response = responseBuilder.buildExceptionResponse(reportException,repDTO);
			
			throw reportException;
			
		}catch(Exception exp){

			if(exp instanceof ReportException){
				reportException = (ReportException)exp;
			} else {
				reportException = new ReportException();
			}
			
			log.error("<CSVReportPublisher -> publishReport >  exception occurred!",exp);
			reportException.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
			reportException.setEmailAddress(repDTO.getReportReq().getEmailAddress());
			reportException.setEndDate(repDTO.getReportReq().getEndDate());
			reportException.setErrorMessage(Constants.PROBLEM_IN_WRITING_TO_A_CSV_FILE_ERROR_MESSAGE);
			reportException.setErrorCode(Constants.PROBLEM_IN_WRITING_TO_A_CSV_FILE_ERROR_CODE);
			reportException.setErrorStackMsg(exp.getLocalizedMessage() +  " " + exp.getMessage());
			//reportException.setErrorStatus("");
			reportException.setErrorType("File Writing Problem");
			reportException.setUserID(repDTO.getReportReq().getUserID());
			reportException.setStartDate(repDTO.getReportReq().getStartDate());
			
			response = responseBuilder.buildExceptionResponse(reportException,repDTO);
			
			throw reportException;
		}
		finally{
			 try {
				 if(null!=writer)
				writer.close();
			} catch (IOException e) {
				 log.error("Filewriter closing error",e);
			}
		}
		
		return response;
		
	}

}
