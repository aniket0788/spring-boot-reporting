package com.nationstar.reportengine.calculator;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by mduraimani on 4/19/2017.
 */
@Component("EndDateCalculator")
class EndDateCalculator implements ReportCalculator {
    @Autowired private DateUtil dateUtil;
    @Override
    public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
        return repDto.getReportStatus().getReportEndDate().toString();
    }
}
