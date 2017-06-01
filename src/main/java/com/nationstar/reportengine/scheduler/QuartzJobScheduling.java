package com.nationstar.reportengine.scheduler;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.scheduler.job.SchedulerJob;
import com.nationstar.reportengine.scheduler.job.SchedulerJobProcessor;
import com.nationstar.reportengine.util.Constants;

@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:quartzscheduler/quartzscheduler.properties")
@Component
@ConditionalOnProperty(name = "scheduler.enable")
public class QuartzJobScheduling {

	private static final Logger log = LoggerFactory.getLogger(SchedulerJob.class);

	@Value("${schedulerReportRequest}")
	private String quartzSchedulingRequest;

	@Value("${scheduler.saveORupdate}")
	private boolean isSchedulerUpdate;

	@Autowired
	private Constants constants;

	@Autowired
	private Scheduler scheduler;

	@Autowired
	private SchedulerJobListener jobListener;

	private enum QUARTZREQUEST {
		OVERWRITE("overwrite"), JOBGROUP("jobGroup"), JOBIDENTITYKEY("jobIdentityKey"), TRIGGERIDENTITYKEY(
				"triggerIdentityKey"), CRONSCHEDULE("cronSchedule"), DURABLE("durable"), JOBDESCRIPTION("jobDescription"), REMOVEJOB("remove");

		private final String property;

		QUARTZREQUEST(String prop) {
			this.property = prop;
		}

		public String getProperty() {
			return property;
		}

	}

	public boolean doSchedule() throws SchedulerException, IOException {
		if (!constants.isSchedulerEnabled) {
			log.info("Scheduler has turned off now .For turn on set scheduler.enable as true in the app.properties.");
			return false;
		}
		this.scheduler.getListenerManager().addJobListener(jobListener);
		if (this.isSchedulerUpdate) {
			scheduleJobsAndTriggres();
			this.scheduler.start();
			log.info(
					"If you don't have any changes with your scheduler job then make the scheduler.saveORupdate property as false for the better performance. ");
		} else {
			this.scheduler.start();
			log.info(
					"If you have any changes with your scheduler job(create or update),make the scheduler.saveORupdate property as true, and for the job update, you have to make the job request property \"overwrite\" as true");
		}
		return true;
	}

	private void scheduleJobsAndTriggres() throws SchedulerException, IOException {
		JSONObject reqJsonObject = getScheduleJobRequestInputs();
		doProcessReqJsonObj(reqJsonObject);
	}

	private void doProcessReqJsonObj(JSONObject reqJsonObject) throws SchedulerException {
		for (Object key : reqJsonObject.keySet()) {
			JSONArray jsonArray = reqJsonObject.getJSONArray((String) key);
			JSONObject object = jsonArray.getJSONObject(0);
			if (!object.getBoolean(QUARTZREQUEST.REMOVEJOB.getProperty()))
				checkAndCreateSchedulerJob(object);
			else
				checkAndRemoveSchedulerJob(object);
		}
	}

	private void checkAndRemoveSchedulerJob(JSONObject jsonObject) {
		try {
			JobDetail detail = doCreateJob(jsonObject);
			if (this.scheduler.checkExists(detail.getKey())) {
				this.scheduler.deleteJob(detail.getKey());
			}
		} catch (SchedulerException se) {

		}

	}

	private void checkAndCreateSchedulerJob(JSONObject jsonObject) throws SchedulerException {

		JobDetail detail = doCreateJob(jsonObject);
		Trigger trigger = null;
		if (this.scheduler.checkExists(detail.getKey())
				&& !jsonObject.getBoolean(QUARTZREQUEST.OVERWRITE.getProperty())) {
			return;
		} else if (this.scheduler.checkExists(detail.getKey())
				&& jsonObject.getBoolean(QUARTZREQUEST.OVERWRITE.getProperty())) {
			trigger = doCreateTrigger(detail, jsonObject);
			Map<JobDetail, Set<? extends Trigger>> newJobAndTrigger = new HashMap<>();
			Set<Trigger> triggerSet = new HashSet<>();
			triggerSet.add(trigger);
			newJobAndTrigger.put(detail, triggerSet);
			this.scheduler.scheduleJobs(newJobAndTrigger, true);
			return;
		}
		trigger = doCreateTrigger(detail, jsonObject);
		this.scheduler.scheduleJob(detail, trigger);
	}

	private Trigger doCreateTrigger(JobDetail detail, JSONObject jsonObject) {
		return TriggerBuilder.newTrigger().forJob(detail)
				.forJob(jsonObject.getString(QUARTZREQUEST.JOBIDENTITYKEY.getProperty()),
						jsonObject.getString(QUARTZREQUEST.JOBGROUP.getProperty()))
				.withIdentity(jsonObject.getString(QUARTZREQUEST.TRIGGERIDENTITYKEY.getProperty()))
				.withSchedule(
						CronScheduleBuilder.cronSchedule(jsonObject.getString(QUARTZREQUEST.CRONSCHEDULE.getProperty()))
								.withMisfireHandlingInstructionIgnoreMisfires())
				.build();
	}

	private JobDetail doCreateJob(JSONObject jsonObject) {
		String requestJson = jsonObject.toString();
		return JobBuilder.newJob(SchedulerJob.class)
				.storeDurably(jsonObject.getBoolean(QUARTZREQUEST.DURABLE.getProperty()))
				.withIdentity(jsonObject.getString(QUARTZREQUEST.JOBIDENTITYKEY.getProperty()),
						jsonObject.getString(QUARTZREQUEST.JOBGROUP.getProperty()))
				.withDescription(jsonObject.getString(QUARTZREQUEST.JOBDESCRIPTION.getProperty()))
				.requestRecovery(false)
				.usingJobData(SchedulerJobProcessor.jobRequest, requestJson)
				.usingJobData(SchedulerJobProcessor.schedulerJobType,
						jsonObject.getString(SchedulerJobProcessor.schedulerJobType))
				.build();
	}

	private JSONObject getScheduleJobRequestInputs() throws IOException {
		InputStream inputStream = Thread.currentThread().getContextClassLoader()
				.getResourceAsStream(this.quartzSchedulingRequest);
		Scanner scanner = new Scanner(inputStream);
		String inputs = scanner.useDelimiter("\\A").next();
		scanner.close();
		inputStream.close();
		return new JSONObject(inputs);
	}

	public void destroy() throws SchedulerException {
		this.scheduler.shutdown();
	}

}
