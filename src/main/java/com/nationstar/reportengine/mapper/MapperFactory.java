package com.nationstar.reportengine.mapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class MapperFactory {

	@Autowired
	private ApplicationContext context;

	public ReportMapper getInstance(String mapperClassName) {

		ReportMapper mapper = null;

		mapper = (ReportMapper) context.getBean(mapperClassName);

		return mapper;

	}

	public ArgumentMapper getArgumentMapper(String mapperClassName) {

		ArgumentMapper mapper = null;

		mapper = (ArgumentMapper) context.getBean(mapperClassName);

		return mapper;

	}
	
	public ReportDownloadLocationMapper getReportDownloadLocationMapper(String mapperClassName) {

		ReportDownloadLocationMapper mapper = null;

		mapper = (ReportDownloadLocationMapper) context.getBean(mapperClassName);

		return mapper;

	}
	

}
