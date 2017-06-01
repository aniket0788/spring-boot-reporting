package com.nationstar.reportengine.util;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.reportpublisher.CSVReportPublisher;

@Component
public class JDBCTemplateUtil {
	
	private static final Logger log = LoggerFactory.getLogger(JDBCTemplateUtil.class);

	@Autowired
	private JdbcTemplate jdbcTemplate;

	public List<Map<String, Object>> queryDatabase(String queryString, Object[] args) {
		
		log.info("JDBCTemplateUtil.queryDatabase method is called");

		List<Map<String, Object>> resultSet = null;

		try {

			if (args != null) {
				resultSet = getJdbcTemplate().queryForList(queryString, args);
			} else {
				resultSet = getJdbcTemplate().queryForList(queryString);
			}

		} catch (Exception e) {
			
			log.error("SQL Exception !"+e);

			ReportException reportException = new ReportException();
			
			reportException.setErrorCode(Constants.INVALID_SYNTAX_IN_SQL_QUERY_ERROR_CODE);
			reportException.setErrorMessage(Constants.INVALID_SYNTAX_IN_SQL_QUERY_MESSAGE);
			reportException.setErrorStackMsg(e.getMessage());
			reportException.setErrorStatus("");
			reportException.setErrorType("");
			reportException.setErrorType("SQL");
			reportException.setErrorStackMsg(e.getLocalizedMessage());
			
			throw reportException;
		}

		return resultSet;

	}

	private JdbcTemplate getJdbcTemplate() {
		// TODO Auto-generated method stub
		return this.jdbcTemplate;
	}

}
