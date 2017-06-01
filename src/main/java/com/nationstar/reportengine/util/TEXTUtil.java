package com.nationstar.reportengine.util;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.disbursement.NACHAPropertiesBean;
import com.nationstar.reportengine.model.ReportDTO;

@Component
public class TEXTUtil {

	private final Logger log = LoggerFactory.getLogger(TEXTUtil.class);

	@Autowired
	private NACHAPropertiesBean NACHAPropertiesBean;
	
	public boolean generateNACHA(ReportDTO repDTO, String fileName) throws Exception {
		boolean fileCreated = false;
		String NACHAcontent = null;
		List<Map<String, Object>> achDataList = repDTO.getMappedOutputData();
		if (achDataList.size() > 0) {
			NACHAcontent = prepareNACHAcontent(repDTO);
			writeToFile(fileName, NACHAcontent);
			fileCreated = true;
		} else {
			String warnMsg ="No DD transactions for the day to create the NACHA file for " +repDTO.getReportReq().toString();
			log.warn(warnMsg);
		}
		return fileCreated;
	}

	public String prepareNACHAcontent(ReportDTO repDTO) throws Exception {

		String trimsDataLine;
		String fileHeaderLine;
		String batchHeaderLine;
		String entryDetailLines;
		String batchControlLine;
		String fileControlLine;
		String footerLine;
		String NACHAFileSring = null;
		try {
			log.info("Preparing the NACHA content.. ");
			List<Map<String, Object>> achDataList = repDTO.getMappedOutputData();
			log.info("Transactions(DD) for the day  " + achDataList.size());

			trimsDataLine = createTrimsDataLine(NACHAPropertiesBean);
			fileHeaderLine = createFileHeaderLine(NACHAPropertiesBean, achDataList.get(0));
			batchHeaderLine = createBatchHeaderLine(NACHAPropertiesBean, achDataList.get(0));
			entryDetailLines = creatEntryDetailLines(NACHAPropertiesBean, achDataList);
			batchControlLine = createBatchControlLine(NACHAPropertiesBean, achDataList.get(0));
			fileControlLine = createFileControlLine(NACHAPropertiesBean, achDataList.get(0));
			footerLine = createFooterLine(NACHAPropertiesBean);
			NACHAFileSring = createNACHAFileString(trimsDataLine, fileHeaderLine, batchHeaderLine, entryDetailLines,
					batchControlLine, fileControlLine, footerLine);
			log.info("final NACHA content preparedas below");
			log.info(NACHAFileSring);

		} catch (Exception e) {
			log.error("error in preparing the NACHA content string");
			throw e;
		}
		return NACHAFileSring;

	}

	private String createNACHAFileString(String trimsDataLine, String fileHeaderLine, String batchHeaderLine,
			String entryDetailLines, String batchControlLine, String fileControlLine, String footerLine) {
		StringBuilder NACHAFileSring = new StringBuilder();
		NACHAFileSring.append(trimsDataLine).append(System.getProperty("line.separator")).append(fileHeaderLine)
				.append(System.getProperty("line.separator")).append(batchHeaderLine)
				.append(System.getProperty("line.separator")).append(entryDetailLines)
				.append(System.getProperty("line.separator")).append(batchControlLine)
				.append(System.getProperty("line.separator")).append(fileControlLine)
				.append(System.getProperty("line.separator")).append(footerLine)
				.append(System.getProperty("line.separator")).toString();
		return NACHAFileSring.toString();

	}

	private String createTrimsDataLine(NACHAPropertiesBean bean) {
		log.info("Preparing the TrimsDataLine.. ");
		StringBuilder trimsDataLine = new StringBuilder();
		trimsDataLine.append(bean.getTRIMS_Signatures());
		trimsDataLine.append(bean.getTRIMS_Other_Information());
		trimsDataLine.append(bean.getTRIMS_blankspaces());
		log.info("completed preparing the TrimsDataLine.. ");
		return trimsDataLine.toString();
	}

	private String createFileHeaderLine(NACHAPropertiesBean bean, Map<String, Object> fileHeaderData) {
		log.info("Preparing the FileHeaderLine.. ");
		StringBuilder FileHeaderLine = new StringBuilder();
		FileHeaderLine.append(bean.getFileHeader_record_Type_Code());
		FileHeaderLine.append(bean.getPriority_Code());
		FileHeaderLine.append(bean.getImmediate_Destination());
		FileHeaderLine.append(bean.getImmediate_Origin());
		// creation date / time
		FileHeaderLine.append((String) fileHeaderData.get("File_Creation_Time"));
		FileHeaderLine.append(bean.getFile_ID_Modifier());
		FileHeaderLine.append(bean.getRecord_Size());
		FileHeaderLine.append(bean.getBlocking_Factor());
		FileHeaderLine.append(bean.getFormat_Code());
		FileHeaderLine.append(bean.getImmediate_Destination_Name());
		FileHeaderLine.append(bean.getImmediate_Origin_Name());
		FileHeaderLine.append(bean.getReference_Code());
		log.info("completed preparing the FileHeaderLine.. ");
		return FileHeaderLine.toString();
	}

	private String createBatchHeaderLine(NACHAPropertiesBean bean, Map<String, Object> batchHeaderData) {
		log.info("Preparing the BatchHeaderLine.. ");
		StringBuilder batchHeaderLine = new StringBuilder();
		batchHeaderLine.append(bean.getBatchHeader_Record_Type_Code());
		batchHeaderLine.append(bean.getService_Type_Code());
		batchHeaderLine.append(bean.getCompany_Name());
		batchHeaderLine.append(bean.getCompany_Discretionary_Data());
		batchHeaderLine.append(bean.getCompany_ID_Number());
		batchHeaderLine.append(bean.getStandard_Entry_Class_Code());
		batchHeaderLine.append(bean.getCompany_Entry_Desc());
		batchHeaderLine.append((String) batchHeaderData.get("Company_Description_Date"));
		batchHeaderLine.append((String) batchHeaderData.get("Effective_Entry_Date"));
		batchHeaderLine.append(bean.getSettlement_DT());
		batchHeaderLine.append(bean.getOriginator_Status_Code());
		batchHeaderLine.append(bean.getOriginating_DFI_ID_NBR());
		batchHeaderLine.append(bean.getBatch_NBR());
		log.info("completed preparing the BatchHeaderLine.. ");
		return batchHeaderLine.toString();
	}

	private String creatEntryDetailLines(NACHAPropertiesBean bean, List<Map<String, Object>> achDataList) {
		log.info("Preparing the EntryDetailLine.. ");
		StringBuilder entryDetailLines = new StringBuilder();
		log.info("Total the each EntryDetailLine " + achDataList.size());
		for (int index = 0; index < achDataList.size(); index++) {
			String entryDetailLine = creatEntryDetailLine(bean, achDataList.get(index));
			entryDetailLines.append(entryDetailLine);
			if (!(index == achDataList.size() - 1))
				entryDetailLines.append(System.getProperty("line.separator"));
		}

		log.info("completed preparing the EntryDetailLines. ");
		return entryDetailLines.toString();
	}

	private String creatEntryDetailLine(NACHAPropertiesBean bean, Map<String, Object> map) {

		StringBuilder entryDetailLine = new StringBuilder();
		entryDetailLine.append(bean.getEntryDetail_Record_Type_Code());
		entryDetailLine.append((String) map.get("Transaction_Code"));
		entryDetailLine.append((String) map.get("Receiving_DFI_ID_NBR"));
		entryDetailLine.append((String) map.get("DFI_Account_Number"));
		entryDetailLine.append((String) map.get("Amount"));
		entryDetailLine.append((String) map.get("Individual_Id_Number"));
		entryDetailLine.append((String) map.get("Individual_Payee_name"));
		entryDetailLine.append(bean.getEntryDetail_Discretionary_Data());
		entryDetailLine.append(bean.getEntryDetail_Addenda_Record_Indicator());
		entryDetailLine.append(bean.getEntryDetail_Originating_DFI_ID());
		entryDetailLine.append((String) map.get("Sequence_Number"));
		return entryDetailLine.toString();

	}

	private String createBatchControlLine(NACHAPropertiesBean bean, Map<String, Object> batchControlData) {
		log.info("Preparing the BatchControlLine ");
		StringBuilder batchControlLine = new StringBuilder();
		batchControlLine.append(bean.getBatchControl_Record_Type_Code());
		batchControlLine.append(bean.getService_Class_Code());
		batchControlLine.append(batchControlData.get("Entry_or_Addenda_Count"));
		batchControlLine.append(bean.getEntry_Hash());
		batchControlLine.append(batchControlData.get("Total_Debit_Entry_Dollar_Amt"));
		batchControlLine.append(batchControlData.get("Total_Credit_Entry_Dollar_Amt"));
		batchControlLine.append(bean.getBatchControl_Company_ID_Number());
		batchControlLine.append(bean.getMessage_Authentication_Code());
		batchControlLine.append(bean.getBatchControlReserved());
		batchControlLine.append(bean.getBatchControl_Originating_DFI_ID_NBR());
		batchControlLine.append(bean.getBatchControl_Batch_NBR());
		log.info("completed preparing the BatchControlLine ");
		return batchControlLine.toString();
	}

	private String createFileControlLine(NACHAPropertiesBean bean, Map<String, Object> fileControlData) {
		log.info("Preparing the FileControlLine ");
		StringBuilder fileControlLine = new StringBuilder();
		fileControlLine.append(bean.getFileControl_Record_Type_Code());
		fileControlLine.append(bean.getFileControl_Batch_Count());
		fileControlLine.append(fileControlData.get("Block_Count"));
		fileControlLine.append(fileControlData.get("Entry_Count"));
		fileControlLine.append(bean.getFileControl_Entry_Hash());
		fileControlLine.append(fileControlData.get("Total_Debit_Entry_Amount"));
		fileControlLine.append(fileControlData.get("Total_Credit_Entry_Amount"));
		fileControlLine.append(bean.getFileControl_Reserved());
		log.info("completed preparing the FileControlLine ");
		return fileControlLine.toString();
	}

	private String createFooterLine(NACHAPropertiesBean bean) {
		log.info("Preparing the FooterLine ");
		StringBuilder footer = new StringBuilder();
		footer.append(bean.getFooter());
		log.info("completed preparing the FooterLine ");
		return footer.toString();
	}

	public void writeToFile(String filePath, String content) throws IOException, Exception {
		log.info("Now writing to text File");
		FileWriter fw = null;
		BufferedWriter bw = null;
		try {
			fw = new FileWriter(filePath);
			bw = new BufferedWriter(fw);
			bw.write(content);
		} catch (IOException ie) {
			log.error("error in writing NACHAcontent to file");
			throw ie;
		} finally {
			if(bw != null) 	bw.close();
			if(fw != null) 	fw.close();
		}
	    log.info("successfully written to text file " + filePath);
	}

}
