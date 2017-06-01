package com.nationstar.reportengine.reportbuilder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.util.Constants;

@Component
public class ReportBuilderFactory {	

	@Autowired
	private ApplicationContext context;

	public ReportBuilder getInstance() {
		return context.getBean(ReportBuilderImpl.class);			
	}
}
