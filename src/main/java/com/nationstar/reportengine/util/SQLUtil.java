package com.nationstar.reportengine.util;

import java.io.InputStream;
import java.util.Scanner;

import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportRequest;

@Component
public class SQLUtil {

	public String readStringFromFile(String fileName,ReportRequest req) {  // if ReportRequest is not required , pass null

		ClassLoader classloader = Thread.currentThread().getContextClassLoader();
		InputStream is = classloader.getResourceAsStream(fileName);

		if (is == null) {
			
			ReportException reportException = new ReportException();
			
			reportException.setErrorCode(Constants.PROBLEM_IN_FILE_NAME_OR_FILE_IS_NOT_PRESENT_ERROR_CODE);
			reportException.setErrorMessage(Constants.PROBLEM_IN_FILE_NAME_OR_FILE_IS_NOT_PRESENT_ERROR_MESSAGE);
			reportException.setErrorStackMsg(Constants.PROBLEM_IN_FILE_NAME_OR_FILE_IS_NOT_PRESENT_ERROR_MESSAGE);
			reportException.setErrorStatus("");
			reportException.setErrorType("");
			reportException.setErrorType("File Problem");
			reportException.setErrorStackMsg("Problem in reading " + fileName );
			
			if (req != null) {
				reportException.setDeliveryMethod(req.getDeliveryMethod());
				reportException.setEmailAddress(req.getEmailAddress());
				reportException.setEndDate(req.getEndDate());
				reportException.setStartDate(req.getStartDate());
				reportException.setUserID(req.getUserID());
			}
			
			throw reportException;
			
			
		}

		Scanner scanner = new Scanner(is);
		scanner.useDelimiter("\\A");
		String sqlString = scanner.hasNext() ? scanner.next() : "";
		scanner.close();

		return sqlString;
	}
}
