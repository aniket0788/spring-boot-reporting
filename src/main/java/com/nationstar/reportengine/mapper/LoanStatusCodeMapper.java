package com.nationstar.reportengine.mapper;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component(value="LoanStatusCodeMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/LoanStatusCodeMapper.properties")
public class LoanStatusCodeMapper implements ReportMapper {
	
	private Map<String, String> loanStatusCodeMap;

	public Map<String, String> getLoanStatusCodeMap() {
		return loanStatusCodeMap;
	}

	public void setLoanStatusCodeMap(Map<String, String> loanStatusCodeMap) {
		this.loanStatusCodeMap = loanStatusCodeMap;
	}

	@Override
	public String MapColumnData(String keyToMap) {

		String mappedValue = loanStatusCodeMap.get(keyToMap);
		return mappedValue;

	}
}
