package com.nationstar.reportengine.mapper;

import java.sql.Date;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;

@Component(value="StartDateArgumentMapper")
public class StartDateArgumentMapper implements ArgumentMapper {

	
	@Override
	public Object mapSQLArgument(ReportDTO repDto) {
		// TODO Auto-generated method stub
		Date fromDate = repDto.getReportStatus().getReportStartDate();
		return fromDate;
	}

	
	
	
	

	
	

}
