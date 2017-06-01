package com.nationstar.reportengine.util;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class SQLUtilTest {
	@Autowired
	private SQLUtil sqlUtil;

	@Test
	public void checkSQLQueryFromFile() {

		//sqlUtil = Mockito.mock(SQLUtil.class);
		String expectedOutput ="Write expected output";
		//when(sqlUtil.readSQLQueryFromFile("MECA2011RMMonthlyReport.sql")).thenReturn(expectedOutput);
		assertEquals(sqlUtil.readStringFromFile("MECA2011RMMonthlyReport.sql",null), expectedOutput);
	}

}
