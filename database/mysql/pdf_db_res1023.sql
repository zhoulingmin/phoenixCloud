/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50172
Source Host           : localhost:3306
Source Database       : pdf_db_res

Target Server Type    : MYSQL
Target Server Version : 50172
File Encoding         : 65001

Date: 2013-10-23 17:15:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `r_book`
-- ----------------------------
DROP TABLE IF EXISTS `r_book`;
CREATE TABLE `r_book` (
  `BOOK_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `BOOK_NO` varchar(60) not null,
  `PRESS_ID` bigint(12) NOT NULL,
  `SUBJECT_ID` bigint(12) NOT NULL COMMENT '',
  `STU_SEG_ID` bigint(12) NOT NULL COMMENT '',
  `CLASS_ID` bigint(12) NOT NULL COMMENT '',
  `KIND_ID` bigint(12) NOT NULL COMMENT '',
  `CATA_ADDR_ID` bigint(12) DEFAULT NULL COMMENT '',
  `IP_ADDR` varchar(16) DEFAULT NULL,
  `ALL_ADDR` text DEFAULT NULL,
  `IS_UPLOAD` tinyint(1) NOT NULL COMMENT '',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of r_book
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_dire`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_dire`;
CREATE TABLE `r_book_dire` (
  `DIRE_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `B_PAGE_NUM` bigint(12) NOT NULL,
  `E_PAGE_NUM` bigint(12) NOT NULL,
  `LEVEL` tinyint(1) NOT NULL COMMENT '0,1,2,3',
  `PARENT_DIRE_ID` bigint(12),
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  PRIMARY KEY (`DIRE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of r_book_dire
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_log`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_log`;
CREATE TABLE `r_book_log` (
  `LOG_ID` bigint(18) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `BOOK_ID` bigint(12) DEFAULT NULL,
  `LOG_TYPE_ID` bigint(12) NOT NULL COMMENT '',
  `FUNCTION_ID` bigint(12) NOT NULL COMMENT '',
  `CONTENT` varchar(1000) DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `NOTES` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of r_book_log
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_res`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_res`;
CREATE TABLE `r_book_res` (
  `RES_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `FORMAT` bigint(12) NOT NULL,
  `PARENT_RES_ID` bigint(12) DEFAULT NULL,
  `IP_ADDR` varchar(16) DEFAULT NULL,
  `CATA_ADDR_ID` bigint(12) DEFAULT NULL COMMENT '',
  `ALL_ADDR` varchar(60) DEFAULT NULL,
  `IS_UPLOAD` tinyint(1) NOT NULL COMMENT '',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `IS_AUDIT` tinyint(1) NOT NULL COMMENT '',
  `AUDIT_STAFF_ID` bigint(12),
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RES_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of r_book_res
-- ----------------------------

-- ----------------------------
-- Table structure for `r_reg_code`
-- ----------------------------
DROP TABLE IF EXISTS `r_reg_code`;
CREATE TABLE `r_reg_code` (
  `REG_CODE_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `IS_VALID` tinyint(1) NOT NULL COMMENT '',
  `VALID_DATE` date DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '',
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`REG_CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of r_reg_code
-- ----------------------------
