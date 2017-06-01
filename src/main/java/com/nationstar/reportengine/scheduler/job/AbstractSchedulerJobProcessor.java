package com.nationstar.reportengine.scheduler.job;

import java.util.Calendar;
import java.util.Date;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.nationstar.reportengine.model.BusinessDay;
import com.nationstar.reportengine.model.ReportRequest;
import com.nationstar.reportengine.scheduler.service.BusinessCalendarService;
import com.nationstar.reportengine.scheduler.service.SchedulerReportService;
import com.nationstar.reportengine.util.DateUtil;

public abstract class AbstractSchedulerJobProcessor {

	@Autowired
	protected SchedulerReportService schedulerReportService;

	@Autowired
	private BusinessCalendarService businessCalendarService;

	protected ReportRequest getReportRequest(JSONObject jobRequestData) {
		ReportRequest reportRequest = new ReportRequest();
		reportRequest.setDeliveryMethod(jobRequestData.getString("deliveryMethod"));
		reportRequest.setEmailAddress(jobRequestData.getString("emailAddress"));
		reportRequest.setPoolName(jobRequestData.getString("poolName"));
		reportRequest.setReportExportFormat(jobRequestData.getString("reportExportFormat"));
		reportRequest.setUserID(jobRequestData.getString("userID"));
		return reportRequest;
	}

	protected String[] getMonthlySelectedDate() {
		String start = null, endDate = null;
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date(System.currentTimeMillis()));
		calendar.add(Calendar.MONTH, -1);
		
		int mon = calendar.get(Calendar.MONTH)+1;
		int minDay = calendar.getActualMinimum(Calendar.DAY_OF_MONTH);
		int maxDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		int year = calendar.get(Calendar.YEAR);
		StringBuilder builder = new StringBuilder();
		start = builder.append(mon).append("/").append(minDay).append("/").append(year).toString();
		builder = new StringBuilder();
		endDate = builder.append(mon).append("/").append(maxDay).append("/").append(year).toString();
		String[] selectedDate = { start, endDate };
		return selectedDate;
	}

	protected String[] getDailySelectedDate() {
		Date today = new Date(System.currentTimeMillis());
		String[] curDate = DateUtil.DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.format(today).split("/", 3);
		BusinessDay businessDay = this.businessCalendarService
				.findOne(getModifiedDate(curDate));
		if (null == businessDay || businessDay.getServicingDay().equalsIgnoreCase("0"))
			return null;
		String[] selectedDate = { businessDay.getServicingPreviousDay(), businessDay.getTheDate() }; // get previous day and current day
		return selectedDate;
	}

	private static String getModifiedDate(String[] curDate) {
		if(curDate[0].startsWith("0")){
			curDate[0]=curDate[0].substring(1, 2);
		}
		if(curDate[1].startsWith("0")){
			curDate[1]=curDate[1].substring(1, 2);
		}
		return curDate[0]+"/"+curDate[1]+"/"+curDate[2];
	}
}
