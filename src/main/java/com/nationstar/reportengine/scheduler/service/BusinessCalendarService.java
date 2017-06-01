package com.nationstar.reportengine.scheduler.service;

import org.springframework.data.repository.CrudRepository;

import com.nationstar.reportengine.model.BusinessDay;


public interface BusinessCalendarService extends CrudRepository<BusinessDay, String> {

}
