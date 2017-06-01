package com.nationstar.reportengine.calculator;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;

@Component
public interface ReportCalculator {
	
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol);
	

}
