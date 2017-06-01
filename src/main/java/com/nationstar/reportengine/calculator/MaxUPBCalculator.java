package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;

@Component(value = "MaxUPBCalculator")
public class MaxUPBCalculator implements ReportCalculator {
	
	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
		
		String[] sqlArguments = curCol.getSqlColumnName().split(",");
		BigDecimal loan_no = (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[0]);
		BigDecimal CURRENT_TOTAL_UPB = (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[1]);
		BigDecimal curr_max_upb_loanno = (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(sqlArguments[1]);
		if(loan_no.equals(curr_max_upb_loanno))
			return CURRENT_TOTAL_UPB.toString();
		else
			return "0";
	}

}
