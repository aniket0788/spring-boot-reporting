package com.nationstar.reportengine.scheduler.job;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class SchedulerJobFactory {

	@Autowired
	private ApplicationContext context;

	public SchedulerJobProcessor getInstance(String reportServiceName) {
		return (SchedulerJobProcessor) context.getBean(reportServiceName);

	}
}
