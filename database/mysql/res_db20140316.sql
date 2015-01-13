/*
SQLyog 企业版 - MySQL GUI v8.14 
MySQL - 5.1.72-community : Database - res_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`res_db` /*!40100 DEFAULT CHARACTER SET gbk */;

USE `res_db`;

/*Table structure for table `r_book` */

DROP TABLE IF EXISTS `r_book`;

CREATE TABLE `r_book` (
  `BOOK_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `BOOK_NO` varchar(60) NOT NULL COMMENT '整个系统唯一，包含跨机构和数据库',
  `PRESS_ID` bigint(12) NOT NULL,
  `SUBJECT_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `STU_SEG_ID` bigint(12) NOT NULL COMMENT '幼儿、小学、初中、高中，参照PUB_DDV表',
  `CLASS_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `KIND_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `PAGE_NUM` int(10) NOT NULL,
  `IP_ADDR` varchar(15) DEFAULT NULL,
  `ALL_ADDR_IN_NET` text,
  `ALL_ADDR_OUT_NET` text,
  `IS_UPLOAD` tinyint(1) NOT NULL COMMENT '1：是，0：否',
  `BOOK_SIZE` int(10),
  `IS_AUDIT` tinyint(1) NOT NULL COMMENT '制作中、待审核、待发布、待上架、上架',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  `COVER_URL_IN_NET` text,
  `COVER_URL_OUT_NET` text,
  `COVER_IMG` mediumblob,
  `COVER_CONT_TYPE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`BOOK_ID`),
  UNIQUE KEY `IND_BOOK_NO` (`BOOK_NO`, `DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_book` */

/*Table structure for table `r_book_dire` */

DROP TABLE IF EXISTS `r_book_dire`;

CREATE TABLE `r_book_dire` (
  `DIRE_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `B_PAGE_NUM` int(10) NOT NULL,
  `E_PAGE_NUM` int(10) NOT NULL,
  `PARENT_DIRE_ID` bigint(12) DEFAULT NULL,
  `LEVEL` tinyint(1) NOT NULL COMMENT '0,1,2,3',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `DIRE_TYPE` TINYINT(1) NOT NULL,
  `SEQ_NO` INT(10) NOT NULL,
  `PAGE_OFFSET` INT(10) NOT NULL,
  PRIMARY KEY (`DIRE_ID`),
  KEY `FK_FK_BOOK_DIRE_BOOK_ID` (`BOOK_ID`),
  CONSTRAINT `FK_FK_BOOK_DIRE_BOOK_ID` FOREIGN KEY (`BOOK_ID`) REFERENCES `r_book` (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_book_dire` */

/*Table structure for table `r_book_log` */

DROP TABLE IF EXISTS `r_book_log`;

CREATE TABLE `r_book_log` (
  `LOG_ID` bigint(18) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) DEFAULT NULL,
  `LOG_TYPE_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `FUNCTION_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `CONTENT` varchar(1000) CHARACTER SET gbk COLLATE gbk_bin DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_book_log` */

/*Table structure for table `r_book_page_res` */

DROP TABLE IF EXISTS `r_book_page_res`;

CREATE TABLE `r_book_page_res` (
  `PAGE_RES_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `PAGE_NUM` int(10) DEFAULT NULL,
  `RES_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PAGE_RES_ID`),
  KEY `FK_FK_BPR_BOOK_ID` (`BOOK_ID`),
  KEY `FK_FK_BPR_RES_ID` (`RES_ID`),
  CONSTRAINT `FK_FK_BPR_RES_ID` FOREIGN KEY (`RES_ID`) REFERENCES `r_book_res` (`RES_ID`),
  CONSTRAINT `FK_FK_BPR_BOOK_ID` FOREIGN KEY (`BOOK_ID`) REFERENCES `r_book` (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_book_page_res` */

/*Table structure for table `r_book_res` */

DROP TABLE IF EXISTS `r_book_res`;

CREATE TABLE `r_book_res` (
  `RES_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `FORMAT` bigint(12) NOT NULL,
  `IS_ENCRYPTED` INT NOT NULL,
  `PARENT_RES_ID` bigint(12) DEFAULT NULL,
  `IP_ADDR` varchar(15) DEFAULT NULL,
  `CATA_ADDR` varchar(255) DEFAULT NULL COMMENT '参照PUB_DDV表',
  `ALL_ADDR_IN_NET` text,
  `ALL_ADDR_OUT_NET` text,
  `IS_UPLOAD` tinyint(1) NOT NULL COMMENT '1：是，0：否',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `IS_AUDIT` tinyint(1) NOT NULL COMMENT '-1:制作中、0:待审核、1:待发布、2:待上架、3:上架',
  `AUDIT_STAFF_ID` bigint(12) NOT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RES_ID`),
  KEY `FK_FK_BOOK_RES_BOOK_ID` (`BOOK_ID`),
  CONSTRAINT `FK_FK_BOOK_RES_BOOK_ID` FOREIGN KEY (`BOOK_ID`) REFERENCES `r_book` (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_book_res` */

/*Table structure for table `r_reg_code` */

DROP TABLE IF EXISTS `r_reg_code`;

CREATE TABLE `r_reg_code` (
  `REG_CODE_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `BOOK_ID` bigint(12) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `IS_VALID` tinyint(1) NOT NULL COMMENT '1：是，0：否',
  `VALID_DATE` date DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `STAFF_ID` bigint(12) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`REG_CODE_ID`),
  KEY `FK_FK_REG_CODE_BOOK_ID` (`BOOK_ID`),
  CONSTRAINT `FK_FK_REG_CODE_BOOK_ID` FOREIGN KEY (`BOOK_ID`) REFERENCES `r_book` (`BOOK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `r_reg_code` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
