package com.nationstar.reportengine.mapper;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component(value="PaymentPlanMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/PaymentPlanMapper.properties")
public class PaymentPlanMapper implements ReportMapper {


	private Map<String, String> paymentPlanMap;


	public Map<String, String> getPaymentPlanMap() {
		return paymentPlanMap;
	}


	public void setPaymentPlanMap(Map<String, String> paymentPlanMap) {
		this.paymentPlanMap = paymentPlanMap;
	}


	@Override
	public String MapColumnData(String keyToMap) {

		String mappedValue = paymentPlanMap.get(keyToMap);
		return mappedValue;
	}
}
