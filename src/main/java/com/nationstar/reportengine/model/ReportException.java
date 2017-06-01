package com.nationstar.reportengine.model;
import org.springframework.stereotype.Component;

@Component
public class ReportException extends RuntimeException {
	
	private static final long serialVersionUID = -5817348998563791052L;
	
	private String errorCode;
	private String errorMessage;
	private String errorStatus;
	private String errorType;
	
	private String emailAddress;
	private String userID;
	private String startDate;
	private String endDate;
	private String deliveryMethod;
	
	private String errorStackMsg;
	
	private String poolName;
	
	
	
	public ReportException(){
		super();
	}
	
	
	public String getPoolName() {
		return poolName;
	}
	public void setPoolName(String poolName) {
		this.poolName = poolName;
	}
	
	
	public String getErrorStackMsg() {
		return errorStackMsg;
	}
	public void setErrorStackMsg(String errorStackMsg) {
		this.errorStackMsg = errorStackMsg;
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
	
	
	public String getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public String getErrorStatus() {
		return errorStatus;
	}
	public void setErrorStatus(String errorStatus) {
		this.errorStatus = errorStatus;
	}
	public String getErrorType() {
		return errorType;
	}
	public void setErrorType(String errorType) {
		this.errorType = errorType;
	}

}
