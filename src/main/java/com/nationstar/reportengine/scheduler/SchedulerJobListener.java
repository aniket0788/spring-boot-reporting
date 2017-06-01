package com.nationstar.reportengine.scheduler;

import java.sql.Date;
import java.util.logging.Logger;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobListener;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class SchedulerJobListener implements JobListener {

	private static final Logger log = Logger.getLogger(SchedulerJobListener.class.getName());
	private static final String logSql = "insert into IRQRTZ_FIRED_JOBLOGS(FIRE_UNIQUEID,SCHED_NAME,JOB_NAME,JOB_GROUP,TRIGGER_NAME,TRIGGER_GROUP,FIRE_TIME,STATE,LOG_DETAILS,CREATEDON)VALUES(?,?,?,?,?,?,?,?,?,systimestamp)";

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return "SchedulerJobListener";
	}

	@Override
	public void jobToBeExecuted(JobExecutionContext context) {
		// TODO Auto-generated method stub
	}

	@Override
	public void jobExecutionVetoed(JobExecutionContext context) {

	}

	@Override
	public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException) {
		log.info("jobWasExecuted  " + context.getJobDetail().getKey() + " RESULT " + context.getResult());
		Object[] objArg = new Object[9];
		objArg[0] = context.getFireInstanceId();
		try {
			objArg[1] = context.getScheduler().getSchedulerName();
		} catch (SchedulerException se) {
			objArg[1] = null;
		}
		objArg[2] = context.getJobDetail().getKey().getName();
		objArg[3] = context.getJobDetail().getKey().getGroup();
		objArg[4] = context.getTrigger().getKey().getName();
		objArg[5] = context.getTrigger().getKey().getGroup();
		objArg[6] = new Date(context.getFireTime().getTime());
		objArg[7] = context.getResult();
		if (jobException == null)
			objArg[8] = "null";
		else
			objArg[8] = jobException.getMessage();
		jdbcTemplate.update(logSql, objArg);

	}

}
