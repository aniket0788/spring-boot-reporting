package com.nationstar.reportengine.scheduler.job;

import java.util.Date;
import java.util.Map;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.util.Constants;
import com.nationstar.reportengine.util.MailUtil;

public class SchedulerJob implements Job {

	@Autowired
	private SchedulerJobFactory schedulerJobFactory;

	@Autowired
	private Constants constants;
	
	@Autowired
	private MailUtil mailUtil;

	private static final Logger log = LoggerFactory.getLogger(SchedulerJob.class);

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		try {
			if (!constants.isSchedulerEnabled) {
				log.info("Scheduler has turned off now .For turn on set scheduler.enable as true in app.properties.");
				context.setResult("Scheduler has turned off");
				return;
			}
			String schedulerType = context.getJobDetail().getJobDataMap()
					.getString(SchedulerJobProcessor.schedulerJobType);
			SchedulerJobProcessor jobProcessor = schedulerJobFactory.getInstance(schedulerType);
			jobProcessor.doProcess(context);
			@SuppressWarnings("unchecked")
			Map<String, Object> responseData = (Map<String, Object>) context.getResult();
			if (null == responseData || responseData.isEmpty()) {
				context.setResult("SUCCESS");
				throw new Exception(
						"job Has skipped because of Holiyday " + new Date(System.currentTimeMillis()).toString());
			}
			ReportRequest req = (ReportRequest) responseData.get(SchedulerJobProcessor.jobRequest);
			ReportResponse resp = (ReportResponse) responseData.get(SchedulerJobProcessor.jobResponse);
			log.info(schedulerType + " : " + resp.getResponseMessage() + " for the period of " + req.getStartDate()
					+ " to " + req.getEndDate());
			if (!resp.getReponseCode().equalsIgnoreCase("200")) {
				context.setResult("FAILED");
				throw new JobExecutionException(resp.getResponseMessage());
			}
			context.setResult("SUCCESS");
		} catch (Throwable e) {
			log.error("Scheduler job throws error " + e.getMessage() + "  job name " + context.getJobDetail().getKey()
					+ " triggered at " + new Date(System.currentTimeMillis()).toString() + " next tigger time "
					+ context.getNextFireTime() + " and previous Triggered time " + context.getPreviousFireTime());
			JobExecutionException executionException = new JobExecutionException(e);
			executionException.setRefireImmediately(false);
			context.setResult("FAILED");
			mailUtil.sendMail("Scheduler job "+context.getJobDetail().getKey()+" FAILED", context.getJobDetail().getKey()+" triggered at "+new Date(System.currentTimeMillis()).toString()+" FAILED.\nPlease contact CHIP support.");
			throw executionException;
		}
	}

}
