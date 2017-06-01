package com.nationstar.reportengine.model;

public class ReportRequest extends ReportBase {
	
	private	String reportExportFormat;

	
	public String getReportExportFormat() {
		return reportExportFormat;
	}
	public void setReportExportFormat(String reportExportFormat) {
		this.reportExportFormat = reportExportFormat;
	}
	
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ReportRequest [reportExportFormat=");
		builder.append(reportExportFormat);
		builder.append(", toString()=");
		builder.append(super.toString());
		builder.append("]");
		return builder.toString();
	}
	
	
	
	
}
