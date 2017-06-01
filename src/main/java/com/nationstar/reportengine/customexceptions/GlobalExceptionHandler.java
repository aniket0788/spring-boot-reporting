package com.nationstar.reportengine.customexceptions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportResponse;
import com.nationstar.reportengine.util.ResponseBuilderUtil;

@ControllerAdvice  
public class GlobalExceptionHandler {

	private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@Autowired 
	private ResponseBuilderUtil responseBuilder;


	@ExceptionHandler(value = ReportException.class)  
	@ResponseBody
	public ReportResponse handleReadingSQLFileException(ReportException repException,ReportDTO repDTO) {  	

		log.error("<GlobalExceptionHandler> Report Exception is raised!!!",repException);
		return responseBuilder.buildExceptionResponse(repException,repDTO);  
	} 


	@ExceptionHandler(value = Exception.class)  
	@ResponseBody
	public ReportResponse handleGenericException(Exception ex) {  	

		log.error("<GlobalExceptionHandler> Generic Exception encountered.",ex);
		return responseBuilder.buildGenericExceptionResponse(ex); 
		
	} 

}
