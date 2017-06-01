package com.nationstar.reportengine.calculator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.mapper.ReportMapper;
import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;

@Component("ReportDateFormatToMMDDYYY")
public class ReportDateFormatToMMDDYYY implements ReportCalculator, ReportMapper {

	@Autowired
	private DateUtil dateUtil;

	@Override
	public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
		return repDto.getReportReq().getEndDate();

	}

	@Override
	public String MapColumnData(String keyToMap) {
		return this.dateUtil.getConvertedDateFromFormat_YYYMMDDHHMMSS(keyToMap);
	}
}
