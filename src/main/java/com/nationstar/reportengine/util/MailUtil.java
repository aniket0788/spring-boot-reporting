package com.nationstar.reportengine.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Component;

import com.nationstar.reportengine.mapper.RecipientMapper;

import org.springframework.mail.javamail.JavaMailSender;

@Component
public class MailUtil {
  
    @Autowired
    public JavaMailSender emailSender;
    
    @Autowired
    public RecipientMapper recipientMapper;
 
    public void sendMail(String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        String[] to = recipientMapper.getRecipients();
        message.setTo(to); 
        message.setSubject(subject); 
        message.setText(text);
        emailSender.send(message);
    }
}