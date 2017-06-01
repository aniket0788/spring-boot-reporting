package com.nationstar.reportengine.calculator;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportStatus;

@Component(value = "ReportingMonthCalculator")
public class ReportingMonthCalculator implements ReportCalculator {

	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
		// TODO Auto-generated method stub
		return repDto.getReportStatus().getReportingMonth();
	}

}
