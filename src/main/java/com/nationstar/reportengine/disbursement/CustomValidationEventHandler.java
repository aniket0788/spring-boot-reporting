package com.nationstar.reportengine.disbursement;

import com.nationstar.reportengine.customexceptions.GlobalExceptionHandler;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.util.Constants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;


import javax.xml.bind.ValidationEvent;
import javax.xml.bind.ValidationEventHandler;


@Component
public class CustomValidationEventHandler implements ValidationEventHandler {

	private static final Logger log = LoggerFactory.getLogger(CustomValidationEventHandler.class);

	@Override
	public boolean handleEvent(ValidationEvent event) {
		log.error(event.getMessage());
		
        ReportException reportException = new ReportException();
        reportException.setErrorMessage(event.getMessage());
        reportException.setErrorCode(Constants.PROBLEM_IN_CREATING_A_FILE_ERROR_CODE);
        reportException.setErrorType(Constants.FILE_CREATION_PROBLEM);

        throw reportException;

    }
}
