package com.nationstar.reportengine.util;

import java.sql.Timestamp;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.dao.ReportStatusRepository;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportResponse;

@Component
public class ResponseBuilderUtil {

	private static final Logger log = LoggerFactory.getLogger(ResponseBuilderUtil.class);

	@Autowired
	private ReportStatusRepository reportStatusRepository;

	public ReportResponse buildSuccessResponse(ReportDTO repDTO) {
		ReportResponse response = new ReportResponse();

		response.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
		response.setEmailAddress(repDTO.getReportReq().getEmailAddress());
		response.setStartDate(repDTO.getReportReq().getStartDate());
		response.setEndDate(repDTO.getReportReq().getEndDate());
		response.setUserID(repDTO.getReportReq().getUserID());
		response.setReponseCode("200");

		response.setPoolName(repDTO.getReportReq().getPoolName()== null ? "":repDTO.getReportReq().getPoolName());
		String filePath = repDTO.getReportStatus().getReportGeneratedFileName();
		//response.setDownloadedFile(filePath);
		if ("".equals(filePath) || null == filePath) {
			response.setResponseMessage("No records found for the selected date range");
		}else{
			response.setResponseMessage("Report Processing completed Successfully ! Report is available at "+ filePath);
		}
		repDTO.getReportStatus().setStatus(Constants.SUCCESS);
		repDTO.getReportStatus().setReportProcessingEndTime((new Timestamp(System.currentTimeMillis())));
		try {
			reportStatusRepository.save(repDTO.getReportStatus());
			log.info("Report status has been successfully mapped !");
		} catch (Exception e) {
			log.error("ERROR occurred while persisting the report status to the Database", e);
		}
		// update report status

		return response;
	}


	public ReportResponse addReportDataToResponse(ReportResponse response, List<String[]> data ){
		response.setReportData(data);		
		return response;
	}

	public ReportResponse buildExceptionResponse(ReportException exception, ReportDTO repDTO) {

		ReportResponse response = new ReportResponse();

		response.setDeliveryMethod(exception.getDeliveryMethod());
		response.setEmailAddress(exception.getEmailAddress());
		response.setStartDate(exception.getStartDate());
		response.setEndDate(exception.getEndDate());
		response.setUserID(exception.getUserID());

		response.setReponseCode(exception.getErrorCode());
		//String str = exception.getErrorStackMsg() == null ? "" : exception.getErrorStackMsg();
		//response.setResponseMessage(exception.getErrorMessage() + ". " + str);
		response.setResponseMessage(exception.getErrorMessage() != null ? exception.getErrorMessage() : "DATA ISSUE... Report Processing FAILED ! Please contact support");
		response.setPoolName(exception.getPoolName());

		repDTO.getReportStatus().setStatus(Constants.FAILURE);
		repDTO.getReportStatus().setReportProcessingEndTime((new Timestamp(System.currentTimeMillis())));
		try {
			reportStatusRepository.save(repDTO.getReportStatus());
			log.info("Report failure status has been mapped to Database !");
		} catch (Exception e) {
			log.error("ERROR in persisting the report status to the Database", e);
		}
		// update report status

		return response;
	}


	public ReportResponse buildGenericExceptionResponse(Exception exception) {

		ReportResponse response = new ReportResponse();
		response.setReponseCode("405");
		String str = exception.getLocalizedMessage() == null ? "" : exception.getLocalizedMessage();
		response.setResponseMessage("Generic Exception Occured" + ". " + str );


		return response;
	}



}
