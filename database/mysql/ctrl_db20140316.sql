/*
SQLyog 企业版 - MySQL GUI v8.14 
MySQL - 5.1.72-community : Database - ctrl_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ctrl_db` /*!40100 DEFAULT CHARACTER SET gbk */;

USE `ctrl_db`;

/*Table structure for table `pub_ddv` */

DROP TABLE IF EXISTS `pub_ddv`;

CREATE TABLE `pub_ddv` (
  `DDV_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `DDV_CODE` varchar(12) charset utf8 collate utf8_bin NOT NULL,
  `TABLE_NAME` varchar(60) DEFAULT NULL,
  `FIELD_NAME` varchar(60) DEFAULT NULL,
  `VALUE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DDV_ID`),
  KEY `IND_PDV_DDV_CODE` (`DDV_CODE`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_ddv` */

insert  into `pub_ddv`(`DDV_ID`,`DDV_CODE`,`TABLE_NAME`,`FIELD_NAME`,`VALUE`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`NOTES`) values 
(null,'1','pub_org','ORG_TYPE_ID','机构类型1','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'2','pub_org','ORG_TYPE_ID','机构类型2','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'3','pub_org','ORG_TYPE_ID','机构类型3','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'A','r_book','SUBJECT_ID','语文','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'B','r_book','SUBJECT_ID','数学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'C','r_book','SUBJECT_ID','英语','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'D','r_book','SUBJECT_ID','物理','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'E','r_book','SUBJECT_ID','化学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'F','r_book','SUBJECT_ID','生物','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'G','r_book','SUBJECT_ID','思想品德','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'H','r_book','SUBJECT_ID','历史','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'I','r_book','SUBJECT_ID','地理','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'J','r_book','SUBJECT_ID','音乐','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'K','r_book','SUBJECT_ID','体育','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'L','r_book','SUBJECT_ID','美术','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'M','r_book','SUBJECT_ID','信息技术','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'N','r_book','SUBJECT_ID','科学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'O','r_book','SUBJECT_ID','劳动技术','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'P','r_book','SUBJECT_ID','通用技术','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'Q','r_book','SUBJECT_ID','幼儿园','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),

(null,'c','r_book','STU_SEG_ID','幼儿园','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'d','r_book','STU_SEG_ID','小学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'e','r_book','STU_SEG_ID','初中','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'f','r_book','STU_SEG_ID','高中','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),

(null,'01','r_book','CLASS_ID','小班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'02','r_book','CLASS_ID','中班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'03','r_book','CLASS_ID','大班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'01','r_book','CLASS_ID','一年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'02','r_book','CLASS_ID','二年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'03','r_book','CLASS_ID','三年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'04','r_book','CLASS_ID','四年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'05','r_book','CLASS_ID','五年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'06','r_book','CLASS_ID','六年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'07','r_book','CLASS_ID','七年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'08','r_book','CLASS_ID','八年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'09','r_book','CLASS_ID','九年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),

(null,'a','r_book','CLASS_ID','必修','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'b','r_book','CLASS_ID','选修','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'c','r_book','CLASS_ID','模块','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),

(null,'a','r_book','KIND_ID','上册','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'b','r_book','KIND_ID','下册','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),

(null,'01','r_book','KIND_ID','01','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'02','r_book','KIND_ID','02','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'03','r_book','KIND_ID','03','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'04','r_book','KIND_ID','04','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'05','r_book','KIND_ID','05','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'06','r_book','KIND_ID','06','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'07','r_book','KIND_ID','07','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'08','r_book','KIND_ID','08','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'09','r_book','KIND_ID','09','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'10','r_book','KIND_ID','10','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'11','r_book','KIND_ID','11','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'12','r_book','KIND_ID','12','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'13','r_book','KIND_ID','13','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'14','r_book','KIND_ID','14','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'15','r_book','KIND_ID','15','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'16','r_book','KIND_ID','16','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'17','r_book','KIND_ID','17','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'18','r_book','KIND_ID','18','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'19','r_book','KIND_ID','19','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),
(null,'20','r_book','KIND_ID','20','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'高中'),

(null,'32','sys_staff','STAFF_TYPE_ID','超级管理员','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'33','sys_staff','STAFF_TYPE_ID','机构管理员','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'34','sys_staff','STAFF_TYPE_ID','制作审核用户','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'35','sys_staff','STAFF_TYPE_ID','上架审核用户','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'38','r_book_res','FORMAT','图片','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'39','r_book_res','FORMAT','文档','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'38','r_book_res','FORMAT','音频','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'39','r_book_res','FORMAT','视频','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'40','pub_hardware','HW_TYPE','硬盘','2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),
(null,'41','pub_hardware','HW_TYPE','网卡','2014-03-15 22:43:39','2014-03-15 22:43:39',1,''),
(null,'42','pub_hardware','HW_TYPE','CPU','2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),
(null,'43','sys_staff','STAFF_TYPE_ID','教师备课用户','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'');

/*Table structure for table `pub_hardware` */

DROP TABLE IF EXISTS `pub_hardware`;

CREATE TABLE `pub_hardware` (
  `HW_ID` bigint(12) NOT NULL,
  `HW_TYPE` bigint(12) NOT NULL COMMENT '参照PUB_DDV字典值',
  `CODE` varchar(20) NOT NULL,
  `STAFF_ID` bigint(12) DEFAULT NULL COMMENT '对应账号表',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`HW_ID`),
  KEY `IND_PHW_STAFF_ID` (`STAFF_ID`,`DELETE_STATE`),
  KEY `IND_PHW_DELTE_STATE` (`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_hardware` */

/*Table structure for table `pub_hardware_num` */

DROP TABLE IF EXISTS `pub_hardware_num`;

CREATE TABLE `pub_hardware_num` (
  `HW_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `HW_TYPE` bigint(12) NOT NULL COMMENT '参照PUB_DDV字典值',
  `NUM` tinyint(1) NOT NULL,
  `STAFF_ID` bigint(12) DEFAULT NULL COMMENT '对应账号表',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`HW_ID`),
  KEY `IND_PHW_STAFF_ID` (`STAFF_ID`,`DELETE_STATE`),
  KEY `IND_PHW_DELTE_STATE` (`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_hardware_num` */

/*Table structure for table `pub_org` */

DROP TABLE IF EXISTS `pub_org`;

CREATE TABLE `pub_org` (
  `ORG_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_NAME` varchar(60) DEFAULT NULL,
  `ORG_CATA_ID` bigint(12) DEFAULT NULL,
  `ORG_TYPE_ID` bigint(12) DEFAULT NULL COMMENT '参照PUB_DDV字典表,机构包括教育局、学校、其他等',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_ID`),
  KEY `FK_PUB_ORG_CATA_ID` (`ORG_CATA_ID`),
  CONSTRAINT `FK_PUB_ORG_CATA_ID` FOREIGN KEY (`ORG_CATA_ID`) REFERENCES `pub_org_cata` (`ORG_CATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_org` */
INSERT INTO pub_org values(null, '机构1', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, '');

/*Table structure for table `pub_org_cata` */

DROP TABLE IF EXISTS `pub_org_cata`;

CREATE TABLE `pub_org_cata` (
  `ORG_CATA_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `CATA_NAME` varchar(60) NOT NULL,
  `PARENT_CATA_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_CATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_org_cata` */
INSERT INTO pub_org_cata values(NULL, '机构目录1', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, '');

/*Table structure for table `pub_press` */

DROP TABLE IF EXISTS `pub_press`;

CREATE TABLE `pub_press` (
  `PRESS_ID` bigint(12) NOT NULL auto_increment,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) charset utf8 collate utf8_bin NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_press` */

insert  into `pub_press`(`PRESS_ID`,`NAME`,`CODE`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`NOTES`) values 
(null,'苏教版','sj','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'译林版','yl','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'苏科版','ss','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'苏科版','sk','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'人教版','rj','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'苏人版','sr','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'人美版','rm','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'人民版','RM','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'人音版','rv','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'地图版','dt','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'华师版','hs','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'冀教版','jj','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'');

/*Table structure for table `pub_server_addr` */

DROP TABLE IF EXISTS `pub_server_addr`;

CREATE TABLE `pub_server_addr` (
  `SADDR_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) NOT NULL COMMENT '外键表PUB_ORG',
  `NET_TYPE` varchar(20) not null,
  `DB_SER_IP` varchar(15) NOT NULL,
  `DB_NAME` varchar(15) NOT NULL,
  `USER_NAME` varchar(15) NOT NULL,
  `PASSWORD` varchar(15) NOT NULL,
  `DB_STRING` varchar(60) NOT NULL,
  `BOOK_SER_IP` varchar(15) NOT NULL,
  `BOOK_SER_PORT` int(10) NOT NULL,
  `BOOK_DIR` varchar(255) NOT NULL,
  `RES_DIR` varchar(255) NOT NULL,
  `APP_SER_IP` varchar(15) NOT NULL,
  `APP_USER_NAME` varchar(15) NOT NULL,
  `APP_PASSWORD` varchar(15) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SADDR_ID`),
  UNIQUE KEY `IND_PSA_ORG_ID` (`ORG_ID`,`NET_TYPE`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pub_server_addr` */

insert  into `pub_server_addr`(`SADDR_ID`,`ORG_ID`,`NET_TYPE`,`DB_SER_IP`,`DB_NAME`,`USER_NAME`,`PASSWORD`,`DB_STRING`,`BOOK_SER_IP`,`BOOK_SER_PORT`,`BOOK_DIR`,`RES_DIR`,`APP_SER_IP`,`APP_USER_NAME`,`APP_PASSWORD`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`NOTES`) values 
(null,'1','OUT_NET','180.97.46.18','phoenixCloud','root','lySin@mANa84','','180.97.46.18','80','D:\\book\\','D:\\res\\','180.97.46.18','','','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),
(null,'1','IN_NET','10.2.176.201','phoenixCloud','root','lySin@mANa84','','10.2.176.201','80','D:\\book\\','D:\\res\\','10.2.176.201','','','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'');

/*Table structure for table `sys_log` */

DROP TABLE IF EXISTS `sys_log`;

CREATE TABLE `sys_log` (
  `LOG_ID` bigint(18) NOT NULL AUTO_INCREMENT,
  `LOG_TYPE_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `FUNCTION_ID` bigint(12) NOT NULL COMMENT '参照PUB_DDV表',
  `CONTENT` varchar(1000) CHARACTER SET gbk COLLATE gbk_bin DEFAULT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`),
  KEY `FK_FK_SYS_LOG_STAFF_ID` (`STAFF_ID`),
  CONSTRAINT `FK_FK_SYS_LOG_STAFF_ID` FOREIGN KEY (`STAFF_ID`) REFERENCES `sys_staff` (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_log` */

/*Table structure for table `sys_purview` */

DROP TABLE IF EXISTS `sys_purview`;

CREATE TABLE `sys_purview` (
  `PURVIEW_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `PARENT_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PURVIEW_ID`),
  KEY `IND_SYS_PUR_DEL_STA` (`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_purview` */
INSERT  INTO `sys_purview`(`PURVIEW_ID`,`NAME`,`CODE`,`PARENT_ID`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`NOTES`) VALUES 
(1,'个人信息管理菜单','PERSONAL_INFO_MGT_MENU',0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,''),
(11,'个人资料菜单','PERSONAL_INFO_MENU',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(111,'个人资料-保存','PERSONAL_INFO_SAVE',11,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(12,'修改密码','PERSONAL_INFO_UPDATE_PWD',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(13,'授权信息菜单','AUTH_INFO_MENU',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(131,'授权信息-查询','AUTH_INFO_QUERY',13,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(132,'授权信息-设置','AUTH_INFO_UPDATE',13,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(14,'账号管理菜单','ACNT_MGMT_MENU',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(141,'账号管理-增加','ACNT_ADD',14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(142,'账号管理-删除','ACNT_REMOVE',14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(143,'账号管理-修改','ACNT_UPDATE',14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(144,'账号管理-详情','ACNT_DETAIL',14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(15,'机构管理菜单','ORG_MGMT_MENU',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(151,'机构管理-增加','ORG_ADD',15,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(152,'机构管理-查询','ORG_QUERY',15,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(153,'机构管理-修改','ORG_UPDATE',15,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(154,'机构管理-删除','ORG_REMOVE',15,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(155,'机构管理-详情','ORG_DETAIL',15,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(16,'权限管理菜单','PRIVILEGE_MGMT_MENU',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(161,'权限管理-查询','PRIVILEGE_QUERY',16,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(162,'权限管理-更新','PRIVILEGE_UPDATE',16,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(2,'书籍管理菜单','BOOK_MGMT_MENU',0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(21,'书籍制作菜单','BOOK_MAKE_MENU',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(211,'书籍制作-增加','BOOK_ADD',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(212,'书籍制作-修改','BOOK_UPDATE',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(213,'书籍制作-删除','BOOK_REMOVE',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(214,'书籍制作-上传附件','BOOK_UPLOAD',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(215,'书籍制作-编辑目录','BOOK_EDIT_DIR',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(216,'书籍制作-提交审核','BOOK_COMMIT_AUDIT',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(217,'书籍制作-上传封面','BOOK_UPLOAD_COVER',21,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(22,'书籍审核菜单','BOOK_AUDIT_MENU',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(221,'书籍审核-审核通过','BOOK_AUDIT_OK',22,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(222,'书籍审核-审核不通过','BOOK_AUDIT_NO',22,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(23,'书籍发布菜单','BOOK_RELEASE_MENU',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(231,'书籍发布-上架','BOOK_ON_SHELF',23,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(232,'书籍发布-下架','BOOK_OFF_SHELF',23,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(24,'注册码菜单','BOOK_REG_CODE_MGMT_MENU',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(241,'注册码-批量发行','BOOK_REG_CODE_BATCH_GEN',24,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(242,'注册码-批量删除','BOOK_REG_CODE_BATCH_REMOVE',24,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(25,'书籍查询菜单','BOOK_SEARCH_MENU',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(251,'书籍查询-目录','BOOK_SEARCH_DIR',25,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(252,'书籍查询-资源','BOOK_SEARCH_RES',25,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(26,'书籍查询','BOOK_QUERY',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(27,'书籍详情','BOOK_DETAIL',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(28,'书籍下载','BOOK_DOWNLOAD',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(29,'书籍目录查询','BOOK_DIR_QUERY',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(3,'资源管理菜单','RES_MGMT_MENU',0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(31,'资源制作菜单','RES_MAKE_MENU',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(311,'资源制作-创建','RES_ADD',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(312,'资源制作-删除','RES_REMOVE',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(313,'资源制作-修改','RES_UPDATE',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(314,'资源制作-查询','RES_QUERY_BY_PAGE',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(315,'资源制作-上传附件','RES_UPLOAD',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(316,'资源制作-提交审核','RES_COMMIT_AUDIT',31,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(32,'资源审核菜单','RES_AUDIT_MENU',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(321,'资源审核-审核通过','RES_AUDIT_OK',32,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(322,'资源审核-审核不通过','RES_AUDIT_NO',32,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(33,'资源发布菜单','RES_RELEASE_MENU',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(331,'资源发布-上架','RES_ON_SHELF',33,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(332,'资源发布-下架','RES_OFF_SHELF',33,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(34,'资源查询菜单','RES_SEARCH_MENU',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(35,'资源查询','RES_QUERY',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(36,'资源详情','RES_DETAIL',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL),
(37,'资源下载','RES_DOWNLOAD',3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,NULL);
/*Table structure for table `sys_staff` */

DROP TABLE IF EXISTS `sys_staff`;

CREATE TABLE `sys_staff` (
  `STAFF_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) DEFAULT NULL,
  `STAFF_TYPE_ID` bigint(12) DEFAULT NULL COMMENT '参照PUB_DDV表,普通用户，管理员用户',
  `NAME` varchar(20) NOT NULL,
  `CODE` varchar(20) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL,
  `EMAIL` varchar(30),
  `VALID_DATE` date NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`),
  UNIQUE KEY `IND_SYS_STAFF_CODE` (`CODE`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_staff` */

insert  into `sys_staff`(`STAFF_ID`,`ORG_ID`,`STAFF_TYPE_ID`,`NAME`,`CODE`,`PASSWORD`,`VALID_DATE`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`NOTES`) values ('1','1','32','超级管理员','sysAdmin','1','9999-01-01','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'');

/*Table structure for table `sys_staff_purview` */

DROP TABLE IF EXISTS `sys_staff_purview`;

CREATE TABLE `sys_staff_purview` (
  `STA_PUR_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `STAFF_ID` bigint(12) DEFAULT NULL,
  `PURVIEW_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `CFG_STAFF_ID` bigint(12) DEFAULT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STA_PUR_ID`),
  KEY `IND_SSP_STAFF_ID` (`STAFF_ID`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_staff_purview` */

insert into `sys_staff_purview`(`STA_PUR_ID`,`STAFF_ID`,`PURVIEW_ID`,`CREATE_TIME`,`UPDATE_TIME`,`DELETE_STATE`,`CFG_STAFF_ID`,`NOTES`) values 
('1','1','1','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'1',''),
('2','1','16','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'1',''),
('3','1','161','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'1',''),
('4','1','162','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'1','');

/*Table structure for table `sys_staff_reg_code` */

DROP TABLE IF EXISTS `sys_staff_reg_code`;

CREATE TABLE `sys_staff_reg_code` (
  `SSRC_ID` bigint(12) NOT NULL,
  `STAFF_ID` bigint(12) NOT NULL,
  `BOOK_ID` bigint(12) NOT NULL,
  `REG_CODE_ID` bigint(12) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSRC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_staff_reg_code` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
