package com.nationstar.reportengine.reportpublisher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class ReportPublisherFactory {

	@Autowired
	private ApplicationContext context;

	public ReportPublisher getInstance(String publishType) {
		if (publishType.equalsIgnoreCase("CSV")) {
			return context.getBean(CSVReportPublisher.class);

		} else if (publishType.equalsIgnoreCase("JSON")) {
			return context.getBean(JSONReportPublisher.class);

		} else if (publishType.equalsIgnoreCase("XML")) {
			return context.getBean(XMLReportPublisher.class);

		} else if (publishType.equalsIgnoreCase("TXT")) {
			return context.getBean(TEXTReportPublisher.class);

		} 
		else

		return context.getBean(JSONReportPublisher.class);

	}

}
