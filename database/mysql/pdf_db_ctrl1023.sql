/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50172
Source Host           : localhost:3306
Source Database       : pdf_db_ctrl

Target Server Type    : MYSQL
Target Server Version : 50172
File Encoding         : 65001

Date: 2013-10-23 17:14:33
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `pub_ddv`
-- ----------------------------
DROP TABLE IF EXISTS `pub_ddv`;
CREATE TABLE `pub_ddv` (
  `DDV_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `DDV_CODE` bigint(12) NOT NULL,
  `TABLE_NAME` varchar(60) DEFAULT NULL,
  `FIELD_NAME` varchar(60) DEFAULT NULL,
  `VALUE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '0,1',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DDV_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_ddv
-- ----------------------------

-- ----------------------------
-- Table structure for `pub_hardware`
-- ----------------------------
DROP TABLE IF EXISTS `pub_hardware`;
CREATE TABLE `pub_hardware` (
  `HW_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `HW_TYPE` bigint(12) NOT NULL COMMENT '',
  `CODE` varchar(20) NOT NULL,
  `STAFF_ID` bigint(12) DEFAULT NULL COMMENT '',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`HW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_hardware
-- ----------------------------

-- ----------------------------
-- Table structure for `pub_org`
-- ----------------------------
DROP TABLE IF EXISTS `pub_org`;
CREATE TABLE `pub_org` (
  `ORG_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_NAME` varchar(60) DEFAULT NULL,
  `ORG_CATA_ID` bigint(12) DEFAULT NULL,
  `ORG_TYPE_ID` bigint(12) DEFAULT NULL COMMENT '',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_org
-- ----------------------------

-- ----------------------------
-- Table structure for `pub_org_cata`
-- ----------------------------
DROP TABLE IF EXISTS `pub_org_cata`;
CREATE TABLE `pub_org_cata` (
  `ORG_CATA_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `CATA_NAME` varchar(60) NOT NULL,
  `PARENT_CATA_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_CATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_org_cata
-- ----------------------------

-- ----------------------------
-- Table structure for `pub_press`
-- ----------------------------
DROP TABLE IF EXISTS `pub_press`;
CREATE TABLE `pub_press` (
  `PRESS_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_press
-- ----------------------------

-- ----------------------------
-- Table structure for `pub_server_addr`
-- ----------------------------
DROP TABLE IF EXISTS `pub_server_addr`;
CREATE TABLE `pub_server_addr` (
  `SADDR_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) NOT NULL COMMENT '',
  `DB_SER_IP` varchar(16) NOT NULL,
  `DB_NAME` varchar(15) NOT NULL,
  `USER_NAME` varchar(15) NOT NULL,
  `PASSWORD` varchar(15) NOT NULL,
  `DB_STRING` varchar(60) NOT NULL,
  `BOOK_SER_IP` varchar(16) NOT NULL,
  `BOOK_DIR` varchar(255) NOT NULL,
  `RES_DIR` varchar(255) NOT NULL,
  `APP_SER_IP` varchar(15) NOT NULL,
  `APP_USER_NAME` varchar(15) NOT NULL,
  `APP_PASSWORD` varchar(16) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SADDR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pub_server_addr
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_log`
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `LOG_ID` bigint(18) NOT NULL AUTO_INCREMENT,
  `LOG_TYPE_ID` bigint(12) NOT NULL COMMENT '',
  `FUNCTION_ID` bigint(12) NOT NULL COMMENT '',
  `CONTENT` varchar(1000) DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_log
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_purview`
-- ----------------------------
DROP TABLE IF EXISTS `sys_purview`;
CREATE TABLE `sys_purview` (
  `PURVIEW_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `PARENT_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PURVIEW_ID`),
  UNIQUE KEY `un_purview_code` (`CODE`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_purview
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_staff`
-- ----------------------------
DROP TABLE IF EXISTS `sys_staff`;
CREATE TABLE `sys_staff` (
  `STAFF_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) DEFAULT NULL,
  `STAFF_TYPE_ID` bigint(12) DEFAULT NULL COMMENT '',
  `NAME` varchar(20) NOT NULL,
  `CODE` varchar(20) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL,
  `VALID_DATE` date NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_staff
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_staff_org_book`
-- ----------------------------
DROP TABLE IF EXISTS `sys_staff_org_book`;
CREATE TABLE `sys_staff_org_book` (
  `SSOB_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `STAFF_ID` bigint(12) NOT NULL,
  `ORG_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_staff_org_book
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_staff_purview`
-- ----------------------------
DROP TABLE IF EXISTS `sys_staff_purview`;
CREATE TABLE `sys_staff_purview` (
  `STA_PUR_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `STAFF_ID` bigint(12) DEFAULT NULL,
  `PURVIEW_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `CFG_STAFF_ID` bigint(12) DEFAULT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STA_PUR_ID`),
  UNIQUE KEY `un_staff_purview` (`STAFF_ID`,`PURVIEW_ID`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_staff_purview
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_staff_reg_code`
-- ----------------------------
DROP TABLE IF EXISTS `sys_staff_reg_code`;
CREATE TABLE `sys_staff_reg_code` (
  `SSRC_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `STAFF_ID` bigint(12) NOT NULL,
  `BOOK_ID` bigint(12) NOT NULL,
  `REG_CODE_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSRC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_staff_reg_code
-- ----------------------------
