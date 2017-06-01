package com.nationstar.reportengine.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.opencsv.CSVWriter;

@Component
public class CSVUtils {

	private static final Logger log = LoggerFactory.getLogger(CSVUtils.class);

	//public void writeToCVS(List<Map<String, Object>> resultSet, Writer writerObj) throws IOException, Exception {
	public void writeToCVS(ReportDTO repDTO, Writer writerObj) throws IOException, Exception {	
		CSVWriter csvWriter = null;
		try{
		csvWriter = new CSVWriter(writerObj);
		csvWriter.writeAll(toStringArray(repDTO));
		//csvWriter.flush();
		log.info("file written successfully !");
		}
		catch (IOException ie) {
			log.error("method writeToCVS() - IOException in writing to file");
			throw ie;
		}
		catch (Exception e) {
			log.error("method writeToCVS() - Exception in writing to file");
			throw e;
		}
		finally {
			if(csvWriter != null) 	csvWriter.close();
		}
	}
	
	
	public List<String[]> writeToList(ReportDTO repDTO) throws IOException, Exception {			
		
		return toStringArray(repDTO);
		
	}
	
	
	
	
	private String[] getHeaderNames(ReportDTO repDTO){
		
		log.info("Inside getHeaderNames method!!!");
		
		List<ReportColumns> reportCol =  repDTO.getReportMetaData().getReportTabs().get(0).getReportColumns(); 
		
		Iterator<ReportColumns> repIt =  reportCol.iterator();
		
		String[] headerNames = new String[reportCol.size()];
		int count = 0;
		while(repIt.hasNext()){
			headerNames[count++] = repIt.next().getColumnName();
		}
		
		return headerNames;
		
	}

	private List<String[]> toStringArray(ReportDTO repDTO) throws Exception {

		List<String[]> entries = new ArrayList<String[]>();

		// Header Names will be taken from the JSON file values....
		
		String[] headerNames = getHeaderNames(repDTO);
		entries.add(headerNames);  // Names of Header!!!
		
		
		// Adding the actual values..........
		
		List<Map<String, Object>> resultSet  = repDTO.getMappedOutputData();

		Iterator<Map<String, Object>> it = resultSet.iterator();
		
		int rowSize = 0;

		while (it.hasNext()) {

			Map<String, Object> obj = it.next();
			
			rowSize	=	obj.size();

			String[] values = new String[rowSize];

			for (int cnt = 0; cnt < obj.size(); cnt++) {

				Object ob = obj.get(headerNames[cnt]);

				if (ob == null)
					values[cnt] = "";
				else
					values[cnt] = (obj.get(headerNames[cnt])).toString();

			}

			entries.add(values);

		}
		
		
		// Get aggreate  columns
		
		// 1.  Add few blank rows....
			for(int j =0; j<2;j++){
				
				String[] values = new String[rowSize];
				for (int i = 0; i< rowSize ; i++){
					values[i] = "";
				}
				
				
				entries.add(values);
			
			}	
		
		
		// 2. adding the aggregate col....
				//log.info("Size of Aggregate column = " + repDTO.getAggregatedResult().size() );
				
				String[] values1 = new String[rowSize];
				for (int i = 0; i< rowSize ; i++){
					
					Map<String, Object> mapObj1 = repDTO.getAggregatedResult();
					
					if(mapObj1!=null  &&  mapObj1.get(headerNames[i]) != null && mapObj1.containsKey(headerNames[i]) )
						
						values1[i] = repDTO.getAggregatedResult().get(headerNames[i]).toString();
					else
						values1[i] = "";
				}
				
				entries.add(values1);	
				
				
				
		return entries;
	}


	public FileWriter getFileWriter(String fileName) throws IOException {

		FileWriter writer = null;
		try {
		File file = new File(fileName);
		// creates the file
		file.createNewFile();
		// creates a FileWriter Object
		writer = new FileWriter(file, false);
		log.info(fileName + " is created successfully !");
		}
		catch (IOException ie) {
			log.error("getFileWriter() - error in creating file");
			throw ie;
		}
		return writer;
	}

}
