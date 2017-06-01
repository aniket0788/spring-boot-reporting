package com.nationstar.reportengine.disbursement;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Configuration
@Component(value = "NACHAPropertiesBean")
@PropertySource("classpath:/Daily_Disbursement_Reports/NACHA_Format_Constants.properties")
@EnableAutoConfiguration
public class NACHAPropertiesBean {

	// TRIMSdata
	@Value("${TRIMS.Signatures}")
	String TRIMS_Signatures;
	@Value("${TRIMS.Other_Information}")
	String TRIMS_Other_Information;
	@Value("${TRIMS.blankspaces}")
	String TRIMS_blankspaces;

	// FileHeader

	@Value("${fileHeader.Record_Type_Code}")
	String fileHeader_record_Type_Code;
	@Value("${fileHeader.Priority_Code}")
	String priority_Code;

	@Value("${fileHeader.Immediate_Destination}")
	String immediate_Destination;

	@Value("${fileHeader.Immediate_Origin}")
	String immediate_Origin;

	@Value("${fileHeader.File_ID_Modifier}")
	String file_ID_Modifier;

	@Value("${fileHeader.Record_Size}")
	String record_Size;

	@Value("${fileHeader.Blocking_Factor}")
	String blocking_Factor;

	@Value("${fileHeader.Format_Code}")
	String format_Code;

	@Value("${fileHeader.Immediate_Destination_Name}")
	String immediate_Destination_Name;

	@Value("${fileHeader.Immediate_Origin_Name}")
	String immediate_Origin_Name;

	@Value("${fileHeader.Reference_Code}")
	String reference_Code;

	// batch header
	@Value("${batchHeader.Record_Type_Code}")
	String BatchHeader_Record_Type_Code;
	@Value("${batchHeader.Service_Type_Code}")
	String Service_Type_Code;
	@Value("${batchHeader.Company_Name}")
	String Company_Name;
	@Value("${batchHeader.Company_Discretionary_Data}")
	String Company_Discretionary_Data;
	@Value("${batchHeader.Company_ID_Number}")
	String Company_ID_Number;
	@Value("${batchHeader.Standard_Entry_Class_Code}")
	String Standard_Entry_Class_Code;
	@Value("${batchHeader.Company_Entry_Desc}")
	String Company_Entry_Desc;
	@Value("${batchHeader.Settlement_DT}")
	String Settlement_DT;
	@Value("${batchHeader.Originator_Status_Code}")
	String Originator_Status_Code;
	@Value("${batchHeader.Originating_DFI_ID_NBR}")
	String Originating_DFI_ID_NBR;
	@Value("${batchHeader.Batch_NBR}")
	String Batch_NBR;

	
	// entrydetail
	@Value("${entryDetail.Record_Type_Code}")
	String entryDetail_Record_Type_Code;
	@Value("${entryDetail.Discretionary_Data}")
	String entryDetail_Discretionary_Data;
	@Value("${entryDetail.Addenda_Record_Indicator}")
	String entryDetail_Addenda_Record_Indicator;
	@Value("${entryDetail.Originating_DFI_ID}")
	String entryDetail_Originating_DFI_ID;
	
	
	// batchcontrol
	@Value("${batchControl.Record_Type_Code}")
	String batchControl_Record_Type_Code;
	@Value("${batchControl.Service_Class_Code}")
	String Service_Class_Code;
	@Value("${batchControl.Entry_Hash}")
	String Entry_Hash;
	@Value("${batchControl.Company_ID_Number}")
	String batchControl_Company_ID_Number;
	@Value("${batchControl.Message_Authentication_Code}")
	String Message_Authentication_Code;
	@Value("${batchControl.Reserved}")
	String batchControlReserved;
	@Value("${batchControl.Originating_DFI_ID_NBR}")
	String batchControl_Originating_DFI_ID_NBR;
	@Value("${batchControl.Batch_NBR}")
	String batchControl_Batch_NBR;
	
	//filecontrol
	
	@Value("${fileControl.Record_Type_Code}")
	String fileControl_Record_Type_Code;
	
	@Value("${fileControl.Batch_Count}")
	String fileControl_Batch_Count;
	
	@Value("${fileControl.Entry_Hash}")
	String fileControl_Entry_Hash;
	
	@Value("${fileControl.Reserved}")
	String fileControl_Reserved;
	

    //FOOTER
	
	@Value("${FOOTER.ALL_NINES}")
	String footer;
	
	

	// TrimsData getter setter

	public String getTRIMS_Signatures() {
		return TRIMS_Signatures;
	}

	public String getTRIMS_Other_Information() {
		return TRIMS_Other_Information;
	}

	public String getTRIMS_blankspaces() {
		return TRIMS_blankspaces;
	}

	// FileHeader getter setters

	public String getFileHeader_record_Type_Code() {
		return fileHeader_record_Type_Code;
	}

	public String getPriority_Code() {
		return priority_Code;
	}

	public String getImmediate_Destination() {
		return immediate_Destination;
	}

	public String getImmediate_Origin() {
		return immediate_Origin;
	}

	public String getFile_ID_Modifier() {
		return file_ID_Modifier;
	}

	public String getRecord_Size() {
		return record_Size;
	}

	public String getBlocking_Factor() {
		return blocking_Factor;
	}

	public String getFormat_Code() {
		return format_Code;
	}

	public String getImmediate_Destination_Name() {
		return immediate_Destination_Name;
	}

	public String getImmediate_Origin_Name() {
		return immediate_Origin_Name;
	}

	public String getReference_Code() {
		return reference_Code;
	}

	// batch header getter setter

	public String getBatchHeader_Record_Type_Code() {
		return BatchHeader_Record_Type_Code;
	}

	public String getService_Type_Code() {
		return Service_Type_Code;
	}

	public String getCompany_Name() {
		return Company_Name;
	}

	public String getCompany_Discretionary_Data() {
		return Company_Discretionary_Data;
	}

	public String getCompany_ID_Number() {
		return Company_ID_Number;
	}

	public String getStandard_Entry_Class_Code() {
		return Standard_Entry_Class_Code;
	}

	public String getCompany_Entry_Desc() {
		return Company_Entry_Desc;
	}

	public String getSettlement_DT() {
		return Settlement_DT;
	}

	public String getOriginator_Status_Code() {
		return Originator_Status_Code;
	}

	public String getOriginating_DFI_ID_NBR() {
		return Originating_DFI_ID_NBR;
	}

	public String getBatch_NBR() {
		return Batch_NBR;
	}

	// entrydetail
	public String getEntryDetail_Record_Type_Code() {
		return entryDetail_Record_Type_Code;
	}
	
		public String getEntryDetail_Discretionary_Data() {
		return entryDetail_Discretionary_Data;
	}

	public String getEntryDetail_Addenda_Record_Indicator() {
		return entryDetail_Addenda_Record_Indicator;
	}

	public String getEntryDetail_Originating_DFI_ID() {
		return entryDetail_Originating_DFI_ID;
	}

	
   //  batchControl getter setter
	
	public String getBatchControl_Record_Type_Code() {
		return batchControl_Record_Type_Code;
	}

	public String getService_Class_Code() {
		return Service_Class_Code;
	}

	public String getEntry_Hash() {
		return Entry_Hash;
	}

	public String getBatchControl_Company_ID_Number() {
		return batchControl_Company_ID_Number;
	}

	public String getMessage_Authentication_Code() {
		return Message_Authentication_Code;
	}

	public String getBatchControlReserved() {
		return batchControlReserved;
	}

	public String getBatchControl_Originating_DFI_ID_NBR() {
		return batchControl_Originating_DFI_ID_NBR;
	}

	public String getBatchControl_Batch_NBR() {
		return batchControl_Batch_NBR;
	}

	
	//fileControl getters
	
	public String getFileControl_Record_Type_Code() {
		return fileControl_Record_Type_Code;
	}

	public String getFileControl_Batch_Count() {
		return fileControl_Batch_Count;
	}

	public String getFileControl_Entry_Hash() {
		return fileControl_Entry_Hash;
	}

	public String getFileControl_Reserved() {
		return fileControl_Reserved;
	}


	// fotter getters
	
	public String getFooter() {
		return footer;
	}
	
	

	
	
	
 
	
	
	

}
