package com.nationstar.reportengine.disbursement;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.oxm.Marshaller;
import org.springframework.oxm.Unmarshaller;
import org.springframework.stereotype.Component;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

@Component
public class Processor {

    @Autowired
    private Marshaller marshaller;
    @Autowired
    private Unmarshaller unmarshaller;

    public void setMarshaller(Marshaller marshaller) {
        this.marshaller = marshaller;
    }

    public void setUnmarshaller(Unmarshaller unmarshaller) {
        this.unmarshaller = unmarshaller;
    }
    //Converts Object to XML file
    public void objectToXML(String fileName, Object graph) throws IOException {
        FileOutputStream fos = null;
        ByteArrayOutputStream bos = null;
        try {
            bos = new ByteArrayOutputStream();
            marshaller.marshal(graph, new StreamResult(bos));
            //marshalling in memory before writing to file. // if no exception then write to file
            fos = new FileOutputStream(fileName);
            bos.writeTo(fos);
        } finally {
            if(null != fos) {
                fos.close();
            }
            if(null != bos){
                bos.close();
            }
        }
    }
    //Converts XML to Java Object
    public Object xmlToObject(String fileName) throws IOException {
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(fileName);
            return unmarshaller.unmarshal(new StreamSource(fis));
        } finally {
        	fis.close();
        }
    }
} 
