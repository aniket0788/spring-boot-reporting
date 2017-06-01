package com.nationstar.reportengine.calculator;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;

@Component("RemittanceAmountCalculator")
public class RemittanceAmountCalculator implements ReportCalculator{

	@Override
	public String calculate(ReportDTO repDto, int curRowIndex,ReportColumns curCol) {

		String[] arguments=curCol.getSqlColumnName().split(",");

		// MON_SCHD_PMNT,MON_UNSCHD_PMNT,MON_PREPMNT,MON_SERV_FEE,MON_MIP,MON_INTEREST,MON_PAYOFF_FEE,MON_PAYOFF

		BigDecimal PRINCIPAL_PAYMENTS 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[0]);
		BigDecimal Paid_in_Full_Proceeds 	= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[1]);
		BigDecimal short_sale_proceeds 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[2]);
		BigDecimal reo_sales_proceeds 		= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[3]);
		BigDecimal Initial_Claim_Proceeds 	= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[4]);
		BigDecimal Supplemental_Claim_Proceeds 	= (BigDecimal) repDto.getResultSetData().get(curRowIndex).get(arguments[5]);

		BigDecimal total = PRINCIPAL_PAYMENTS.add(Paid_in_Full_Proceeds).add(short_sale_proceeds).add(reo_sales_proceeds).add(Initial_Claim_Proceeds).add(Supplemental_Claim_Proceeds);

		return total.toString();
	}

}
