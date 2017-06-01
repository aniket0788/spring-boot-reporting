package com.nationstar.reportengine.controller;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.service.ReportsService;
import com.nationstar.reportengine.util.ReportRequestValidator;

@RestController
@RequestMapping("/{reportName}")
public class ReportsEngineController {

	private static final Logger log = LoggerFactory.getLogger(ReportsEngineController.class);

	@Autowired
	private ReportsService reportService;

	@Autowired
	private ReportRequestValidator  reqValidator;

	@RequestMapping(value = "/{taskId}", method = RequestMethod.POST)
	public List<Map<String, Object>> getReport(@PathVariable String reportName, @PathVariable String taskId, @RequestBody ReportRequest req, HttpServletResponse response) throws Exception{

		ReportDTO repDTO = this.reportService.createReportDTO(req, reportName, taskId);
		ReportDTO repOutputDTO = this.reportService.generateReport(repDTO, "Download");

		return repOutputDTO.getMappedOutputData();
	}

	@RequestMapping(value = "/{taskId}/generate", method = RequestMethod.POST)
	public ReportResponse generateReport(@PathVariable String reportName, @PathVariable String taskId, @RequestBody ReportRequest req, HttpServletResponse response) throws Exception{


		// validate the request
		// if it doesn't throw exception then its good to move forward
		reqValidator.validate(req);

		ReportDTO repDTO	 		= this.reportService.createReportDTO(req, reportName, taskId);
		repDTO.setReportType("generated");
		ReportResponse result 	= this.reportService.generateAndPublishReport(repDTO);

		return result;
	}


	@RequestMapping(value = "/{taskId}/download", method = RequestMethod.POST)
	public void downloadReport(@PathVariable String reportName, @PathVariable String taskId, @RequestBody ReportRequest req, HttpServletResponse response) throws Exception{
		// validate the request
		// if it doesn't throw exception then its good to move forward
		reqValidator.validate(req);

		ReportDTO repDTO	 		= this.reportService.createReportDTO(req, reportName, taskId);
		repDTO.setReportType("downloaded");
		ReportResponse result 	= this.reportService.generateAndPublishReport(repDTO);

		String generatedFileName = repDTO.getReportStatus().getReportGeneratedFileName();
		response.setContentType("text/csv");

		if (!("".equals(generatedFileName) || null == generatedFileName)) {

			log.debug("file generated successfully now going to download the file  " + result.toString());
			// Get your file stream from wherever.
			InputStream myStream = new FileInputStream(generatedFileName);
			String fileName = repDTO.getReportFileName();

			// Set the content type and attachment header.
			response.addHeader("Content-disposition", "attachment;filename="+fileName);
			response.addHeader("filename", fileName);

			// Copy the stream to the response's output stream.
			IOUtils.copy(myStream, response.getOutputStream());
			response.flushBuffer();
			if(null != myStream ) myStream.close(); 
		}
	}

	@RequestMapping(value="download", method=RequestMethod.GET)
	public void getDownload(HttpServletResponse response) throws Exception {

		// Get your file stream from wherever.
		InputStream myStream = new FileInputStream("C:\\chipReports\\report.csv");

		// Set the content type and attachment header.
		response.addHeader("Content-disposition", "attachment;filename=myfilename.csv");
		response.setContentType("txt/csv");

		// Copy the stream to the response's output stream.
		IOUtils.copy(myStream, response.getOutputStream());
		response.flushBuffer();
	}

}
