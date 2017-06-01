package com.nationstar.reportengine.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeConstants;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class DateUtil {
	private static final Logger log = LoggerFactory.getLogger(DateUtil.class);

	public static final DateFormat DATE_FORMAT_MM_DD_YYYY_WITH_SLASH = new SimpleDateFormat(
			"MM/dd/yyyy");

	private static final DateFormat DATE_FORMAT_MMDDYYYY = new SimpleDateFormat(
			"MMddyyyy");

	private static final DateFormat DATE_FORMAT_MMDDYYYYHHSSMM = new SimpleDateFormat(
			"yyyy-MM-dd hh:mm:ss.S");
	private static final SimpleDateFormat DATE_FORMAT_YYYYMM = new SimpleDateFormat("yyyyMM");

	private static final SimpleDateFormat DATE_FORMAT_YYYYMMDD = new SimpleDateFormat("yyyy-MM-dd");

	public String getYearMonth(String dateInString) {		
		Date date = null;
		try {
			date = DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.parse(dateInString);
		} catch (ParseException pe) {
			log.error("Parse Exception !", pe);
		}
		return DATE_FORMAT_YYYYMM.format(date);
	}

	public java.sql.Date convertToSQLDate(String dateInString) {		
		Date date = null;
		Date utilDate = null;
		try {
			date = DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.parse(dateInString);
			String sqlDate = DATE_FORMAT_YYYYMMDD.format(date);
			utilDate = DATE_FORMAT_YYYYMMDD.parse(sqlDate);
		} catch (ParseException pe) {
			log.error("Parse Exception !", pe);
		}
		return new java.sql.Date(utilDate.getTime());
	}

	public String getDateInStringFormat(Object sqlDate) {
		SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
		SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
		Date date = null;
		try {
			date = parser.parse(sqlDate.toString());
		} catch (ParseException pe) {
			log.error("Parse Exception !", pe);
		}
		return formatter.format(date);
	}

	public String getConvertDateToINT(String date) {
		return parseDate(date, DATE_FORMAT_MM_DD_YYYY_WITH_SLASH,
				DATE_FORMAT_MMDDYYYY);
	}

	public String getConvertedDateFromFormat_YYYMMDDHHMMSS(String date) {
		return parseDate(date, DATE_FORMAT_MMDDYYYYHHSSMM,
				DATE_FORMAT_MM_DD_YYYY_WITH_SLASH);
	}

	public String getConvertToYYYYMMDDWithMinus(String date){
		return parseDate(date, DATE_FORMAT_MM_DD_YYYY_WITH_SLASH, DATE_FORMAT_YYYYMMDD);
	}
	
	public String getYYYYMMDD_DateFormat(String date){
		return parseDate(date, DATE_FORMAT_MM_DD_YYYY_WITH_SLASH, DATE_FORMAT_YYYYMMDD);
	}

	private String parseDate(String date, DateFormat parser,
			DateFormat formatter) {
		Date datenewDate = null;
		try {
			datenewDate = parser.parse(date);
			return formatter.format(datenewDate);
		} catch (ParseException e) {
			log.error("Parse Exception !", e);
		}
		return null;
	}

	public int getPeriodInYears(Date fromDate, Date toDate) {

		Instant fromDateInstant = fromDate.toInstant();
		ZonedDateTime fromDatezdt = fromDateInstant.atZone(ZoneId.systemDefault());
		LocalDate fromDateLocal = fromDatezdt.toLocalDate();

		Instant toDateInstant = toDate.toInstant();
		ZonedDateTime toDatezdt = toDateInstant.atZone(ZoneId.systemDefault());
		LocalDate toDatezdtLocal = toDatezdt.toLocalDate();

		Period period = Period.between(fromDateLocal, toDatezdtLocal);
		return period.getYears();
	}

	public XMLGregorianCalendar getXMLGregorianCalendar(String date){
		return convertToXMLGregorianCalendarDate(date, DATE_FORMAT_YYYYMMDD);
	}

	private XMLGregorianCalendar convertToXMLGregorianCalendarDate(String date, DateFormat parser){
		Date dob=null;
		try {
			dob=parser.parse(date);
		} catch (ParseException pe) {
			log.error("Parse Exception !", pe);
		}
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(dob);
		XMLGregorianCalendar xmlDate = null;
		try {
			xmlDate = DatatypeFactory.newInstance().newXMLGregorianCalendarDate(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH)+1, cal.get(Calendar.DAY_OF_MONTH), DatatypeConstants.FIELD_UNDEFINED);
		} catch (DatatypeConfigurationException e) {
			log.error("DatatypeConfigurationException !", e);
		}
		return xmlDate;
	}

	public String getFirstDateOfTheMonth(String reportingMonth) {
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(DATE_FORMAT_YYYYMM.parse(reportingMonth));
			return DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.format(cal.getTime());
		} catch (ParseException e) {
			log.error("Parse Exception !", e);
		}
		return null;
	}

	public String getProcessDateOfTheReport(Date reportingMonth) {
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(reportingMonth);
			cal.add(Calendar.DAY_OF_YEAR, -1);
			return DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.format(cal.getTime());
		} catch (Exception e) {
			log.error("Parse Exception !", e);
		}
		return null;
	}
	public String getDateInMMDDYYformate_WithMinus(String date){
		DateFormat dateFormat=new SimpleDateFormat("MM-dd-yy");
		return parseDate(date, DATE_FORMAT_MM_DD_YYYY_WITH_SLASH, dateFormat);
	}

	public String getCurrentDateInMMDDYYYY_WithSlash(){
		Date date=new Date(System.currentTimeMillis());
		return DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.format(date);
	}
	public String getEndDateOftheMonth(String reportingMonth){
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(DATE_FORMAT_YYYYMM.parse(reportingMonth));
			cal.set(Calendar.DAY_OF_MONTH,cal.getActualMaximum(Calendar.DAY_OF_MONTH));
			return DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.format(cal.getTime());
		} catch (ParseException e) {
			log.error("Parse Exception !", e);
		}
		return null;
	}
}
