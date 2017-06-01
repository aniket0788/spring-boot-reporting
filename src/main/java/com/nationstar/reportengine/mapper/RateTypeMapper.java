package com.nationstar.reportengine.mapper;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Created by mduraimani on 5/3/2017.
 */

@Component(value = "RateTypeMapper")
@EnableConfigurationProperties
@ConfigurationProperties
@PropertySource("classpath:properties/RateTypeMapper.properties")
public class RateTypeMapper implements ReportMapper {
    private Map<String, String> rateTypeMapper;

    @Override
    public String MapColumnData(String keyToMap) {
        String mappedValue = rateTypeMapper.get(keyToMap);
        return mappedValue;
    }

    public Map<String, String> getRateTypeMapper() {
        return rateTypeMapper;
    }

    public void setRateTypeMapper(Map<String, String> rateTypeMapper) {
        this.rateTypeMapper = rateTypeMapper;
    }
}
