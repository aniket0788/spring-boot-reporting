package com.nationstar.reportengine.mapper;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;

@Component
public interface ArgumentMapper {
	
	public Object mapSQLArgument(ReportDTO repDto);

}
