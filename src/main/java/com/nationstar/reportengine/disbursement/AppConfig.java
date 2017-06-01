package com.nationstar.reportengine.disbursement;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;

@Configuration
public class AppConfig {
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	@Autowired
	private CustomValidationEventHandler customValidationEventHandler;
	
	@Bean
	public Processor getHandler(){
	  Processor handler= new Processor();
	  handler.setMarshaller(getCastorMarshaller());
	  handler.setUnmarshaller(getCastorMarshaller());
	  return handler;
	}
	@Bean
	public Jaxb2Marshaller getCastorMarshaller() {
	  Resource schemaResource = resourceLoader.getResource("classpath:XSDs/CheckPrinting.xsd");
	  Jaxb2Marshaller jaxb2Marshaller = new Jaxb2Marshaller();
	  jaxb2Marshaller.setPackagesToScan("com.nationstar.reportengine.disbursement.model");
	  Map<String,Object> map = new HashMap<String,Object>();
	  map.put("jaxb.formatted.output", true);
	  jaxb2Marshaller.setMarshallerProperties(map);
	  jaxb2Marshaller.setSchema(schemaResource);
	  jaxb2Marshaller.setValidationEventHandler(customValidationEventHandler);

      return jaxb2Marshaller;
	}
} 
