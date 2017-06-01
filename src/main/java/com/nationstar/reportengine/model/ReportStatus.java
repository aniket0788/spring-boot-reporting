package com.nationstar.reportengine.model;

import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;


@Entity
@Table(name = "INVR_REPORTSTATUS")
public class ReportStatus {

	@Id
	@SequenceGenerator(name = "seq", sequenceName = "INVR_REPORTSTATUS_SEQ")
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
	@Column(name = "REPORT_ID")
	private Long reportID;
	@Column(name = "REPORT_NAME")
	private String reportName;
	@Column(name = "TASK_ID")
	private String taskId;
	@Column(name = "REPORT_TYPE")
	private String reportType;
	@Column(name = "REPORTING_MONTH")
	private String reportingMonth;
	@Column(name = "REPORT_START_DATE")
	private Date reportStartDate;
	@Column(name = "REPORT_END_DATE")
	private Date reportEndDate;
	@Column(name = "REPORT_PROCESSING_BEGINTIME")
	private Timestamp reportProcessingBeginTime;
	@Column(name = "REPORT_PROCESSING_ENDTIME")
	private Timestamp reportProcessingEndTime;
	@Column(name = "REPORT_GENERATED_FILENAME")
	private String reportGeneratedFileName;
	@Column(name = "REPORT_FILE_VERSION_NO")
	private int reportFileVersionNo;
	@Column(name = "REQUESTED_BY_USER_ID")
	private String requestedByUserId;
	@Column(name = "STATUS")
	private String status;
	@Column(name = "REQUESTED_REPORT")
	private String requestedReport;
    
	public String getRequestedReport() {
		return requestedReport;
	}

	public void setRequestedReport(String requestedReport) {
		this.requestedReport = requestedReport;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getReportID() {
		return reportID;
	}

	public void setReportID(Long reportID) {
		this.reportID = reportID;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}

	public String getReportType() {
		return reportType;
	}

	public void setReportType(String reportType) {
		this.reportType = reportType;
	}

	public String getReportingMonth() {
		return reportingMonth;
	}

	public void setReportingMonth(String reportingMonth) {
		this.reportingMonth = reportingMonth;
	}

	public Date getReportStartDate() {
		return reportStartDate;
	}

	public void setReportStartDate(Date reportStartDate) {
		this.reportStartDate = reportStartDate;
	}

	public Date getReportEndDate() {
		return reportEndDate;
	}

	public void setReportEndDate(Date reportEndDate) {
		this.reportEndDate = reportEndDate;
	}

	public Timestamp getReportProcessingBeginTime() {
		return reportProcessingBeginTime;
	}

	public void setReportProcessingBeginTime(Timestamp reportProcessingBeginTime) {
		this.reportProcessingBeginTime = reportProcessingBeginTime;
	}

	public Timestamp getReportProcessingEndTime() {
		return reportProcessingEndTime;
	}

	public void setReportProcessingEndTime(Timestamp reportProcessingEndTime) {
		this.reportProcessingEndTime = reportProcessingEndTime;
	}

	public String getReportGeneratedFileName() {
		return reportGeneratedFileName;
	}

	public void setReportGeneratedFileName(String reportGeneratedFileName) {
		this.reportGeneratedFileName = reportGeneratedFileName;
	}

	public int getReportFileVersionNo() {
		return reportFileVersionNo;
	}

	public void setReportFileVersionNo(int reportFileVersionNo) {
		this.reportFileVersionNo = reportFileVersionNo;
	}

	public String getRequestedByUserId() {
		return requestedByUserId;
	}

	public void setRequestedByUserId(String requestedByUserId) {
		this.requestedByUserId = requestedByUserId;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

}
