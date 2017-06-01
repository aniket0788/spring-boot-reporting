package com.nationstar.reportengine.service;

import static org.mockito.Matchers.contains;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportMetaData;
import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.model.ReportStatus;
import com.nationstar.reportengine.reportbuilder.ReportBuilder;
import com.nationstar.reportengine.reportbuilder.ReportBuilderFactory;
import com.nationstar.reportengine.mapper.MapperFactory;
import com.nationstar.reportengine.reportpublisher.ReportPublisher;
import com.nationstar.reportengine.reportpublisher.ReportPublisherFactory;
import com.nationstar.reportengine.util.Constants;
import com.nationstar.reportengine.util.DateUtil;
import com.nationstar.reportengine.util.SQLUtil;
import org.springframework.core.env.Environment;
import com.nationstar.reportengine.util.Constants;

@Component
public class ReportsService {

	private static final Logger log = LoggerFactory.getLogger(ReportsService.class);

	@Autowired
	private ReportBuilderFactory reportFactory;
	@Autowired
	private ReportPublisherFactory publishFactory;
	@Autowired
	private SQLUtil sqlUtil;
	@Autowired
	private DateUtil dateUtil;
	@Autowired 
	private Constants constants;
	@Autowired
	private MapperFactory mapperFactory;
	@Autowired
	private Environment env;


	/**
	 * This method is to generateReport based on Report Request parameters, if
	 * the exportFormat is CSV it will export to CSV file on the local drive
	 * 
	 * @param request
	 * @param reportName
	 * @param taskID
	 * @return
	 * @throws Exception
	 */

	public ReportResponse generateAndPublishReport(ReportDTO repDTO) {
		// TODO Auto-generated method stub

		ReportDTO repOutputDTO = this.generateReport(repDTO, null);

		ReportPublisher publisher = publishFactory.getInstance(repOutputDTO.getReportReq().getReportExportFormat());
		ReportResponse reportResponse = publisher.publishReport(repOutputDTO);

		return reportResponse;

	}

	/**
	 * This method is to generateReport based on Report Request parameters,
	 * downloadType is hardcoded to download should return the json back
	 * 
	 * @param request
	 * @param reportName
	 * @param taskID
	 * @return
	 * @throws Exception
	 */

	public ReportDTO generateReport(ReportDTO repDTO, String downloadType) {

		List<Map<String, Object>> mappedResultSet = null;

		//ReportBuilder repBuilder = reportFactory.getInstance(repDTO.getReportStatus().getReportName());
		ReportBuilder repBuilder = reportFactory.getInstance();
		repBuilder.buildReport(repDTO);
		repBuilder.buildReportName(repDTO, repDTO.getReportStatus().getReportName(),
				repDTO.getReportStatus().getTaskId());
		mappedResultSet = repBuilder.MapReportData(repDTO);
		repDTO.setMappedOutputData(mappedResultSet);

		return repDTO;

	}

	/**
	 * Call this method only once during the lifeCycle of the request to hold
	 * all the necessary data required to be held in memory during the
	 * processing. GC will collect the data once the request is processed and no
	 * references to the objects are available in the next GC cycle
	 * 
	 * @param req
	 * @param reportName
	 * @param taskID
	 * @return
	 */
	public ReportDTO createReportDTO(ReportRequest req, String reportName, String taskId) {

		ReportDTO repDTO = new ReportDTO();
		repDTO.setReportReq(req);
		ReportStatus repStatus = new ReportStatus();
		repStatus.setReportProcessingBeginTime((new Timestamp(System.currentTimeMillis())));
		String reportingMonth = dateUtil.getYearMonth(repDTO.getReportReq().getEndDate());
		repStatus.setTaskId(taskId);
		repStatus.setReportType(repDTO.getReportReq().getReportExportFormat());
		repStatus.setReportingMonth(reportingMonth);
		repStatus.setReportStartDate(dateUtil.convertToSQLDate(repDTO.getReportReq().getStartDate()));
		repStatus.setReportEndDate(dateUtil.convertToSQLDate(repDTO.getReportReq().getEndDate()));
		repStatus.setRequestedByUserId(repDTO.getReportReq().getUserID());
		repStatus.setRequestedReport(reportName);
		repDTO.setReportStatus(repStatus);

		// setting the report meta data from JSON file...
		// repDTO.setReportMetaData(loadReportMetaData(reportName, taskId));
		repDTO.setReportMetaData(loadReportMetaData(reportName, taskId, req));
		repStatus.setReportName(repDTO.getReportMetaData().getReportFileName());
		return repDTO;
	}

	private ReportMetaData loadReportMetaData(String reportName, String taskId, ReportRequest req) {

		ReportMetaData reportMetaData = null;
		int index = reportName.lastIndexOf('_')+1;
		String dirPath = reportName.substring(0,index)+"Reports";
		String metaDataJsonString = sqlUtil.readStringFromFile(dirPath+File.separator+reportName + taskId + ".json",req);

		try {

			reportMetaData = new Gson().fromJson(metaDataJsonString, ReportMetaData.class);

		} catch (JsonSyntaxException e) {

			ReportException reportException = new ReportException();

			reportException.setErrorCode(Constants.INVALID_JSON_FORMAT_ERROR_CODE);
			reportException.setErrorMessage(Constants.INVALID_JSON_FORMAT_ERROR_MESSAGE);			
			reportException.setErrorStatus("");
			reportException.setErrorType("Parser");
			reportException.setErrorStackMsg("There is problem in JSON syntax in fileName::  " +reportName + taskId+ ".json " + " :: " +e.getLocalizedMessage());

			reportException.setDeliveryMethod(req.getDeliveryMethod());
			reportException.setEmailAddress(req.getEmailAddress());
			reportException.setEndDate(req.getEndDate());
			reportException.setStartDate(req.getStartDate());
			reportException.setUserID(req.getUserID());


			throw reportException;


		}

		return reportMetaData;

	}

	public String getReportDownloadLoaction(ReportDTO repDTO) {
		String reportName = repDTO.getReportStatus().getRequestedReport() ;
		String taskId = repDTO.getReportStatus().getTaskId();
		String reportPath = null;
		if("downloaded".equalsIgnoreCase(repDTO.getReportType())){
			reportPath = mapperFactory.getReportDownloadLocationMapper("ReportDownloadLocationMapper")
					.MapDownloadLoaction("Download_Reports_Path");
			try {
				Files.createDirectories(Paths.get(reportPath));
			} catch (IOException e) {
				log.error("Path creation FAILED for downloading reports !!",e);
			}
		}
		else{

			if(null != env && env.getActiveProfiles().length > 0) {
				String reportPathKey = reportName + taskId + "_" + env.getActiveProfiles()[0];

				reportPath = mapperFactory.getReportDownloadLocationMapper("ReportDownloadLocationMapper")
						.MapDownloadLoaction(reportPathKey);
			}
			if (reportPath == null || reportPath.isEmpty()) {
				reportPath = getDefaultReportDownloadLoaction(repDTO);
			}
		}
		
		reportPath = reportPath.concat(repDTO.getReportStatus().getReportGeneratedFileName()); //concat the absolutePath
		repDTO.getReportStatus().setReportGeneratedFileName(reportPath);
		return reportPath;
	}

	public String getDefaultReportDownloadLoaction(ReportDTO repDTO) {
		//String generateReportfileName = repDTO.getReportStatus().getReportGeneratedFileName();
		return	constants.MECA_REPORT_BASEPATH;
	}

}
