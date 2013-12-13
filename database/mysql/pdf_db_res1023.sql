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
  `BOOK_ID` decimal(12,0) NOT NULL,
  `ORG_ID` decimal(12,0) NOT NULL,
  `NAME` decimal(12,0) NOT NULL,
  `PRESS_ID` decimal(12,0) NOT NULL,
  `SUBJECT_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `STU_SEG_ID` decimal(12,0) NOT NULL COMMENT 'Ó×¶ù¡¢Ð¡Ñ§¡¢³õÖÐ¡¢¸ßÖÐ£¬²ÎÕÕPUB_DDV±í',
  `CLASS_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `KIND_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `CATA_ADDR_ID` decimal(12,0) DEFAULT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `IP_ADDR` varchar(15) DEFAULT NULL,
  `ALL_ADDR` varchar(60) DEFAULT NULL,
  `IS_UPLOAD` int(11) NOT NULL COMMENT '1£ºÊÇ£¬0£º·ñ',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `STAFF_ID` decimal(12,0) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of r_book
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_dire`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_dire`;
CREATE TABLE `r_book_dire` (
  `DIRE_ID` decimal(12,0) NOT NULL,
  `BOOK_ID` decimal(12,0) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `B_PAGE_NUM` int(11) NOT NULL,
  `E_PAGE_NUM` int(11) NOT NULL,
  `LEVEL` int(11) NOT NULL COMMENT '0,1,2,3',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  PRIMARY KEY (`DIRE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of r_book_dire
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_log`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_log`;
CREATE TABLE `r_book_log` (
  `LOG_ID` decimal(18,0) NOT NULL,
  `BOOK_ID` decimal(12,0) DEFAULT NULL,
  `LOG_TYPE_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `FUNCTION_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `CONTENT` varchar(1000) CHARACTER SET gbk COLLATE gbk_bin DEFAULT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of r_book_log
-- ----------------------------

-- ----------------------------
-- Table structure for `r_book_res`
-- ----------------------------
DROP TABLE IF EXISTS `r_book_res`;
CREATE TABLE `r_book_res` (
  `RES_ID` decimal(12,0) NOT NULL,
  `BOOK_ID` decimal(12,0) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `FORMAT` decimal(12,0) NOT NULL,
  `PARENT_RES_ID` decimal(12,0) DEFAULT NULL,
  `IP_ADDR` varchar(15) DEFAULT NULL,
  `CATA_ADDR` varchar(255) DEFAULT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `ALL_ADDR` varchar(60) DEFAULT NULL,
  `IS_UPLOAD` int(11) NOT NULL COMMENT '1£ºÊÇ£¬0£º·ñ',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `IS_AUDIT` int(11) NOT NULL COMMENT '-1Î´ÉóºË£¬1ÉóºËÍ¨¹ý£¬0ÉóºË²»Í¨¹ý',
  `AUDIT_STAFF_ID` decimal(12,0) NOT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RES_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of r_book_res
-- ----------------------------

-- ----------------------------
-- Table structure for `r_reg_code`
-- ----------------------------
DROP TABLE IF EXISTS `r_reg_code`;
CREATE TABLE `r_reg_code` (
  `REG_CODE_ID` decimal(12,0) NOT NULL,
  `BOOK_ID` decimal(12,0) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `IS_VALID` int(11) NOT NULL COMMENT '1£ºÊÇ£¬0£º·ñ',
  `VALID_DATE` date DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `STAFF_ID` decimal(12,0) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`REG_CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

-- ----------------------------
-- Records of r_reg_code
-- ----------------------------
