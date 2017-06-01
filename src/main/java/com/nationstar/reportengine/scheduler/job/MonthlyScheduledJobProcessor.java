package com.nationstar.reportengine.scheduler.job;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.quartz.JobExecutionContext;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;

@Component("monthlyScheduler")
public class MonthlyScheduledJobProcessor extends AbstractSchedulerJobProcessor implements SchedulerJobProcessor {

	@Override
	public void doProcess(JobExecutionContext context) {
		String request = (String) context.getJobDetail().getJobDataMap().get(SchedulerJobProcessor.jobRequest);
		JSONObject jobRequestData = new JSONObject(request);
		String reportName = jobRequestData.getString("reportName"), taskId = jobRequestData.getString("taskId");
		JSONObject requestData = null;
		Map<String, Object> result = new HashMap<>();
		String[] selectedDate = getMonthlySelectedDate();
		String poolName = (String) jobRequestData.get("poolName");
		if (null != poolName && !poolName.isEmpty()) {
			String[] poolNames = poolName.split(",");
			for (String poolname : poolNames) {
				requestData = new JSONObject();
				requestData.put("poolName", poolname);
				requestData.put("deliveryMethod", jobRequestData.getString("deliveryMethod"));
				requestData.put("emailAddress", jobRequestData.getString("emailAddress"));
				requestData.put("reportExportFormat", jobRequestData.getString("reportExportFormat"));
				requestData.put("userID", context.getFireInstanceId());
				ReportRequest req = getReportRequest(requestData);
				req.setStartDate(selectedDate[0]);
				req.setEndDate(selectedDate[1]);
				System.out.println("Calling Report Service from MonthlyScheduledJobProcessor for Job data ::::" +jobRequestData.toString()
				+ " with request ::::" +req.toString() );
				ReportResponse reportResponse = this.schedulerReportService.generateReport(reportName, taskId, req);
				System.out.println("Response from Report Service in  MonthlyScheduledJobProcessor for Job data ::::" +jobRequestData.toString()
				+ " with request ::::" +req.toString()  + " Response data :::" +reportResponse.toString());
				
				result.put(jobRequest, req);
				result.put(jobResponse, reportResponse);
			}
		} else {
			ReportRequest req = getReportRequest(jobRequestData);
			req.setStartDate(selectedDate[0]);
			req.setEndDate(selectedDate[1]);
			ReportResponse reportResponse = this.schedulerReportService.generateReport(reportName, taskId, req);
			result.put(jobRequest, req);
			result.put(jobResponse, reportResponse);
		}
		context.setResult(result);
	}
}
