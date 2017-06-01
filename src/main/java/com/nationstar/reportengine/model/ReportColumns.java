package com.nationstar.reportengine.model;

public class ReportColumns {
	private String columnName;
	private String columnDescription;
	private String columnType;
	private String sqlColumnName;
	private String mapperClassName;
	private String calculationMapper;
	private String hardCodedValue;
	private String aggregateType;
	
	
	public String getAggregateType() {
		return aggregateType;
	}

	public void setAggregateType(String aggreagateType) {
		this.aggregateType = aggreagateType;
	}
	

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getColumnDescription() {
		return columnDescription;
	}

	public void setColumnDescription(String columnDescription) {
		this.columnDescription = columnDescription;
	}

	public String getColumnType() {
		return columnType;
	}

	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}

	public String getSqlColumnName() {
		return sqlColumnName;
	}

	public void setSqlColumnName(String sqlColumnName) {
		this.sqlColumnName = sqlColumnName;
	}

	public String getMapperClassName() {
		return mapperClassName;
	}

	public void setMapperClassName(String mapperClassName) {
		this.mapperClassName = mapperClassName;
	}

	public String getCalculationMapper() {
		return calculationMapper;
	}

	public void setCalculationMapper(String calculationMapper) {
		this.calculationMapper = calculationMapper;
	}

	public String getHardCodedValue() {
		return hardCodedValue;
	}

	public void setHardCodedValue(String hardCodedValue) {
		this.hardCodedValue = hardCodedValue;
	}

}
