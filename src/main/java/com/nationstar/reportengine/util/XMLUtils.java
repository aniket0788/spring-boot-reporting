package com.nationstar.reportengine.util;

import static com.nationstar.reportengine.util.Constants.AMOUNT;
import static com.nationstar.reportengine.util.Constants.CHECK_DATE;
import static com.nationstar.reportengine.util.Constants.CHECK_NUMBER;
import static com.nationstar.reportengine.util.Constants.CLIENT_ID;
import static com.nationstar.reportengine.util.Constants.CLIENT_TRANSACTION_REFERENCE_NUMBER;
import static com.nationstar.reportengine.util.Constants.DEBIT_ACCOUNT_NUMBER;
import static com.nationstar.reportengine.util.Constants.DEBIT_ROUTING_NUMBER;
import static com.nationstar.reportengine.util.Constants.DELIVERY_METHOD;
import static com.nationstar.reportengine.util.Constants.DOCUMENT_DATE;
import static com.nationstar.reportengine.util.Constants.FORM_CODE;
import static com.nationstar.reportengine.util.Constants.NUMBER;
import static com.nationstar.reportengine.util.Constants.PAYEE_NAME;
import static com.nationstar.reportengine.util.Constants.PAYEE_STATE;
import static com.nationstar.reportengine.util.Constants.PAYEE_STREET;
import static com.nationstar.reportengine.util.Constants.PAYEE_TOWN;
import static com.nationstar.reportengine.util.Constants.PAYEE_ZIP;
import static com.nationstar.reportengine.util.Constants.REMITTANCE_INFO;
import static com.nationstar.reportengine.util.Constants.REMIT_AMOUNT;
import static com.nationstar.reportengine.util.Constants.REMIT_PAY_TYPE;
import static com.nationstar.reportengine.util.Constants.TRANSACTION_TYPE;
import static com.nationstar.reportengine.util.Constants.USD;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.disbursement.Processor;
import com.nationstar.reportengine.disbursement.model.ObjectFactory;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.AdditionalPayeeInformation;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.Amount;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.ChequeInformation;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.ChequeInformation.RmtInf;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.ChequeInformation.RmtInf.Strd;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.CreditAccount;
import com.nationstar.reportengine.disbursement.model.TRIMSInterface.TRIMSTransaction.DebitAccount;
import com.nationstar.reportengine.model.ReportDTO;

@Component
public class XMLUtils {

	private final Logger log = LoggerFactory.getLogger(XMLUtils.class);

	@Autowired
	private DateUtil dateUtil;

	@Autowired
	private Processor processor;

	public boolean generateCheckXML(ReportDTO repDTO, String fileName) throws IOException {
		boolean fileCreated = false;
		
		if (!repDTO.getMappedOutputData().isEmpty()) {
			ObjectFactory objectFactory = new ObjectFactory();

			TRIMSInterface trimsInterface = objectFactory.createTRIMSInterface();


			List<Map<String, Object>> checkDataList = repDTO.getMappedOutputData();

			trimsInterface.setClientID(checkDataList.get(0).get(CLIENT_ID).toString()); // need to set only once
			
			int index=0;
			// set the TRIMSTransaction elements and sub elements
			while(index < checkDataList.size()){
				Boolean filterStub = false;
				if ((checkDataList.get(index).get(REMIT_PAY_TYPE).toString().equalsIgnoreCase("P00")
						|| checkDataList.get(index).get(REMIT_PAY_TYPE).toString().equalsIgnoreCase("44"))) {
					log.debug("Found transaction type " +checkDataList.get(index).get(REMIT_PAY_TYPE).toString() +
							   "to filter RMTINFO for check No::: " +checkDataList.get(index).get(CLIENT_TRANSACTION_REFERENCE_NUMBER).toString() );
					filterStub = true;
				}

				// create XML elements from the objectFactory object

				TRIMSTransaction trimsTransaction = objectFactory.createTRIMSInterfaceTRIMSTransaction();

				Amount amt = objectFactory.createTRIMSInterfaceTRIMSTransactionAmount();

				DebitAccount debit = objectFactory.createTRIMSInterfaceTRIMSTransactionDebitAccount();

				CreditAccount credit = objectFactory.createTRIMSInterfaceTRIMSTransactionCreditAccount();

				AdditionalPayeeInformation additionalPayeeInfo = objectFactory.createTRIMSInterfaceTRIMSTransactionAdditionalPayeeInformation();

				ChequeInformation chequeInfo = objectFactory.createTRIMSInterfaceTRIMSTransactionChequeInformation();

				RmtInf rmtInf = objectFactory.createTRIMSInterfaceTRIMSTransactionChequeInformationRmtInf();

				
				//set the values for elements

				trimsTransaction.setClientTransactionReferenceNumber(checkDataList.get(index).get(CLIENT_TRANSACTION_REFERENCE_NUMBER).toString());
				trimsTransaction.setTransactionType(checkDataList.get(index).get(TRANSACTION_TYPE).toString());
				trimsTransaction.setValueDate((checkDataList.get(index).get(CHECK_DATE).equals("")) ? null : dateUtil.getXMLGregorianCalendar(checkDataList.get(index).get(CHECK_DATE).toString()));

				amt.setCcy(USD);
				amt.setValue((checkDataList.get(index).get(AMOUNT).equals("")) ? null : new BigDecimal(checkDataList.get(index).get(AMOUNT).toString()));
				debit.setAccountNumber(checkDataList.get(index).get(DEBIT_ACCOUNT_NUMBER).toString());
				debit.setRoutingNumber(checkDataList.get(index).get(DEBIT_ROUTING_NUMBER).toString());

				credit.setPayeeName(checkDataList.get(index).get(PAYEE_NAME).toString());

				additionalPayeeInfo.setAddressLine1(checkDataList.get(index).get(PAYEE_STREET).toString());
				additionalPayeeInfo.setTown(checkDataList.get(index).get(PAYEE_TOWN).toString());
				additionalPayeeInfo.setState(checkDataList.get(index).get(PAYEE_STATE).toString());
				additionalPayeeInfo.setZip(checkDataList.get(index).get(PAYEE_ZIP).toString());

				chequeInfo.setChequeNumber(checkDataList.get(index).get(CHECK_NUMBER).toString());
				chequeInfo.setDlvryMtd(checkDataList.get(index).get(DELIVERY_METHOD).toString());
				chequeInfo.setFrmsCd(checkDataList.get(index).get(FORM_CODE).toString());
				int currentIndex, nextIndex = 0;
				// below loop is to map the list of strd and its sub elements
				do {
					Strd strd = objectFactory.createTRIMSInterfaceTRIMSTransactionChequeInformationRmtInfStrd();

					strd.setRltdDt((checkDataList.get(index).get(DOCUMENT_DATE).equals("")) ? null : dateUtil.getXMLGregorianCalendar(checkDataList.get(index).get(DOCUMENT_DATE).toString()));
					strd.setNb(checkDataList.get(index).get(NUMBER).toString().trim());
					strd.setAddtlRmtInf(checkDataList.get(index).get(REMITTANCE_INFO).toString());
					strd.setRmtdAmt((checkDataList.get(index).get(REMIT_AMOUNT).equals("")) ? null : new BigDecimal(checkDataList.get(index).get(REMIT_AMOUNT).toString()));
					
					rmtInf.getStrd().add(strd);

					currentIndex = index;
					nextIndex = ++index;
				}
				while (nextIndex != checkDataList.size() && checkDataList.get(currentIndex).get(CHECK_NUMBER).toString().equals(checkDataList.get(nextIndex).get(CHECK_NUMBER).toString()));

				if (!filterStub) {
					chequeInfo.setRmtInf(rmtInf);
				}
				trimsTransaction.setAmount(amt);
				trimsTransaction.setDebitAccount(debit);
				trimsTransaction.setCreditAccount(credit);
				trimsTransaction.setAdditionalPayeeInformation(additionalPayeeInfo);
				trimsTransaction.setChequeInformation(chequeInfo);

				trimsInterface.getTRIMSTransaction().add(trimsTransaction);
			}

			try {
				processor.objectToXML(fileName, trimsInterface);
			} catch (Exception e) {
				log.error("Conversion to XML failed !", e);
				throw e;
			}
			log.info("Marshaling to XML done and file "+fileName+" is created successfully !");
			fileCreated = true;
		}
		else {
			String warnMsg ="No Data to generate the XML File for " +repDTO.getReportReq().toString();
			log.warn(warnMsg);
		}
		return fileCreated;
	}
}
