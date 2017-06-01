package com.nationstar.reportengine.calculator;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by mduraimani on 4/19/2017.
 */
@Component("ReportingMonthStartDateCalculator")
public class ReportingMonthFirstDateCalculator implements ReportCalculator {
    @Autowired private DateUtil dateUtil;
    @Override
    public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
        return this.dateUtil.getFirstDateOfTheMonth(repDto.getReportStatus().getReportingMonth());
    }
}
