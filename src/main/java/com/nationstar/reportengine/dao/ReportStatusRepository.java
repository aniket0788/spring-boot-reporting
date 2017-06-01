package com.nationstar.reportengine.dao;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.nationstar.reportengine.model.ReportStatus;

public interface ReportStatusRepository extends CrudRepository<ReportStatus, Long>{
	List<ReportStatus> findByTaskIdOrderByReportProcessingEndTimeDesc(String taskId);
}
