package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;

@Component("CalculateEndBalanceCalculator")
public class CalculateEndBalanceCalculator implements ReportCalculator {
	
	@Override
	public String calculate(ReportDTO repDto, int curRowIndex,ReportColumns curCol) {
		
		String[] arguments=curCol.getSqlColumnName().split(",");
		
		// MON_SCHD_PMNT,MON_UNSCHD_PMNT,MON_PREPMNT,MON_SERV_FEE,MON_MIP,MON_INTEREST,MON_PAYOFF_FEE,MON_PAYOFF
		
		BigDecimal MON_SCHD_PMNT 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[0]);
		BigDecimal MON_UNSCHD_PMNT 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[1]);
		BigDecimal MON_PREPMNT 			= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[2]);
		BigDecimal MON_SERV_FEE 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[3]);
		BigDecimal MON_MIP 				= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[4]);
		BigDecimal MON_INTEREST 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[5]);
		BigDecimal MON_PAYOFF_FEE 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[6]);
		BigDecimal MON_PAYOFF 			= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[7]);
		
		BigDecimal total = MON_SCHD_PMNT.add(MON_UNSCHD_PMNT).add(MON_PREPMNT).add(MON_SERV_FEE).add(MON_MIP).add(MON_INTEREST).add(MON_PAYOFF_FEE).add(MON_PAYOFF);
		
		return total.toString();
	}
}