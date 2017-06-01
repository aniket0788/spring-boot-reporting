package com.nationstar.reportengine.scheduler;

import java.io.IOException;
import java.util.Properties;

import javax.sql.DataSource;

import org.quartz.SchedulerException;
import org.quartz.spi.JobFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.PropertiesFactoryBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

@Configuration
@ConditionalOnProperty(name="scheduler.enable")
public class SchedulerConfiguration {

	@Autowired
	private QuartzJobScheduling quartzJobScheduling;

	@Bean
	public SchedulerFactoryBean schedulerFactoryBean(DataSource dataSource, JobFactory jobFactory)
			throws IOException, SchedulerException {
		SchedulerFactoryBean factory = new SchedulerFactoryBean();
		factory.setDataSource(dataSource);
		factory.setJobFactory(jobFactory);
		factory.setQuartzProperties(quartzProperties());
		factory.setOverwriteExistingJobs(true);
		factory.setAutoStartup(false);
		return factory;
	}

	public Properties quartzProperties() throws IOException {
		PropertiesFactoryBean propertiesFactoryBean = new PropertiesFactoryBean();
		propertiesFactoryBean.setLocation(new ClassPathResource("quartzscheduler/quartzscheduler.properties"));
		propertiesFactoryBean.afterPropertiesSet();
		return propertiesFactoryBean.getObject();
	}

	@Bean
	public JobFactory jobFactory(ApplicationContext applicationContext) {
		SchedulerContextLoader jobFactory = new SchedulerContextLoader();
		jobFactory.setApplicationContext(applicationContext);
		return jobFactory;
	}
	@Bean
	public boolean loadScheduler() throws SchedulerException, IOException{
		return this.quartzJobScheduling.doSchedule();
	}
}
