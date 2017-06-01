package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;

@Component(value = "AgeCalculationCalculator")
public class AgeCalculationCalculator implements ReportCalculator {

	private static final Logger log = LoggerFactory.getLogger(AgeCalculationCalculator.class);
	
	@Autowired
	private DateUtil dateUtil;

	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {

            Date fromDate = null, toDate = null;
	    	String[] sqlArguments = curCol.getSqlColumnName().split(",");
	    	fromDate =(Date) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[0]);
			if(sqlArguments.length > 1) {
			  toDate = (Date) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[1]);
			} else {
				
				String toDateString = repDto.getReportReq().getEndDate();
				DateFormat DATE_FORMAT_MM_DD_YYYY_WITH_SLASH = new SimpleDateFormat("MM/dd/yyyy");
				try {
					toDate = DATE_FORMAT_MM_DD_YYYY_WITH_SLASH.parse(toDateString);
				} catch (ParseException pe) {
					log.error("Parse Exception !", pe);
				}
				
		    }
			
			if(null != fromDate && null != toDate) {
			Integer ageInYears = dateUtil.getPeriodInYears(fromDate, toDate);
	    	return ageInYears.toString();
			} 
			
			return "";
	}

}
