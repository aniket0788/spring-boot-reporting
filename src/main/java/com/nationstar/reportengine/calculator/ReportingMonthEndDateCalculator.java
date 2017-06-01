package com.nationstar.reportengine.calculator;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * It gives you the Reporting month end Date.
 * Let assume if you are generating a report on 05/22/2017, you will get the end date of the month, that is 05/31/2017.
 * And we have implement the
 * Created by mduraimani on 5/22/2017.
 */
@Component(value = "ReportingMonthEndDateCalculator")
public class ReportingMonthEndDateCalculator implements ReportCalculator {

    @Autowired
    private DateUtil dateUtil;

    @Override
    public String calculate(ReportDTO repDto, int curRowIndex, ReportColumns curCol) {
        return this.dateUtil.getEndDateOftheMonth(repDto.getReportStatus().getReportingMonth());
    }
}
