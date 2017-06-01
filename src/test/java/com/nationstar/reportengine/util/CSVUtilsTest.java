package com.nationstar.reportengine.util;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.reportbuilder.ReportBuilder;
import com.nationstar.reportengine.reportbuilder.ReportBuilderFactory;

@RunWith(SpringRunner.class)
@SpringBootTest
public class CSVUtilsTest{
	
	@Autowired
	private CSVUtils csvUtils;
	
	@Mock
	private ReportBuilderFactory reportFactory;
	@Mock
	private ReportBuilder builder;
	
	
	@Before
    public void setupMock() {
		MockitoAnnotations.initMocks(this);
    }
	
    @Test
    public void testMockCreation(){
    	assertNotNull(builder);
        assertNotNull(reportFactory);
        
    }
	
	
	@Test
	public void checkFileCreation() throws IOException {

		File file = new File("C:\\CHIP\\report.csv");
		file.delete();
		assertFalse(file.exists());
		csvUtils.getFileWriter("C:\\CHIP\\report.csv");
		assertTrue(file.exists()); 
	} 
	
	
	@Test
	public void checkWriter() throws IOException,Exception{
		
		CSVUtils util 		= 	new CSVUtils(); 
		Writer fileWriter	=	util.getFileWriter("C:\\deletethis\\CSVTest7.csv");
		
		assertNotEquals(fileWriter, null);
		
		//ReportBuilder builder = reportFactory.getInstance("hdfshdf");
		//List<Map<String, Object>> resultSet = builder.buildReport();
		
		List<Map<String, Object>> resultSet = getResultSet();
		
		//util.writeToCVS(resultSet, fileWriter);
		//assertNotEquals(fileWriter, null);

		//when(reportFactory.getInstance("hdfshdf")).thenReturn(builder);
	    //assertEquals(builder,reportFactory.getInstance("hdfshdf"));
	    
	    //resultSet  = getResultSet();
	    
	    //when(builder.buildReport(null)).thenReturn(resultSet);   // json value......
	    //assertEquals(resultSet,builder.buildReport(null));
	    
		ReportDTO repDTO = null;
		util.writeToCVS(repDTO, fileWriter);
	    assertNotEquals(fileWriter, null);
	    
	}
	
	
	public List<Map<String, Object>> getResultSet(){
		
		List<Map<String, Object>> resultSet = new LinkedList<>();
		
		for(int i = 1; i<=2 ; i++){
		
			Map<String, Object> map = new HashMap();
			
			map.put("History", null);
			map.put("ITEM	", null);
			map.put("UID_", "L");
			map.put("STATUS", null);
			map.put("MASTER_UID", "L");
			map.put("PREFIX	", "L");
			map.put("USRLNAME", "L");
			map.put("USRFNAME", null);
			
			resultSet.add(map);
		
		}
		
		return resultSet;
		
	}

}



/*----------------------------------------------------------------------------------- */


