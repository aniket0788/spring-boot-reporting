package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.customexceptions.GlobalExceptionHandler;
import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.util.Constants;

@Component(value = "DifferrenceCalculator")
public class DifferrenceCalculator implements ReportCalculator {
	private static final Logger log = LoggerFactory.getLogger(DifferrenceCalculator.class);
	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {

		try {
			BigDecimal fromValue, toValue, diff;
			String[] sqlArguments = curCol.getSqlColumnName().split(",");
			if (sqlArguments.length > 1) {
				fromValue = (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[0]);
				toValue = (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[1]);
				
				fromValue = fromValue == null ? BigDecimal.ZERO:fromValue;
				toValue = toValue == null ? BigDecimal.ZERO:toValue;
				diff = fromValue.subtract(toValue);
				return diff.toString();
			}
		} catch (Exception e) {
			log.error("Exception in Difference Calculator class !",e);
			ReportException reportException = new ReportException();
			reportException.setErrorMessage(Constants.ERROR_MSG);
	        throw reportException;
		}
		return null;
	}

}
