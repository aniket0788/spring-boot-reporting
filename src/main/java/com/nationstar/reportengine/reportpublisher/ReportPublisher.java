package com.nationstar.reportengine.reportpublisher;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportResponse;

@Component
public interface ReportPublisher {	
	public ReportResponse publishReport(ReportDTO repDTO);
	
}
