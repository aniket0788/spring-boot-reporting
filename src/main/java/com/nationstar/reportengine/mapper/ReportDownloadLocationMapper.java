package com.nationstar.reportengine.mapper;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
@Component(value = "ReportDownloadLocationMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/ReportDownloadLocationMapper.properties")
public class ReportDownloadLocationMapper{

	private Map<String, String> reportsDestinationMap;

	public Map<String, String> getReportsDestinationMap() {
		return reportsDestinationMap;
	}

	public void setReportsDestinationMap(Map<String, String> reportsDestinationMap) {
		this.reportsDestinationMap = reportsDestinationMap;
	}

	
	public String MapDownloadLoaction(String keyToMap) {
		String mappedValue = reportsDestinationMap.get(keyToMap);
		return mappedValue;
	}
	
}
