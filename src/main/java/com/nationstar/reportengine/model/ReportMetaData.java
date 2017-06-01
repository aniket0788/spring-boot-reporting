package com.nationstar.reportengine.model;

import java.util.ArrayList;

public class ReportMetaData {
	private String reportPath;
	private String reportFileName;
	private String appendReportingMonth;
	private String investorName;
	private String servicerID;
	private String sqlQueryFileName;
	private String fileNameSeparator;

	private boolean appendInvestorName;
	private boolean appendServicerId;	
	private boolean appendPoolNumber;
	private boolean appendVersion;
	private boolean isMonthlyReport;
	private boolean appendProcessingDate;

	private ArrayList<ReportTab> reportTabs;
	private ArrayList<SQLArguments> sqlArguments;

	public ArrayList<SQLArguments> getSqlArguments() {
		return sqlArguments;
	}

	public void setSqlArguments(ArrayList<SQLArguments> sqlArguments) {
		this.sqlArguments = sqlArguments;
	}

	public String getAppendReportingMonth() {
		return appendReportingMonth;
	}

	public void setAppendReportingMonth(String appendReportingMonth) {
		this.appendReportingMonth = appendReportingMonth;
	}

	public boolean isAppendPoolNumber() {
		return appendPoolNumber;
	}

	public void setAppendPoolNumber(boolean appendPoolNumber) {
		this.appendPoolNumber = appendPoolNumber;
	}

	public boolean isAppendVersion() {
		return appendVersion;
	}

	public void setAppendVersion(boolean appendVersion) {
		this.appendVersion = appendVersion;
	}

	public String getFileNameSeparator() {
		return fileNameSeparator;
	}

	public void setFileNameSeparator(String fileNameSeparator) {
		this.fileNameSeparator = fileNameSeparator;
	}

	public boolean isMonthlyReport() {
		return isMonthlyReport;
	}

	public void setMonthlyReport(boolean isMonthlyReport) {
		this.isMonthlyReport = isMonthlyReport;
	}

	public ArrayList<ReportTab> getReportTabs() {
		return reportTabs;
	}

	public void setReportTabs(ArrayList<ReportTab> reportTabs) {
		this.reportTabs = reportTabs;
	}

	public String getReportPath() {
		return reportPath;
	}

	public void setReportPath(String reportPath) {
		this.reportPath = reportPath;
	}

	public String getReportFileName() {
		return reportFileName;
	}

	public void setReportFileName(String reportFileName) {
		this.reportFileName = reportFileName;
	}

	public String getInvestorName() {
		return investorName;
	}

	public void setInvestorName(String investorName) {
		this.investorName = investorName;
	}

	public String getServicerID() {
		return servicerID;
	}

	public void setServicerID(String servicerID) {
		this.servicerID = servicerID;
	}

	public String getSqlQueryFileName() {
		return sqlQueryFileName;
	}

	public void setSqlQueryFileName(String sqlQueryFileName) {
		this.sqlQueryFileName = sqlQueryFileName;
	}

	public boolean isAppendInvestorName() {
		return appendInvestorName;
	}

	public void setAppendInvestorName(boolean appendInvestorName) {
		this.appendInvestorName = appendInvestorName;
	}

	public boolean isAppendServicerId() {
		return appendServicerId;
	}

	public void setAppendServicerId(boolean appendServicerId) {
		this.appendServicerId = appendServicerId;
	}

	public boolean isAppendProcessingDate() {return appendProcessingDate;}

	public void setAppendProcessingDate(boolean appendProcessingDate) {this.appendProcessingDate = appendProcessingDate;}
}
