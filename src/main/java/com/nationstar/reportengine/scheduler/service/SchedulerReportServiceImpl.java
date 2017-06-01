package com.nationstar.reportengine.scheduler.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.service.ReportsService;

@Service
public class SchedulerReportServiceImpl implements SchedulerReportService {

	@Autowired
	private ReportsService reportService;

	@Override
	public ReportResponse generateReport(String reportName, String taskId, ReportRequest req) {
		ReportDTO repDTO = this.reportService.createReportDTO(req, reportName, taskId);
		ReportResponse result = this.reportService.generateAndPublishReport(repDTO);

		return result;
	}

}
