package com.nationstar.reportengine.mapper;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component(value="TransacationDesignatorMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/TransactionDesignatorMapper.properties")
public class TransacationDesignatorMapper implements ReportMapper {
       
       
       private Map<String, String> transactionDesignatorMap;
       
       
       
       public Map<String, String> getTransactionDesignatorMap() {
              return transactionDesignatorMap;
       }



       public void setTransactionDesignatorMap(Map<String, String> transactionDesignatorMap) {
              this.transactionDesignatorMap = transactionDesignatorMap;
       }



       @Override
       public String MapColumnData(String keyToMap) {

    	   		String mappedValue = transactionDesignatorMap.get(keyToMap);
	    	   	return mappedValue;
       }
       

}
