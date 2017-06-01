package com.nationstar.reportengine.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component(value="RecipientMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/RecipientMapper.properties")
public class RecipientMapper implements ReportMapper {
	
	private Map<String, String> recipientMap;
	
	public Map<String, String> getRecipientMap() {
		return recipientMap;
	}

	public void setRecipientMap(Map<String, String> recipientMap) {
		this.recipientMap = recipientMap;
	}

	public String[] getRecipients(){
		List<String> mailList = new ArrayList<String>();
		for(Integer index =0;index<recipientMap.size();index++){
			mailList.add(recipientMap.get(index.toString()));
		}
		String[] recipients = mailList.toArray(new String[0]);
		return recipients;
	}

	@Override
	public String MapColumnData(String keyToMap) {
		return null;
	}

}
