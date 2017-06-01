package com.nationstar.reportengine.reportpublisher;

import static com.nationstar.reportengine.util.Constants.FILE_CREATION_PROBLEM;
import static com.nationstar.reportengine.util.Constants.PROBLEM_IN_CREATING_A_FILE_ERROR_CODE;
import static com.nationstar.reportengine.util.Constants.PROBLEM_IN_CREATING_A_FILE_ERROR_MESSAGE;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.service.ReportsService;
import com.nationstar.reportengine.util.ResponseBuilderUtil;
import com.nationstar.reportengine.util.TEXTUtil;


@Component
public class TEXTReportPublisher implements ReportPublisher {

	private static final Logger log = LoggerFactory.getLogger(TEXTReportPublisher.class);

	@Autowired
	private TEXTUtil textUtil;

	@Autowired 
	private ResponseBuilderUtil responseBuilder;

	@Autowired
	private ReportsService reportService;

	@Override
	public ReportResponse publishReport(ReportDTO repDTO) {
		ReportResponse response = null;
		ReportException reportException = null;

		try{
			String filePath = reportService.getReportDownloadLoaction(repDTO);
			boolean fileCreated = textUtil.generateNACHA(repDTO, filePath);
			if(!fileCreated){
				repDTO.getReportStatus().setReportGeneratedFileName("");    // for 0 records,file is not created
			}
			response = responseBuilder.buildSuccessResponse(repDTO);

		}catch(Exception e) {

			if(e instanceof ReportException){
				reportException = (ReportException)e;
			} else {
				reportException = new ReportException();
			}

			log.error("<TXTReportPublisher -> publishReport >  exception occurred!",e);

			reportException.setDeliveryMethod(repDTO.getReportReq().getDeliveryMethod());
			reportException.setEmailAddress(repDTO.getReportReq().getEmailAddress());
			reportException.setEndDate(repDTO.getReportReq().getEndDate());
			reportException.setErrorMessage(PROBLEM_IN_CREATING_A_FILE_ERROR_MESSAGE);
			reportException.setErrorCode(PROBLEM_IN_CREATING_A_FILE_ERROR_CODE);
			reportException.setErrorStackMsg(e.getLocalizedMessage());
			reportException.setErrorType(FILE_CREATION_PROBLEM);
			reportException.setUserID(repDTO.getReportReq().getUserID());
			reportException.setStartDate(repDTO.getReportReq().getStartDate());

			response = responseBuilder.buildExceptionResponse(reportException,repDTO);

			throw reportException;
		}	

		return response;
	}

}
