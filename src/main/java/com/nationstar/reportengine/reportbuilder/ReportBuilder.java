package com.nationstar.reportengine.reportbuilder;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportDTO;

@Component
public interface ReportBuilder {
	
	public void buildReportName(ReportDTO repDto,String reportName, String taskID);
	public void buildReport(ReportDTO repDto);
	public List<Map<String, Object>> MapReportData(ReportDTO repDto);
	public int getFileVersion(ReportDTO repDto,String taskID);

	

}
