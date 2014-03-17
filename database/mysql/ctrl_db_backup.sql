-- MySQL dump 10.13  Distrib 5.5.28, for Win32 (x86)
--
-- Host: 192.168.1.188    Database: ctrl_db
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.2-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pub_ddv`
--

DROP TABLE IF EXISTS `pub_ddv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_ddv` (
  `DDV_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `DDV_CODE` bigint(12) NOT NULL,
  `TABLE_NAME` varchar(60) DEFAULT NULL,
  `FIELD_NAME` varchar(60) DEFAULT NULL,
  `VALUE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DDV_ID`),
  KEY `IND_PDV_DDV_CODE` (`DDV_CODE`,`DELETE_STATE`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_ddv`
--

LOCK TABLES `pub_ddv` WRITE;
/*!40000 ALTER TABLE `pub_ddv` DISABLE KEYS */;
INSERT INTO `pub_ddv` VALUES (1,1,'pub_org','ORG_TYPE_ID','机构类型1','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(2,2,'pub_org','ORG_TYPE_ID','机构类型2','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(3,3,'pub_org','ORG_TYPE_ID','机构类型3','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(4,4,'r_book','SUBJECT_ID','语文','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(5,5,'r_book','SUBJECT_ID','数学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(6,6,'r_book','SUBJECT_ID','英语','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(7,7,'r_book','SUBJECT_ID','物理','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(8,8,'r_book','SUBJECT_ID','化学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(9,9,'r_book','SUBJECT_ID','生物','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(10,10,'r_book','SUBJECT_ID','地理','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(11,11,'r_book','SUBJECT_ID','历史','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(12,12,'r_book','SUBJECT_ID','政治','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(13,13,'r_book','SUBJECT_ID','音乐','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(14,14,'r_book','SUBJECT_ID','美术','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(15,15,'r_book','SUBJECT_ID','体育','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(16,16,'r_book','STU_SEG_ID','高中','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(17,17,'r_book','STU_SEG_ID','初中','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(18,18,'r_book','STU_SEG_ID','小学','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(19,19,'r_book','STU_SEG_ID','幼儿','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(20,20,'r_book','CLASS_ID','一年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(21,21,'r_book','CLASS_ID','二年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(22,22,'r_book','CLASS_ID','三年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(23,23,'r_book','CLASS_ID','四年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(24,24,'r_book','CLASS_ID','五年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(25,25,'r_book','CLASS_ID','六年级','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(26,26,'r_book','CLASS_ID','小班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(27,27,'r_book','CLASS_ID','中班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(28,28,'r_book','CLASS_ID','大班','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(29,29,'r_book','KIND_ID','上册','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(30,30,'r_book','KIND_ID','下册','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(31,31,'r_book','KIND_ID','中册','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(32,32,'sys_staff','STAFF_TYPE_ID','超级管理员','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(33,33,'sys_staff','STAFF_TYPE_ID','管理员','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(34,34,'sys_staff','STAFF_TYPE_ID','普通用户','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(35,38,'r_book_res','FORMAT','图片','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(36,39,'r_book_res','FORMAT','文档','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(37,40,'r_book_res','FORMAT','音频','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(38,41,'r_book_res','FORMAT','视频','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(39,42,'pub_hardware','HW_TYPE','硬盘','2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(40,43,'pub_hardware','HW_TYPE','网卡','2014-03-15 22:43:39','2014-03-15 22:43:39',1,''),(41,44,'pub_hardware','HW_TYPE','CPU','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'');
/*!40000 ALTER TABLE `pub_ddv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_hardware`
--

DROP TABLE IF EXISTS `pub_hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_hardware`
--

LOCK TABLES `pub_hardware` WRITE;
/*!40000 ALTER TABLE `pub_hardware` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_hardware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_hardware_num`
--

DROP TABLE IF EXISTS `pub_hardware_num`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_hardware_num` (
  `HW_ID` bigint(12) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_hardware_num`
--

LOCK TABLES `pub_hardware_num` WRITE;
/*!40000 ALTER TABLE `pub_hardware_num` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_hardware_num` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_org`
--

DROP TABLE IF EXISTS `pub_org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  UNIQUE KEY `IND_PORG_ORG_ID` (`ORG_ID`),
  KEY `FK_PUB_ORG_CATA_ID` (`ORG_CATA_ID`),
  CONSTRAINT `FK_PUB_ORG_CATA_ID` FOREIGN KEY (`ORG_CATA_ID`) REFERENCES `pub_org_cata` (`ORG_CATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_org`
--

LOCK TABLES `pub_org` WRITE;
/*!40000 ALTER TABLE `pub_org` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_org` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_org_cata`
--

DROP TABLE IF EXISTS `pub_org_cata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_org_cata` (
  `ORG_CATA_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `CATA_NAME` varchar(60) NOT NULL,
  `PARENT_CATA_ID` bigint(12) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_CATA_ID`),
  UNIQUE KEY `IND_POC_ORG_CATA_ID` (`ORG_CATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_org_cata`
--

LOCK TABLES `pub_org_cata` WRITE;
/*!40000 ALTER TABLE `pub_org_cata` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_org_cata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_press`
--

DROP TABLE IF EXISTS `pub_press`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_press` (
  `PRESS_ID` bigint(12) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRESS_ID`),
  UNIQUE KEY `IND_PPR_PRESS_ID` (`PRESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_press`
--

LOCK TABLES `pub_press` WRITE;
/*!40000 ALTER TABLE `pub_press` DISABLE KEYS */;
INSERT INTO `pub_press` VALUES (1,'凤凰出版社','1','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(2,'人民教育出版社','2','2014-03-15 22:43:38','2014-03-15 22:43:38',0,''),(3,'江苏教育出版社','3','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'');
/*!40000 ALTER TABLE `pub_press` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_server_addr`
--

DROP TABLE IF EXISTS `pub_server_addr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_server_addr` (
  `SADDR_ID` bigint(12) NOT NULL,
  `ORG_ID` bigint(12) NOT NULL COMMENT '外键表PUB_ORG',
  `DB_SER_IP` varchar(15) NOT NULL,
  `DB_NAME` varchar(15) NOT NULL,
  `USER_NAME` varchar(15) NOT NULL,
  `PASSWORD` varchar(15) NOT NULL,
  `DB_STRING` varchar(60) NOT NULL,
  `BOOK_SER_IP` varchar(15) NOT NULL,
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
  KEY `IND_PSA_ORG_ID` (`ORG_ID`,`DELETE_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_server_addr`
--

LOCK TABLES `pub_server_addr` WRITE;
/*!40000 ALTER TABLE `pub_server_addr` DISABLE KEYS */;
INSERT INTO `pub_server_addr` VALUES (1,1,'127.0.0.1','phoenixCloud','root','lySin@mANa84','','127.0.0.1','D:\\book\\','D:\\res\\','127.0.0.1','','','2014-03-15 22:43:38','2014-03-15 22:43:38',0,'');
/*!40000 ALTER TABLE `pub_server_addr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_log`
--

DROP TABLE IF EXISTS `sys_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_log`
--

LOCK TABLES `sys_log` WRITE;
/*!40000 ALTER TABLE `sys_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_purview`
--

DROP TABLE IF EXISTS `sys_purview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_purview`
--

LOCK TABLES `sys_purview` WRITE;
/*!40000 ALTER TABLE `sys_purview` DISABLE KEYS */;
INSERT INTO `sys_purview` VALUES (1,'机构管理','ORG_MANAGE',0,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(2,'书籍管理','BOOK_MANAGE',0,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(3,'系统管理','SYS_MANAGE',0,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(4,'注册码管理','REG_CODE_MANAGE',0,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(11,'机构菜单','ORG_MENU',1,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(21,'书籍制作菜单','BOOK_MENU',2,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(22,'书籍审核菜单','BOOK_ADUIT_MENU',2,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(23,'书籍发布菜单','BOOK_RELEASE_MENU',2,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(24,'书籍查询菜单','BOOK_QUERY_MENU',2,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(25,'书籍资源查询菜单','BOOK_RES_QUERY_MENU',2,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(31,'账号管理菜单','STAFF_MANAGE_MENU',3,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(32,'权限管理菜单','PURVIEW_MANAGE_MENU',3,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(33,'硬件管理菜单','HARDWARE_MANAGE_MENU',3,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(41,'书籍注册码菜单','BOOK_REG_CODE_MENU',4,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(101,'机构管理-新增','ORG_ADD',11,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(102,'机构管理-修改','ORG_UPDATE',11,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(103,'机构管理-删除','ORG_DELETE',11,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(200,'书籍-新增','BOOK_ADD',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(201,'书籍-修改','BOOK_UPDATE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(202,'书籍-删除','BOOK_DELETE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(203,'书籍-上传附件','BOOK_UPLOAD_AFFIX',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(204,'书籍-编辑目录-新增','BOOK_DIR_ADD',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(205,'书籍-编辑目录-修改','BOOK_DIR_UPDATE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'目录保存功能'),(206,'书籍-编辑目录-删除','BOOK_DIR_DELETE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(207,'书籍-编辑资源-新增','BOOK_RES_ADD',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(208,'书籍-编辑资源-修改','BOOK_RES_UPDATE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(209,'书籍-编辑资源-删除','BOOK_RES_DELETE',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(210,'书籍-编辑资源-附件','BOOK_RES_UPLOAD',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(211,'书籍-提交审核','BOOK_ADUIT_UP',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将制作状态修改为待审核状态'),(212,'书籍-资源-提交审核','BOOK_RES_ADUIT_UP',21,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将制作状态修改为待审核状态'),(213,'书籍-审核通过','BOOK_ADUIT_OK',22,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将待审核状态修改为审核通过状态'),(214,'书籍-审核不通过','BOOK_ADUIT_NO',22,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将待审核状态修改为制作状态'),(215,'书籍-资源-审核通过','BOOK_RES_ADUIT_OK',22,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将待审核状态修改为审核通过状态'),(216,'书籍-资源-审核不通过','BOOK_RES_ADUIT_NO',22,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将待审核状态修改为制作状态'),(217,'书籍-发布','BOOK_RELEASE',23,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将审核通过状态修改为发布状态'),(218,'书籍-资源-发布','BOOK_RES_RELEASE',23,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'将审核通过状态修改为发布状态'),(300,'账号-新增','STAFF_ADD',31,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(301,'账号-修改','STAFF_UPDATE',31,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(302,'账号-删除','STAFF_DELETE',31,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(303,'权限点查询','PURVIEW_QUERY',32,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(304,'权限配置','PURVIEW_CONF',32,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(305,'硬件-增加','HARDWARE_ADD',33,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(306,'硬件-修改','HARDWARE_UPDATE',33,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(307,'硬件-删除','HARDWARE_DELETE',33,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(400,'注册码-新增','BOOK_REG_CODE_ADD',41,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,''),(401,'注册码-删除','BOOK_REG_CODE_DEL',41,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,'');
/*!40000 ALTER TABLE `sys_purview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff`
--

DROP TABLE IF EXISTS `sys_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_staff` (
  `STAFF_ID` bigint(12) NOT NULL AUTO_INCREMENT,
  `ORG_ID` bigint(12) DEFAULT NULL,
  `STAFF_TYPE_ID` bigint(12) DEFAULT NULL COMMENT '参照PUB_DDV表,普通用户，管理员用户',
  `NAME` varchar(20) NOT NULL,
  `CODE` varchar(20) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL,
  `VALID_DATE` date NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` tinyint(1) NOT NULL COMMENT '1表示删除，0标识正常',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`),
  UNIQUE KEY `IND_SYS_STAFF_CODE` (`CODE`,`DELETE_STATE`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff`
--

LOCK TABLES `sys_staff` WRITE;
/*!40000 ALTER TABLE `sys_staff` DISABLE KEYS */;
INSERT INTO `sys_staff` VALUES (1,1,32,'超级管理员','sysAdmin','1','9999-01-01','2014-03-15 22:43:39','2014-03-15 22:43:39',0,'');
/*!40000 ALTER TABLE `sys_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff_purview`
--

DROP TABLE IF EXISTS `sys_staff_purview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff_purview`
--

LOCK TABLES `sys_staff_purview` WRITE;
/*!40000 ALTER TABLE `sys_staff_purview` DISABLE KEYS */;
INSERT INTO `sys_staff_purview` VALUES (1,1,3,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,1,''),(2,1,32,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,1,''),(3,1,303,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,1,''),(4,1,304,'2014-03-15 22:43:39','2014-03-15 22:43:39',0,1,'');
/*!40000 ALTER TABLE `sys_staff_purview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff_reg_code`
--

DROP TABLE IF EXISTS `sys_staff_reg_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff_reg_code`
--

LOCK TABLES `sys_staff_reg_code` WRITE;
/*!40000 ALTER TABLE `sys_staff_reg_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_staff_reg_code` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-03-17 19:17:30
