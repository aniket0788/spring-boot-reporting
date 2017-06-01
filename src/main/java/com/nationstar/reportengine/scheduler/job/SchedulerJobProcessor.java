package com.nationstar.reportengine.scheduler.job;

import org.quartz.JobExecutionContext;

public interface SchedulerJobProcessor {

	String jobRequest = "jobRequest";
	String schedulerJobType = "schedulerJobType";
	String jobResponse="jsbResponse";

	void doProcess(JobExecutionContext context);

}
