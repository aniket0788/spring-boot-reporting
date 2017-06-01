package com.nationstar.reportengine.mapper;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component(value="FNMATransactionCodeMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/FNMATransactionCodeMapper.properties")
public class FNMATransactionCodeMapper implements ReportMapper{
	
    private Map<String, String> transactionCodeMap;
    
    public Map<String, String> getTransactionCodeMap() {
           return transactionCodeMap;
    }

    public void setTransactionCodeMap(Map<String, String> transactionCodeMap) {
           this.transactionCodeMap = transactionCodeMap;
    }

    @Override
    public String MapColumnData(String keyToMap) {

 	   		String mappedValue = transactionCodeMap.get(keyToMap);
	    	return mappedValue;
    }
}
