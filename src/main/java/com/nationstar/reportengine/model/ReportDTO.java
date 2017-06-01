package com.nationstar.reportengine.model;

import java.util.List;
import java.util.Map;

public class ReportDTO {
	
	private ReportRequest reportReq;
	private List<Map<String, Object>> resultSetData;
	private List<Map<String, Object>> mappedOutputData;
	private ReportStatus reportStatus;
	private ReportMetaData reportMetaData;
	private Map<String, Object> aggregatedResult;
	private String reportType;
	private String reportFileName;
	
	
	public Map<String, Object> getAggregatedResult() {
		return aggregatedResult;
	}
	public void setAggregatedResult(Map<String, Object> aggregatedResult) {
		this.aggregatedResult = aggregatedResult;
	}
	public ReportMetaData getReportMetaData() {
		return reportMetaData;
	}
	public void setReportMetaData(ReportMetaData reportMetaData) {
		this.reportMetaData = reportMetaData;
	}
	public ReportStatus getReportStatus() {
		return reportStatus;
	}
	public void setReportStatus(ReportStatus reportStatus) {
		this.reportStatus = reportStatus;
	}
	
	public ReportRequest getReportReq() {
		return reportReq;
	}
	public void setReportReq(ReportRequest reportReq) {
		this.reportReq = reportReq;
	}
	public List<Map<String, Object>> getResultSetData() {
		return resultSetData;
	}
	public void setResultSetData(List<Map<String, Object>> resultSetData) {
		this.resultSetData = resultSetData;
	}
	public List<Map<String, Object>> getMappedOutputData() {
		return mappedOutputData;
	}
	public void setMappedOutputData(List<Map<String, Object>> mappedOutputData) {
		this.mappedOutputData = mappedOutputData;
	}
	public String getReportType() {
		return reportType;
	}
	public void setReportType(String reportType) {
		this.reportType = reportType;
	}
	public String getReportFileName() {
		return reportFileName;
	}
	public void setReportFileName(String reportFileName) {
		this.reportFileName = reportFileName;
	}
	
}
