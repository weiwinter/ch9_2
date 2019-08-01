--业务表结构
create table PERSON
(
	id       NUMBER not null primary key,
	name     varchar2(20),
	age      number,
	nation   varchar2(20),
	address  varchar2(20)	
);


--原建表语句：
/*
Navicat Oracle Data Transfer
Oracle Client Version : 11.1.0.7.0

Source Server         : local-oracle-xe-BOOT
Source Server Version : 110200
Source Host           : localhost:1521
Source Schema         : BOOT

Target Server Type    : ORACLE
Target Server Version : 110200
File Encoding         : 65001

Date: 2019-08-01 17:30:54
*/


-- ----------------------------
-- Table structure for PERSON
-- ----------------------------
DROP TABLE "BOOT"."PERSON";
CREATE TABLE "BOOT"."PERSON" (
"ID" NUMBER(19) NOT NULL ,
"ADDRESS" VARCHAR2(255 CHAR) NULL ,
"AGE" NUMBER(10) NULL ,
"NAME" VARCHAR2(255 CHAR) NULL 
)
LOGGING
NOCOMPRESS
NOCACHE

;

-- ----------------------------
-- Records of PERSON
-- ----------------------------
INSERT INTO "BOOT"."PERSON" VALUES ('3', '上海', '30', 'yy');
INSERT INTO "BOOT"."PERSON" VALUES ('4', '南京', '29', 'zz');
INSERT INTO "BOOT"."PERSON" VALUES ('5', '武汉', '28', 'aa');
INSERT INTO "BOOT"."PERSON" VALUES ('6', '合肥', '27', 'bb');
INSERT INTO "BOOT"."PERSON" VALUES ('1', '合肥', '32', '汪云飞');
INSERT INTO "BOOT"."PERSON" VALUES ('2', '北京', '31', 'xx');

-- ----------------------------
-- Indexes structure for table PERSON
-- ----------------------------

-- ----------------------------
-- Checks structure for table PERSON
-- ----------------------------
ALTER TABLE "BOOT"."PERSON" ADD CHECK ("ID" IS NOT NULL);

-- ----------------------------
-- Primary Key structure for table PERSON
-- ----------------------------
ALTER TABLE "BOOT"."PERSON" ADD PRIMARY KEY ("ID");


--------spring batch 元数据建表语句：
--1、批量实例表
CREATE TABLE BATCH_JOB_INSTANCE  (
    JOB_INSTANCE_ID NUMBER(19,0)  NOT NULL PRIMARY KEY ,
    VERSION NUMBER(19,0) ,
    JOB_NAME VARCHAR2(100) NOT NULL,
    JOB_KEY VARCHAR2(32) NOT NULL,
    constraint JOB_INST_UN unique (JOB_NAME, JOB_KEY)
) ;


--2、批量执行表
CREATE TABLE BATCH_JOB_EXECUTION  (
    JOB_EXECUTION_ID NUMBER(19,0)  NOT NULL PRIMARY KEY ,
    VERSION NUMBER(19,0)  ,
    JOB_INSTANCE_ID NUMBER(19,0) NOT NULL,
    CREATE_TIME TIMESTAMP NOT NULL,
    START_TIME TIMESTAMP DEFAULT NULL ,
    END_TIME TIMESTAMP DEFAULT NULL ,
    STATUS VARCHAR2(10) ,
    EXIT_CODE VARCHAR2(2500) ,
    EXIT_MESSAGE VARCHAR2(2500) ,
    LAST_UPDATED TIMESTAMP,
    JOB_CONFIGURATION_LOCATION VARCHAR(2500) NULL,
    constraint JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
    references BATCH_JOB_INSTANCE(JOB_INSTANCE_ID)
) ;


--3、批量执行参数表
CREATE TABLE BATCH_JOB_EXECUTION_PARAMS  (
    JOB_EXECUTION_ID NUMBER(19,0) NOT NULL ,
    TYPE_CD VARCHAR2(6) NOT NULL ,
    KEY_NAME VARCHAR2(100) NOT NULL ,
    STRING_VAL VARCHAR2(250) ,
    DATE_VAL TIMESTAMP DEFAULT NULL ,
    LONG_VAL NUMBER(19,0) ,
    DOUBLE_VAL NUMBER ,
    IDENTIFYING CHAR(1) NOT NULL ,
    constraint JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
    references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;

--4、批量步骤执行表
CREATE TABLE BATCH_STEP_EXECUTION  (
    STEP_EXECUTION_ID NUMBER(19,0)  NOT NULL PRIMARY KEY ,
    VERSION NUMBER(19,0) NOT NULL,
    STEP_NAME VARCHAR2(100) NOT NULL,
    JOB_EXECUTION_ID NUMBER(19,0) NOT NULL,
    START_TIME TIMESTAMP NOT NULL ,
    END_TIME TIMESTAMP DEFAULT NULL ,
    STATUS VARCHAR2(10) ,
    COMMIT_COUNT NUMBER(19,0) ,
    READ_COUNT NUMBER(19,0) ,
    FILTER_COUNT NUMBER(19,0) ,
    WRITE_COUNT NUMBER(19,0) ,
    READ_SKIP_COUNT NUMBER(19,0) ,
    WRITE_SKIP_COUNT NUMBER(19,0) ,
    PROCESS_SKIP_COUNT NUMBER(19,0) ,
    ROLLBACK_COUNT NUMBER(19,0) ,
    EXIT_CODE VARCHAR2(2500) ,
    EXIT_MESSAGE VARCHAR2(2500) ,
    LAST_UPDATED TIMESTAMP,
    constraint JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
    references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;

--5、批量步骤执行内容表
CREATE TABLE BATCH_STEP_EXECUTION_CONTEXT  (
    STEP_EXECUTION_ID NUMBER(19,0) NOT NULL PRIMARY KEY,
    SHORT_CONTEXT VARCHAR2(2500) NOT NULL,
    SERIALIZED_CONTEXT CLOB ,
    constraint STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
    references BATCH_STEP_EXECUTION(STEP_EXECUTION_ID)
) ;

--6、批量任务执行上下文；
CREATE TABLE BATCH_JOB_EXECUTION_CONTEXT  (
    JOB_EXECUTION_ID NUMBER(19,0) NOT NULL PRIMARY KEY,
    SHORT_CONTEXT VARCHAR2(2500) NOT NULL,
    SERIALIZED_CONTEXT CLOB ,
    constraint JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
    references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;


--1、批量任务序列号
create sequence BATCH_JOB_SEQ
minvalue 0
maxvalue 9999999999999999999
start with 0
increment by 1
cache 20;

--2、批量任务执行序列号
create sequence BATCH_JOB_EXECUTION_SEQ
minvalue 0
maxvalue 9999999999999999999
start with 0
increment by 1
cache 20;


--3、批量步骤执行序列号
create sequence BATCH_STEP_EXECUTION_SEQ
minvalue 0
maxvalue 9999999999999999999
start with 0
increment by 1
cache 20;


--查询语句
select a.*,rowId from    BATCH_JOB_INSTANCE a; 
select a.*,rowId from    BATCH_JOB_EXECUTION a; 
select a.*,rowId from    BATCH_JOB_EXECUTION_PARAMS a; 
select a.*,rowId from    BATCH_STEP_EXECUTION a; 
select a.*,rowId from    BATCH_STEP_EXECUTION_CONTEXT a; 
select a.*,rowId from    BATCH_JOB_EXECUTION_CONTEXT a; 


--删除表语句
drop table   BATCH_JOB_INSTANCE cascade constraints;
drop table BATCH_JOB_EXECUTION cascade constraints;
drop table BATCH_JOB_EXECUTION_PARAMS;
drop table BATCH_STEP_EXECUTION cascade constraints;
drop table BATCH_STEP_EXECUTION_CONTEXT;
drop table BATCH_JOB_EXECUTION_CONTEXT;



