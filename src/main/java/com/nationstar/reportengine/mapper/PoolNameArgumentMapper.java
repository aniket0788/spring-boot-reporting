package com.nationstar.reportengine.mapper;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;

@Component(value="PoolNameArgumentMapper")
public class PoolNameArgumentMapper implements ArgumentMapper {
	
	
	@Override
	public Object mapSQLArgument(ReportDTO repDto) {
		// TODO Auto-generated method stub
		String poolName = repDto.getReportReq().getPoolName();
		return poolName;
	}

}
