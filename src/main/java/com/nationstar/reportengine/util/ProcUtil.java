package com.nationstar.reportengine.util;

import java.sql.Types;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.GenericStoredProcedure;
import org.springframework.jdbc.object.StoredProcedure;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.controller.ReportProceduresController;

@Component
public class ProcUtil {
	
	private static final Logger log = LoggerFactory.getLogger(ProcUtil.class);
	
	@Autowired
	private DataSource dataSource;
	
	public Map<String, Object> execDisbursementProc(String startDate, String endDate) throws Exception{
		
		StoredProcedure procedure = new GenericStoredProcedure();
		procedure.setDataSource(dataSource);
		procedure.setSql("USP_DAILY_DISBURSEMENTS");
		procedure.setFunction(false);

		SqlParameter[] parameters = {
				new SqlParameter("START_DT", Types.VARCHAR),
				new SqlParameter("END_DT", Types.VARCHAR),
				new SqlOutParameter("STATUS", Types.VARCHAR)
		};

		procedure.setParameters(parameters);
		//procedure.compile();
		
		log.debug("Params passed :::" +parameters.toString()  +" start date ::" +startDate + " end date :::" +endDate);

		Map<String, Object> procOutput = null;
		try {
			procOutput = procedure.execute(startDate,endDate);
		} catch (Exception e) {
			log.error("Exception thrown during disbursement procedure execution",e);
			throw e;
		}
		
		return procOutput;
	}

}
