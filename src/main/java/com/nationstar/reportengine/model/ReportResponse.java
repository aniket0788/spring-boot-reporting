package com.nationstar.reportengine.model;

import java.util.List;

public class ReportResponse extends ReportBase{
	
	private String responseMessage;
	private String reponseCode;
	private List<String[]> reportData;
	
	public String getResponseMessage() {
		return responseMessage;
	}
	
	
	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}
	public String getReponseCode() {
		return reponseCode;
	}
	public void setReponseCode(String reponseCode) {
		this.reponseCode = reponseCode;
	}

	public List<String[]> getReportData() {
		return reportData;
	}


	public void setReportData(List<String[]> reportData) {
		this.reportData = reportData;
	}


	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ReportResponse [responseMessage=");
		builder.append(responseMessage);
		builder.append(", reponseCode=");
		builder.append(reponseCode);
		builder.append(", reportData=");
		builder.append(reportData);
		builder.append(", toString()=");
		builder.append(super.toString());
		builder.append("]");
		return builder.toString();
	}
	
	
	
	
	

}
