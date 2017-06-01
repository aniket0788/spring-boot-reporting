package com.nationstar.reportengine.mapper;

import java.sql.Date;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;

@Component(value="EndDateArgumentMapper")
public class EndDateArgumentMapper implements ArgumentMapper {

	
	
	@Override
	public Object mapSQLArgument(ReportDTO repDto) {
		// TODO Auto-generated method stub
		Date endDate = repDto.getReportStatus().getReportEndDate();
		return endDate;
	}

	
	
	
	

	
	

}
