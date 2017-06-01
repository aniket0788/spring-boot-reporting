package com.nationstar.reportengine.model;

import java.util.ArrayList;

public class ReportTab {
	private String tabName;
	private ArrayList<ReportColumns> reportColumns;

	public String getTabName() {
		return tabName;
	}

	public void setTabName(String tabName) {
		this.tabName = tabName;
	}

	public ArrayList<ReportColumns> getReportColumns() {
		return reportColumns;
	}

	public void setReportColumns(ArrayList<ReportColumns> reportColumns) {
		this.reportColumns = reportColumns;
	}

	

}
