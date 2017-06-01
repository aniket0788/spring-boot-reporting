package com.nationstar.reportengine.controller;

import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.object.GenericStoredProcedure;
import org.springframework.jdbc.object.StoredProcedure;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.nationstar.reportengine.util.ProcUtil;

@RestController
@RequestMapping("/executeProc")
public class ReportProceduresController {

	private static final Logger log = LoggerFactory.getLogger(ReportProceduresController.class);

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private ProcUtil procUtil;

	//A Temporary Contingency Method below

	@RequestMapping(value = "/{startDate}/{endDate}", method = RequestMethod.GET, produces = "text/plain")
	public String executeProc(@PathVariable String startDate, @PathVariable String endDate) {

		// run on browser. one example: http://localhost:8090/executeProc/2017-04-01/2017-04-02

		String status="FAILURE";
		Map<String, Object> procOutput = null;
		
		try {
			procOutput = procUtil.execDisbursementProc(startDate, endDate);
		} catch (Exception e) {
			log.error("Exception thrown at Disbursement procedure call "+e);
			status = e.getMessage();
		}

		String sql = "SELECT count(*) FROM DAILY_DISBURSEMENTS WHERE PROCESS_DATE = ?";
		String process_date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

		int count = jdbcTemplate.queryForObject(sql, new Object[] { process_date }, Integer.class);

		if(procOutput.get("STATUS").toString().equalsIgnoreCase("success") && count > 0)
			status = "SUCCESS";
		else if(procOutput.get("STATUS").toString().equalsIgnoreCase("success") && count == 0)
			status = "Procedure ran successfully, but no records are updated in DAILY_DISBURSEMENTS table";

		log.info("Disbursement Procedure executed manually with status: "+status);

		return status;

	}

}
