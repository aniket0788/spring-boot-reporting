package com.nationstar.reportengine.model;

import java.sql.Date;

public class ReportBase {
	
	private String emailAddress;
	private String userID;
	private String startDate;
	private String endDate;
	private String deliveryMethod;
	
	private String poolName;
	
	public String getPoolName() {
		return poolName;
	}
	public void setPoolName(String poolName) {
		this.poolName = poolName;
	}
	
	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getDeliveryMethod() {
		return deliveryMethod;
	}
	public void setDeliveryMethod(String deliveryMethod) {
		this.deliveryMethod = deliveryMethod;
	}
	
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ReportBase [emailAddress=");
		builder.append(emailAddress);
		builder.append(", userID=");
		builder.append(userID);
		builder.append(", startDate=");
		builder.append(startDate);
		builder.append(", endDate=");
		builder.append(endDate);
		builder.append(", deliveryMethod=");
		builder.append(deliveryMethod);
		builder.append(", poolName=");
		builder.append(poolName);
		builder.append("]");
		return builder.toString();
	}
	
	
	
	

}
