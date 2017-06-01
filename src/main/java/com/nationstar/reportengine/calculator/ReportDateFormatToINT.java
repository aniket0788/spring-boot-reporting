package com.nationstar.reportengine.calculator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;

@Component("ReportDateFormatToINT")
public class ReportDateFormatToINT implements ReportCalculator {

	@Autowired
	private DateUtil dateUtil;

	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
		// TODO Auto-generated method stub
		return dateUtil.getConvertDateToINT(repDto.getReportReq().getEndDate());
	}

}
