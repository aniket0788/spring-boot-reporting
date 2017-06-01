package com.nationstar.reportengine.scheduler.job;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.quartz.JobExecutionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.util.DateUtil;
import com.nationstar.reportengine.util.MailUtil;
import com.nationstar.reportengine.util.ProcUtil;

@Component("disbursementScheduler")
public class DisbursementScheduledJobProcessor extends AbstractSchedulerJobProcessor implements SchedulerJobProcessor {

	private static final Logger log = LoggerFactory.getLogger(DisbursementScheduledJobProcessor.class);

	@Autowired
	private DateUtil dateUtil;
	
	@Autowired
	private ProcUtil procUtil;
	
	@Autowired
	private MailUtil mailUtil;

	@Override
	public void doProcess(JobExecutionContext context) {
		log.info("inside doProcess method of DisbursementScheduledJobProcessor !!!!");
		String request = (String) context.getJobDetail().getJobDataMap().get(SchedulerJobProcessor.jobRequest);
		try {
			String selectedDate[] = getDailySelectedDate();
			if (null == selectedDate || selectedDate.length < 2) {
				context.setResult(null);
				return;
			}
			String startDate = dateUtil.getYYYYMMDD_DateFormat(selectedDate[0]);
			String endDate = dateUtil.getYYYYMMDD_DateFormat(selectedDate[1]);

			Map<String, Object> procOutput = null;
			
			try {
				procOutput = procUtil.execDisbursementProc(startDate, endDate);
			} catch (Exception e) {
				log.error("Exception thrown at Disbursement procedure call "+e);
				mailUtil.sendMail("Disbursement Stored Procedure Execution FAILED","Stored Procedure Execution FAILED. Please contact CHIP support.");
				throw e;
			}
			
			if(!procOutput.get("STATUS").toString().equalsIgnoreCase("success"))
				throw new Exception("Procedure returned FAILURE status");
			else
			{
				log.info("Disbursement Stored Procedure is executed successfuly !!!");

				log.info("Runnig job for all the disbursement reports...");
				JSONObject jobRequestData = new JSONObject(request);
				String reportName = jobRequestData.getString("reportName");
				String taskId = jobRequestData.getString("taskId");
				Map<String, Object> result = new HashMap<String, Object>();

				String[] tasks = taskId.split(",");
				String[] exportFormats = jobRequestData.getString("reportExportFormat").split(",");

				for (int index=0;index<tasks.length;index++) {

					JSONObject requestData = null;

					requestData = new JSONObject();
					requestData.put("poolName", jobRequestData.getString("poolName"));
					requestData.put("deliveryMethod", jobRequestData.getString("deliveryMethod"));
					requestData.put("emailAddress", jobRequestData.getString("emailAddress"));
					requestData.put("reportExportFormat", exportFormats[index]);
					requestData.put("userID", context.getFireInstanceId());
					ReportRequest req = getReportRequest(requestData);
					req.setStartDate(selectedDate[0]);
					req.setEndDate(selectedDate[1]);
					ReportResponse reportResponse=null;
					try {
						reportResponse = this.schedulerReportService.generateReport(reportName, tasks[index], req);
					} catch (Exception reportException) {
						log.error("Exception occurred for report: "+reportName+tasks[index],reportException);
					}
					result.put(jobRequest, req);
					result.put(jobResponse, reportResponse);

				}
				log.info("disbursement reports job executed !!!");
				context.setResult(result);
			}
		} catch (DataAccessException de) {
			log.error("DataAccessException is thrown when Disbursement Stored Procedure is called", de);
			throw de;
		}catch (Exception e) {
			log.error("Exception is thrown when Disbursement Stored Procedure is called", e);
			mailUtil.sendMail("Disbursement Stored Procedure Execution FAILED","Stored Procedure call FAILED. Please contact CHIP support.");
		}

	}

}
