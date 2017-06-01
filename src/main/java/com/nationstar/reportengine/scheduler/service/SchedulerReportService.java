package com.nationstar.reportengine.scheduler.service;

import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;

public interface SchedulerReportService {

	public ReportResponse generateReport(String reportName, String taskId, ReportRequest req);

}
