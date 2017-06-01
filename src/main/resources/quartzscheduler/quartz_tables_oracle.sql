/*delete from IRQRTZ_fired_triggers;
delete from IRQRTZ_simple_triggers;
delete from IRQRTZ_simprop_triggers;
delete from IRQRTZ_cron_triggers;
delete from IRQRTZ_blob_triggers;
delete from IRQRTZ_triggers;
delete from IRQRTZ_job_details;
delete from IRQRTZ_calendars;
delete from IRQRTZ_paused_trigger_grps;
delete from IRQRTZ_locks;
delete from IRQRTZ_scheduler_state;
delete from IRQRTZ_FIRED_JOBLOGS;

drop table IRQRTZ_calendars;
drop table IRQRTZ_fired_triggers;
drop table IRQRTZ_blob_triggers;
drop table IRQRTZ_cron_triggers;
drop table IRQRTZ_simple_triggers;
drop table IRQRTZ_simprop_triggers;
drop table IRQRTZ_triggers;
drop table IRQRTZ_job_details;
drop table IRQRTZ_paused_trigger_grps;
drop table IRQRTZ_locks;
drop table IRQRTZ_scheduler_state;
drop table IRQRTZ_FIRED_JOBLOGS;
*/

CREATE TABLE IRQRTZ_job_details
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL,
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    JOB_CLASS_NAME   VARCHAR2(250) NOT NULL, 
    IS_DURABLE VARCHAR2(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR2(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR2(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NOT NULL,
    JOB_DATA BLOB NULL,
    CONSTRAINT IRQRTZ_JOB_DETAILS_PK PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);
CREATE TABLE IRQRTZ_triggers
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL, 
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    NEXT_FIRE_TIME NUMBER(19) NULL,
    PREV_FIRE_TIME NUMBER(19) NULL,
    PRIORITY NUMBER(13) NULL,
    TRIGGER_STATE VARCHAR2(16) NOT NULL,
    TRIGGER_TYPE VARCHAR2(8) NOT NULL,
    START_TIME NUMBER(19) NOT NULL,
    END_TIME NUMBER(19) NULL,
    CALENDAR_NAME VARCHAR2(200) NULL,
    MISFIRE_INSTR NUMBER(2) NULL,
    JOB_DATA BLOB NULL,
    CONSTRAINT IRQRTZ_TRIGGERS_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT IRQRTZ_TRIGGER_TO_JOBS_FK FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP) 
      REFERENCES IRQRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP) 
);
CREATE TABLE IRQRTZ_simple_triggers
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    REPEAT_COUNT NUMBER(7) NOT NULL,
    REPEAT_INTERVAL NUMBER(12) NOT NULL,
    TIMES_TRIGGERED NUMBER(10) NOT NULL,
    CONSTRAINT IRQRTZ_SIMPLE_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT IRQRTZ_SIMPLE_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
	REFERENCES IRQRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE IRQRTZ_cron_triggers
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    CRON_EXPRESSION VARCHAR2(120) NOT NULL,
    TIME_ZONE_ID VARCHAR2(80),
    CONSTRAINT IRQRTZ_CRON_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT IRQRTZ_CRON_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
      REFERENCES IRQRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE IRQRTZ_simprop_triggers
  (          
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    STR_PROP_1 VARCHAR2(512) NULL,
    STR_PROP_2 VARCHAR2(512) NULL,
    STR_PROP_3 VARCHAR2(512) NULL,
    INT_PROP_1 NUMBER(10) NULL,
    INT_PROP_2 NUMBER(10) NULL,
    LONG_PROP_1 NUMBER(13) NULL,
    LONG_PROP_2 NUMBER(13) NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR2(1) NULL,
    BOOL_PROP_2 VARCHAR2(1) NULL,
    CONSTRAINT IRQRTZ_SIMPROP_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT IRQRTZ_SIMPROP_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
      REFERENCES IRQRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE IRQRTZ_blob_triggers
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    CONSTRAINT IRQRTZ_BLOB_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT IRQRTZ_BLOB_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
        REFERENCES IRQRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE IRQRTZ_calendars
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    CALENDAR_NAME  VARCHAR2(200) NOT NULL, 
    CALENDAR BLOB NOT NULL,
    CONSTRAINT IRQRTZ_CALENDARS_PK PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
);
CREATE TABLE IRQRTZ_paused_trigger_grps
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR2(200) NOT NULL, 
    CONSTRAINT IRQRTZ_PAUSED_TRIG_GRPS_PK PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
);
CREATE TABLE IRQRTZ_fired_triggers 
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    ENTRY_ID VARCHAR2(95) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    FIRED_TIME NUMBER(19) NOT NULL,
    SCHED_TIME NUMBER(19) NOT NULL,
	PRIORITY NUMBER(13) NOT NULL,
    STATE VARCHAR2(16) NOT NULL,
    JOB_NAME VARCHAR2(200) NULL,
    JOB_GROUP VARCHAR2(200) NULL,
    IS_NONCONCURRENT VARCHAR2(1) NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NULL,
    CONSTRAINT IRQRTZ_FIRED_TRIGGER_PK PRIMARY KEY (SCHED_NAME,ENTRY_ID)
);
CREATE TABLE IRQRTZ_scheduler_state 
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    LAST_CHECKIN_TIME NUMBER(19) NOT NULL,
    CHECKIN_INTERVAL NUMBER(13) NOT NULL,
    CONSTRAINT IRQRTZ_SCHEDULER_STATE_PK PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
);
CREATE TABLE IRQRTZ_locks
  (
    SCHED_NAME VARCHAR2(120) NOT NULL,
    LOCK_NAME  VARCHAR2(40) NOT NULL, 
    CONSTRAINT IRQRTZ_LOCKS_PK PRIMARY KEY (SCHED_NAME,LOCK_NAME)
);

CREATE TABLE IRQRTZ_FIRED_JOBLOGS
(
	FIRE_UNIQUEID varchar(120) NOT NULL,
	SCHED_NAME VARCHAR2(120) NOT NULL,
	JOB_NAME  VARCHAR2(200) NOT NULL, 
	JOB_GROUP VARCHAR2(200) NOT NULL,
	TRIGGER_NAME VARCHAR2(200) NOT NULL,
	TRIGGER_GROUP VARCHAR2(200) NOT NULL,
	FIRE_TIME date NOT NULL,
	STATE VARCHAR2(16) NOT NULL,
	LOG_DETAILS VARCHAR2(550) NULL,
	CREATEDON timestamp
);

create index idx_IRQRTZ_j_req_recovery on IRQRTZ_job_details(SCHED_NAME,REQUESTS_RECOVERY);
create index idx_IRQRTZ_j_grp on IRQRTZ_job_details(SCHED_NAME,JOB_GROUP);

create index idx_IRQRTZ_t_j on IRQRTZ_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_IRQRTZ_t_jg on IRQRTZ_triggers(SCHED_NAME,JOB_GROUP);
create index idx_IRQRTZ_t_c on IRQRTZ_triggers(SCHED_NAME,CALENDAR_NAME);
create index idx_IRQRTZ_t_g on IRQRTZ_triggers(SCHED_NAME,TRIGGER_GROUP);
create index idx_IRQRTZ_t_state on IRQRTZ_triggers(SCHED_NAME,TRIGGER_STATE);
create index idx_IRQRTZ_t_n_state on IRQRTZ_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_IRQRTZ_t_n_g_state on IRQRTZ_triggers(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_IRQRTZ_t_next_fire_time on IRQRTZ_triggers(SCHED_NAME,NEXT_FIRE_TIME);
create index idx_IRQRTZ_t_nft_st on IRQRTZ_triggers(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
create index idx_IRQRTZ_t_nft_misfire on IRQRTZ_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
create index idx_IRQRTZ_t_nft_st_misfire on IRQRTZ_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
/*create index idx_IRQRTZ_t_nft_st_misfire_grp on IRQRTZ_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);

create index idx_IRQRTZ_ft_trig_inst_name on IRQRTZ_fired_triggers(SCHED_NAME,INSTANCE_NAME);
create index idx_IRQRTZ_ft_inst_job_req_rcvry on IRQRTZ_fired_triggers(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);*/
create index idx_IRQRTZ_ft_j_g on IRQRTZ_fired_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_IRQRTZ_ft_jg on IRQRTZ_fired_triggers(SCHED_NAME,JOB_GROUP);
create index idx_IRQRTZ_ft_t_g on IRQRTZ_fired_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
create index idx_IRQRTZ_ft_tg on IRQRTZ_fired_triggers(SCHED_NAME,TRIGGER_GROUP);