package com.nationstar.reportengine.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "BUSINESS_CALENDAR")
public class BusinessDay {

	@Id
	@Column(name = "THEDATE")
	private String theDate;
	@Column(name = "SERVICINGDAY")
	private String servicingDay;
	@Column(name = "SERVICINGDAYNUMBER")
	private String servicingDayNumber;
	@Column(name = "SERVICINGDAYSREMAINING")
	private String servicingDayRemaning;
	@Column(name = "SERVICINGNEXTDAY")
	private String servicingNextDay;
	@Column(name = "SERVICINGPREVIOUSDAY")
	private String servicingPreviousDay;

	public String getTheDate() {
		return theDate;
	}

	public void setTheDate(String theDate) {
		this.theDate = theDate;
	}

	public String getServicingDay() {
		return servicingDay;
	}

	public void setServicingDay(String servicingDay) {
		this.servicingDay = servicingDay;
	}

	public String getServicingDayNumber() {
		return servicingDayNumber;
	}

	public void setServicingDayNumber(String servicingDayNumber) {
		this.servicingDayNumber = servicingDayNumber;
	}

	public String getServicingDayRemaning() {
		return servicingDayRemaning;
	}

	public void setServicingDayRemaning(String servicingDayRemaning) {
		this.servicingDayRemaning = servicingDayRemaning;
	}

	public String getServicingNextDay() {
		return servicingNextDay;
	}

	public void setServicingNextDay(String servicingNextDay) {
		this.servicingNextDay = servicingNextDay;
	}

	public String getServicingPreviousDay() {
		return servicingPreviousDay;
	}

	public void setServicingPreviousDay(String servicingPreviousDay) {
		this.servicingPreviousDay = servicingPreviousDay;
	}
}
