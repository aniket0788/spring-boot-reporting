package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;

@Component("InterestPerTransacationCalculator")
public class InterestPerTransacationCalculator implements ReportCalculator {

	public static final int INTERMEDIATE_SCALE = 16;
	public static final int CURRENCY_SCALE = 2;
	public static final RoundingMode INTERMEDIATE_ROUNDING_MODE = RoundingMode.HALF_UP;
	public static final RoundingMode CURRENCY_ROUNDING_MODE = RoundingMode.HALF_UP;
	
	
	/** In this calculate method, We are using the SQL Columns names <b><i>"amount, interest_rate and payoff_date"<i><b> as hard-coded value,
	 *  why because for calculating the Interest-due, We requires the amount, interest-rate and payoff-date fields value. 
	 *  So we are using the table column names to retrieve the values from the ResultsetData object
	 * If any field name changes happens in the json/sql<b><i>("Custom_Private_Investor_Details.json &Custom_Private_Investor_Details.sql) file <i><b> 
	 * or in the db-table side<b><i>(REVLOANPAYMENTS,REVLOANSERVICINGMONTH & REVLOANPREPAYMENTS). It won't work.
	 * (non-Javadoc)
	 * @see com.nationstar.reportengine.calculator.ReportCalculator#cacluate(com.nationstar.reportengine.model.ReportDTO, int, com.nationstar.reportengine.model.ReportColumns)
	 */
	@Override
	public String calculate(ReportDTO repDto, int curRowIndex,ReportColumns curCol) {
		String[] sqlArguments=curCol.getSqlColumnName().split(",");
		BigDecimal amount=(BigDecimal)repDto.getResultSetData().get(curRowIndex).get(sqlArguments[0]);
		BigDecimal interestRate=(BigDecimal)repDto.getResultSetData().get(curRowIndex).get(sqlArguments[1]);
		Timestamp payoffDate=(Timestamp)repDto.getResultSetData().get(curRowIndex).get(sqlArguments[2]);
		int remainingDays = getRemainingDays(payoffDate);
		return interestPerTransacation(amount,interestRate,remainingDays).toString();
	}

	private int getRemainingDays(Timestamp payoffDate) {
		if(null==payoffDate){
			return 0;
		}
		java.util.Calendar calendar=java.util.Calendar.getInstance();
		calendar.setTimeInMillis(payoffDate.getTime());
		return calendar.getActualMaximum(java.util.Calendar.DAY_OF_MONTH)-calendar.get(java.util.Calendar.DATE);
	}


	public static final BigDecimal interestPerTransacation(BigDecimal amount,
			BigDecimal intRate, int days) {
		return currencyDivide(intermediateSetScale(amount.multiply(intRate
				.multiply(new BigDecimal(String.valueOf(days))))),
				new BigDecimal("36500"));
	}

	public static BigDecimal currencyDivide(BigDecimal dividend,
			BigDecimal divisor) {
		return dividend.divide(divisor, CURRENCY_SCALE, CURRENCY_ROUNDING_MODE);
	}

	public static BigDecimal intermediateSetScale(BigDecimal bd) {
		return bd.setScale(INTERMEDIATE_SCALE, INTERMEDIATE_ROUNDING_MODE);
	}
}
