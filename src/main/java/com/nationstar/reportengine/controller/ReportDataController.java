package com.nationstar.reportengine.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.nationstar.reportengine.model.ReportMetaData;
import com.nationstar.reportengine.service.ReportsService;
import com.nationstar.reportengine.util.ReportRequestValidator;
import com.nationstar.reportengine.util.SQLUtil;

@RestController
@RequestMapping("/getListOfReports")
public class ReportDataController {
	private static final Logger log = LoggerFactory.getLogger(ReportDataController.class);
    
	@Autowired
	private SQLUtil sqlUtil;
	   
	   @RequestMapping(method = RequestMethod.GET, produces = "application/json")
       public String getReportNames() throws Exception{
		   
		   String jsonString = sqlUtil.readStringFromFile("JSONs"+File.separator+"ReportNamesWithTaskIDs.json",null);
           return jsonString;
       }

}
