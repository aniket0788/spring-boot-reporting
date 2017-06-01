package com.nationstar.reportengine.scheduler.job;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.quartz.JobExecutionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;

@Component("dailyScheduler")
public class DailyScheduledJobProcessor extends AbstractSchedulerJobProcessor implements SchedulerJobProcessor {

	private static final Logger log = LoggerFactory.getLogger(DailyScheduledJobProcessor.class);

	@Override
	public void doProcess(JobExecutionContext context) {
		log.info("inside doProcess method of DailyScheduledJobProcessor!!!!!!!");
		String request = (String) context.getJobDetail().getJobDataMap().get(SchedulerJobProcessor.jobRequest);
		JSONObject jobRequestData = new JSONObject(request);
		String reportName = jobRequestData.getString("reportName"), taskId = jobRequestData.getString("taskId");

		String selectedDate[] = getDailySelectedDate();
		if (null == selectedDate || selectedDate.length < 2) {
			context.setResult(null);
			return;
		}
		JSONObject requestData = null;
		Map<String, Object> result = new HashMap<>();
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
				ReportResponse reportResponse = this.schedulerReportService.generateReport(reportName, taskId, req);
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
