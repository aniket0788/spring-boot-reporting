package com.nationstar.reportengine.calculator;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.mapper.ReportMapper;

@Component
public class CalculatorFactory {
	
	@Autowired
	private ApplicationContext context;
	
	
	public ReportCalculator getInstance(String calculatorClassName){	
		
		ReportCalculator calculator = null;
		
		calculator = (ReportCalculator) context.getBean(calculatorClassName);	
		
		return calculator;
		
		
	}
	
	
	

}
