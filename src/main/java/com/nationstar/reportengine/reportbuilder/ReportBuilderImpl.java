package com.nationstar.reportengine.reportbuilder;


import java.io.File;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.calculator.CalculatorFactory;
import com.nationstar.reportengine.calculator.ReportCalculator;
import com.nationstar.reportengine.dao.ReportStatusRepository;
import com.nationstar.reportengine.mapper.ArgumentMapper;
import com.nationstar.reportengine.mapper.MapperFactory;
import com.nationstar.reportengine.mapper.ReportMapper;
import com.nationstar.reportengine.model.ReportColumns;
import com.nationstar.reportengine.model.ReportDTO;
import com.nationstar.reportengine.model.ReportException;
import com.nationstar.reportengine.model.ReportStatus;
import com.nationstar.reportengine.model.SQLArguments;
import com.nationstar.reportengine.util.Constants;
import com.nationstar.reportengine.util.DateUtil;
import com.nationstar.reportengine.util.JDBCTemplateUtil;
import com.nationstar.reportengine.util.SQLUtil;

@Component
public class ReportBuilderImpl implements ReportBuilder {

	private static final Logger log = LoggerFactory.getLogger(ReportBuilderImpl.class);
	

	@Autowired
	private JDBCTemplateUtil jdbcTemplateUtil;

	@Autowired
	private MapperFactory mapperFactory;

	@Autowired
	private CalculatorFactory calculatorFactory;

	@Autowired
	private SQLUtil sqlUtil;
	@Autowired
	private DateUtil dateUtil;
	@Autowired
	private ReportStatusRepository reportStatusRepository;

	@Override
	public void buildReport(ReportDTO repDto) {

		try {

			String sqlFileName = repDto.getReportMetaData().getSqlQueryFileName();
			
			log.info("buildReport , File Name = " + sqlFileName);
	
			List<Map<String, Object>> resultSet = null;
			int index = repDto.getReportStatus().getRequestedReport().lastIndexOf('_')+1;
            String dirPath = repDto.getReportStatus().getRequestedReport().substring(0,index)+"Reports";
			String sql = sqlUtil.readStringFromFile(dirPath+File.separator+sqlFileName,repDto.getReportReq()); 
			
			Object[] params = buildArguments(repDto);
			 
			resultSet = jdbcTemplateUtil.queryDatabase(sql, params);

			log.info("ResultSet Size = " + resultSet.size());

			repDto.setResultSetData(resultSet);

		} catch (ReportException rep) {
			
				log.error("Exception occurred while building report data !",rep);
				rep.setDeliveryMethod(repDto.getReportReq().getDeliveryMethod());
				rep.setEmailAddress(repDto.getReportReq().getEmailAddress());
				rep.setEndDate(repDto.getReportReq().getEndDate());
				rep.setStartDate(repDto.getReportReq().getStartDate());
				rep.setUserID(repDto.getReportReq().getUserID());
				// Store the end time of the report...
				repDto.getReportStatus().setReportProcessingEndTime((new Timestamp(System.currentTimeMillis())));
				
				throw rep;
		}

	}

	private Object[] buildArguments(ReportDTO repDto) {

		ArrayList<Object> argList = new ArrayList<Object>();
		ArrayList<SQLArguments> sqlArguments = repDto.getReportMetaData().getSqlArguments();

		for (SQLArguments sqlArg : sqlArguments) {
			if (!sqlArg.getArgumentMapper().isEmpty()) {
				Object temp;
				ArgumentMapper argMapper = mapperFactory.getArgumentMapper(sqlArg.getArgumentMapper());
				temp = argMapper.mapSQLArgument(repDto);
				if(repDto.getReportReq().getReportExportFormat().equalsIgnoreCase("xml") 
						|| repDto.getReportStatus().getRequestedReport().equalsIgnoreCase("Daily_Disbursement_"))
					argList.add(temp.toString());
				else
					argList.add(temp);

			} else {
				
				if(!sqlArg.getArgumentValue().isEmpty()){
					argList.add(sqlArg.getArgumentValue());
				} else{
					
					//error scenario// this should never happen // throw exception here if this happens
					ReportException rep = new ReportException();
					rep.setDeliveryMethod(repDto.getReportReq().getDeliveryMethod());
					rep.setEmailAddress(repDto.getReportReq().getEmailAddress());
					rep.setEndDate(repDto.getReportReq().getEndDate());
					rep.setStartDate(repDto.getReportReq().getStartDate());
					rep.setUserID(repDto.getReportReq().getUserID());
					
					rep.setErrorCode(Constants.INVALID_SQL_ARGUMENTS_PARAMETERS_ERROR_CODE);
					rep.setErrorMessage(Constants.INVALID_SQL_ARGUMENTS_PARAMETERS_ERROR_MESSAGE);
					
					throw rep;
				}
			}

		}
		Object[] argArray = argList.toArray();
		return argArray;
	}

	@Override
	public List<Map<String, Object>> MapReportData(ReportDTO repDto) {

		// start - Testing purpose

		List<Map<String, Object>> resultset = repDto.getResultSetData();

		List<Map<String, Object>> mappedResultSet = new ArrayList<Map<String, Object>>();

		// Iterator<Map<String, Object>> ite = resultset.iterator();

		ListIterator<Map<String, Object>> ite = resultset.listIterator();
		
		

		while (ite.hasNext()) {

			Map<String, Object> mapRow = ite.next();
			int curRowIndex = ite.previousIndex();

			Map<String, Object> mappedRow = new LinkedHashMap<String, Object>();

			Iterator<ReportColumns> iterator = repDto.getReportMetaData().getReportTabs().get(0).getReportColumns()
					.iterator(); // only tabs 1, becuase its not excel

			for (; iterator.hasNext();) {

				ReportColumns col = iterator.next();
				
				//make sure its set in all case statements.. this will not be in SQLDATE CASE....
				
				String aggregateType =  col.getAggregateType();
				
				BigDecimal aggValue1 = null;
				

				switch (col.getColumnType().toUpperCase()) {

				case "SQL":
					
					Object temp;
					temp = mapRow.get(col.getSqlColumnName());
					temp = temp == null ? "" : temp;
					
					if( aggregateType != null && "SUM".equalsIgnoreCase(aggregateType)){
						
						aggValue1 = temp == ""?new BigDecimal(0.00).setScale(2, RoundingMode.HALF_UP):new BigDecimal(temp.toString()).setScale(2, RoundingMode.HALF_UP);
						//finalColValue = temp == ""?0.0f:Float.parseFloat(temp.toString());
						repDto = addAggregateResult(repDto, col.getColumnName(),aggValue1);
					}
					
					
					mappedRow.put(col.getColumnName(), temp);
					//
					//
					break;

				case "SQLDATE":
					temp = mapRow.get(col.getSqlColumnName());
					temp = temp == null ? "" : temp;
					if (temp != "")
						mappedRow.put(col.getColumnName(), dateUtil.getDateInStringFormat(temp));
					else
						mappedRow.put(col.getColumnName(), temp);
					//
					//
					break;

				case "HARDCODED":
					
					//log.info("col.getHardCodedValue() = " + col.getHardCodedValue());
					if( aggregateType != null && "SUM".equalsIgnoreCase(aggregateType)){
						if(col.getHardCodedValue() != null && col.getHardCodedValue()!= "" && col.getHardCodedValue().length() > 0)
							aggValue1 = new BigDecimal(col.getHardCodedValue().toString()).setScale(2, RoundingMode.HALF_UP);
							repDto =  addAggregateResult(repDto, col.getColumnName(),aggValue1);
					}
					mappedRow.put(col.getColumnName(), col.getHardCodedValue());
					//
					//
					//
					break;

				case "MAPPED":

					//
					if(mapRow.get(col.getSqlColumnName()) == null)
						mappedRow.put(col.getColumnName(), "");
					else
					{
					String inputToMapper = mapRow.get(col.getSqlColumnName()).toString();
					ReportMapper mapper = mapperFactory.getInstance(col.getMapperClassName());
					String val = mapper.MapColumnData(inputToMapper);
					
					if( aggregateType != null && "SUM".equalsIgnoreCase(aggregateType)){
						aggValue1 = new BigDecimal(val.toString()).setScale(2, RoundingMode.HALF_UP); 
						repDto =  addAggregateResult(repDto, col.getColumnName(),aggValue1);
					}
					mappedRow.put(col.getColumnName(), val);
					}
					//
					//
					break;

				case "CALCULATE":

					ReportCalculator repCalc = calculatorFactory.getInstance(col.getCalculationMapper());
					String calculatedValue = repCalc.calculate(repDto, curRowIndex, col);
					
					if( aggregateType != null && "SUM".equalsIgnoreCase(aggregateType)){
						aggValue1 = new BigDecimal(calculatedValue.toString()).setScale(2, RoundingMode.HALF_UP);
						repDto =  addAggregateResult(repDto, col.getColumnName(),aggValue1);
					}
					mappedRow.put(col.getColumnName(), calculatedValue);
					//
					break;

				default:

					// Throw exception here
					//

					ReportException rep = new ReportException();
					rep.setDeliveryMethod(repDto.getReportReq().getDeliveryMethod());
					rep.setEmailAddress(repDto.getReportReq().getEmailAddress());
					rep.setEndDate(repDto.getReportReq().getEndDate());
					rep.setErrorCode(Constants.NOT_ALLOWED_COLUMN_TYPE_ERROR_CODE);
					rep.setErrorMessage(
							col.getColumnType().toUpperCase() + " " + Constants.NOT_ALLOWED_COLUMN_TYPE_ERROR_MESSAGE);
					// rep.setErrorStackMsg(errorStackMsg);
					// rep.setErrorStatus(errorStatus);
					rep.setErrorType("Invalid Column Type");
					rep.setStartDate(repDto.getReportReq().getStartDate());
					rep.setUserID(repDto.getReportReq().getUserID());

					throw rep;

					// break;

				}
				
				//check if col needs aggreagation. add it to the aggregator map
				//write a method which takes the finalColVal and columnname and add it to the aggreagator map in the dto 
				
					
					/*if(aggregatedValue == null){
						aggregatedValue  = finalColValue;
					}else{
						aggregatedValue	= aggregatedValue + (finalColValue==null? 0.0f:finalColValue);
					}
					
					//String aggregate = col.getAggreagateType();
					
					if( aggreagateType != null && "SUM".equalsIgnoreCase(aggreagateType)){
						
						Map<String, Object> aggregatedResult = new LinkedHashMap<String, Object>();
						aggregatedResult.put(col.getColumnName(), aggregatedValue);
						
						repDto.setAggregatedResult(aggregatedResult);
					}*/
				
			}

			mappedResultSet.add(mappedRow);

		}

		return mappedResultSet;

	}
	
	
	private ReportDTO addAggregateResult(ReportDTO repDto, String colName, BigDecimal colValue){
		
		Map<String, Object> aggregateResult = repDto.getAggregatedResult();
		
		// first check column name exist...
		
		//if(aggregateResult != null){
			
			/*if( aggregateResult.containsKey(colName)){
				
				Float temp = Float.parseFloat(aggregateResult.get(colName).toString());
				temp = temp + colValue;
				aggregateResult.put(colName, temp);
				repDto.setAggregatedResult(aggregateResult);
				
			}else{
				
				Float temp = colValue;
				aggregateResult.put(colName, temp);
				repDto.setAggregatedResult(aggregateResult);
			}*/
		
		
			if (aggregateResult == null){
				aggregateResult = new LinkedHashMap<String,Object>();
				BigDecimal temp = colValue;
				aggregateResult.put(colName, temp);
				repDto.setAggregatedResult(aggregateResult);
			
			}else if( aggregateResult.containsKey(colName)){
				
				BigDecimal temp = (BigDecimal) aggregateResult.get(colName);
				temp = temp.add(colValue);
				aggregateResult.put(colName, temp);
				repDto.setAggregatedResult(aggregateResult);
				
			}else{
				
				BigDecimal temp = colValue;
				aggregateResult.put(colName, temp);
				repDto.setAggregatedResult(aggregateResult);
			}
		//}
		
		return repDto;
		
	}
	

	@Override
	public void buildReportName(ReportDTO repDto, String reportName, String taskID) {
		
		int version = this.getFileVersion(repDto, taskID);
		
		StringBuilder GeneratingFilename=new StringBuilder();
		GeneratingFilename.append(reportName);
		String fileSeparator=repDto.getReportMetaData().getFileNameSeparator();
		
		
		if(repDto.getReportMetaData().isAppendPoolNumber()){
			GeneratingFilename.append(fileSeparator).append(repDto.getReportReq().getPoolName());
		}
		
		if(repDto.getReportMetaData().isAppendInvestorName()){
			GeneratingFilename.append(fileSeparator).append(repDto.getReportMetaData().getInvestorName());
		}
		if(repDto.getReportMetaData().isAppendServicerId()){
			GeneratingFilename.append(fileSeparator).append(repDto.getReportMetaData().getServicerID());
		}
		if(repDto.getReportMetaData().isMonthlyReport()){
			GeneratingFilename.append(fileSeparator).append(getReportingMonthDate(repDto));
		}
		if(repDto.getReportMetaData().isAppendVersion()){
			GeneratingFilename.append(fileSeparator).append("V").append(version);
		}
		if(repDto.getReportMetaData().isAppendProcessingDate())GeneratingFilename.append(fileSeparator).append(getProcessingDate(repDto));
		  
		GeneratingFilename.append(".").append(repDto.getReportReq().getReportExportFormat().trim().toLowerCase());
		/*repDto.getReportStatus()
				.setReportGeneratedFileName(repDto.getReportStatus().getReportName() + date + "_V" + version + ".csv");*/
		repDto.getReportStatus()
				.setReportGeneratedFileName(GeneratingFilename.toString());
		repDto.setReportFileName(GeneratingFilename.toString());
		repDto.getReportStatus().setReportFileVersionNo(version);

	}

	private String getProcessingDate(ReportDTO repDto) {
		return getTheFormatedDate(repDto.getReportMetaData().getAppendReportingMonth().trim(),dateUtil.getCurrentDateInMMDDYYYY_WithSlash());
	}

	private String getReportingMonthDate(ReportDTO repDto) {
		return getTheFormatedDate(repDto.getReportMetaData().getAppendReportingMonth().trim(),repDto.getReportReq().getEndDate());
	}

	private String getTheFormatedDate(String dateFormat,String toProcesDate){
		String date=null;
		switch(dateFormat){
			case "YYYYMM" :
				date=dateUtil.getYearMonth(toProcesDate);
				break;
			case "YYYYMMDD":
				date=dateUtil.getConvertToYYYYMMDDWithMinus(toProcesDate);
				date=date.replace("-", "");
				break;
			case "MM-dd-yy":
				date=dateUtil.getDateInMMDDYYformate_WithMinus(toProcesDate);
				break;
			default:
				break;
		}
		return date;
	}
	@Override
	public int getFileVersion(ReportDTO repDto, String taskID) {
		int version = 0;
		List<ReportStatus> reportStatuslist = reportStatusRepository
				.findByTaskIdOrderByReportProcessingEndTimeDesc(taskID);
		ReportStatus reportStatus = new ReportStatus();
		if (reportStatuslist.isEmpty())
			version = 1; // New entry in the table
		else
			reportStatus = reportStatuslist.get(0);

		Date reqEndDate = dateUtil.convertToSQLDate(repDto.getReportReq().getEndDate());
		if (reqEndDate.equals(reportStatus.getReportEndDate()))
			version = reportStatus.getReportFileVersionNo() + 1;
		else
			version = 1;

		return version;
	}

}
