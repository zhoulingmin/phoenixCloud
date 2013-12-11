-- MySQL dump 10.13  Distrib 5.5.28, for Win32 (x86)
--
-- Host: 192.168.1.188    Database: PhoenixCloud
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
-- Table structure for table `OPENJPA_SEQUENCE_TABLE`
--

DROP TABLE IF EXISTS `OPENJPA_SEQUENCE_TABLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OPENJPA_SEQUENCE_TABLE` (
  `ID` tinyint(4) NOT NULL,
  `SEQUENCE_VALUE` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OPENJPA_SEQUENCE_TABLE`
--

LOCK TABLES `OPENJPA_SEQUENCE_TABLE` WRITE;
/*!40000 ALTER TABLE `OPENJPA_SEQUENCE_TABLE` DISABLE KEYS */;
/*!40000 ALTER TABLE `OPENJPA_SEQUENCE_TABLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_ddv`
--

DROP TABLE IF EXISTS `pub_ddv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_ddv` (
  `DDV_ID` decimal(12,0) NOT NULL,
  `DDV_CODE` decimal(12,0) NOT NULL,
  `TABLE_NAME` varchar(60) DEFAULT NULL,
  `FIELD_NAME` varchar(60) DEFAULT NULL,
  `VALUE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DDV_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_ddv`
--

LOCK TABLES `pub_ddv` WRITE;
/*!40000 ALTER TABLE `pub_ddv` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_ddv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_hardware`
--

DROP TABLE IF EXISTS `pub_hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_hardware` (
  `HW_ID` decimal(12,0) NOT NULL,
  `HW_TYPE` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV×ÖµäÖµ',
  `CODE` varchar(20) NOT NULL,
  `STAFF_ID` decimal(12,0) DEFAULT NULL COMMENT '¶ÔÓ¦ÕËºÅ±í',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`HW_ID`)
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
-- Table structure for table `pub_org`
--

DROP TABLE IF EXISTS `pub_org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_org` (
  `ORG_ID` decimal(12,0) NOT NULL,
  `ORG_NAME` varchar(60) DEFAULT NULL,
  `ORG_CATA_ID` decimal(12,0) DEFAULT NULL,
  `ORG_TYPE_ID` decimal(12,0) DEFAULT NULL COMMENT '²ÎÕÕPUB_DDV×Öµä±í,»ú¹¹°üÀ¨½ÌÓý¾Ö¡¢Ñ§Ð£¡¢ÆäËûµÈ',
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_ID`)
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
  `ORG_CATA_ID` decimal(12,0) NOT NULL,
  `CATA_NAME` varchar(60) NOT NULL,
  `PARENT_CATA_ID` decimal(12,0) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ORG_CATA_ID`)
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
  `PRESS_ID` decimal(12,0) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1琛ㄧず鍒犻櫎锛?鏍囪瘑姝ｅ父',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_press`
--

LOCK TABLES `pub_press` WRITE;
/*!40000 ALTER TABLE `pub_press` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_press` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pub_server_addr`
--

DROP TABLE IF EXISTS `pub_server_addr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pub_server_addr` (
  `SADDR_ID` decimal(12,0) NOT NULL,
  `ORG_ID` decimal(12,0) NOT NULL COMMENT 'Íâ¼ü±íPUB_ORG',
  `DB_SER_IP` varchar(15) NOT NULL,
  `DB_NAME` varchar(15) NOT NULL,
  `USER_NAME` varchar(15) NOT NULL,
  `PASSWORD` varchar(15) NOT NULL,
  `DB_STRING` varchar(60) NOT NULL,
  `BOOK_SER_IP` varchar(15) NOT NULL,
  `BOOK_DIR` varchar(255) NOT NULL,
  `APP_SER_IP` varchar(15) NOT NULL,
  `APP_USER_NAME` varchar(15) NOT NULL,
  `APP_PASSWORD` varchar(15) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SADDR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pub_server_addr`
--

LOCK TABLES `pub_server_addr` WRITE;
/*!40000 ALTER TABLE `pub_server_addr` DISABLE KEYS */;
/*!40000 ALTER TABLE `pub_server_addr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `r_book`
--

DROP TABLE IF EXISTS `r_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `r_book`
--

LOCK TABLES `r_book` WRITE;
/*!40000 ALTER TABLE `r_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `r_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `r_book_dire`
--

DROP TABLE IF EXISTS `r_book_dire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `r_book_dire`
--

LOCK TABLES `r_book_dire` WRITE;
/*!40000 ALTER TABLE `r_book_dire` DISABLE KEYS */;
/*!40000 ALTER TABLE `r_book_dire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `r_book_log`
--

DROP TABLE IF EXISTS `r_book_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `r_book_log`
--

LOCK TABLES `r_book_log` WRITE;
/*!40000 ALTER TABLE `r_book_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `r_book_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `r_book_res`
--

DROP TABLE IF EXISTS `r_book_res`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `r_book_res`
--

LOCK TABLES `r_book_res` WRITE;
/*!40000 ALTER TABLE `r_book_res` DISABLE KEYS */;
/*!40000 ALTER TABLE `r_book_res` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `r_reg_code`
--

DROP TABLE IF EXISTS `r_reg_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `r_reg_code`
--

LOCK TABLES `r_reg_code` WRITE;
/*!40000 ALTER TABLE `r_reg_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `r_reg_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_log`
--

DROP TABLE IF EXISTS `sys_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_log` (
  `LOG_ID` decimal(18,0) NOT NULL,
  `LOG_TYPE_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `FUNCTION_ID` decimal(12,0) NOT NULL COMMENT '²ÎÕÕPUB_DDV±í',
  `CONTENT` varchar(1000) CHARACTER SET gbk COLLATE gbk_bin DEFAULT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOG_ID`)
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
  `PURVIEW_ID` decimal(12,0) NOT NULL,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(60) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PURVIEW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_purview`
--

LOCK TABLES `sys_purview` WRITE;
/*!40000 ALTER TABLE `sys_purview` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_purview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff`
--

DROP TABLE IF EXISTS `sys_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_staff` (
  `STAFF_ID` decimal(12,0) NOT NULL,
  `ORG_ID` decimal(12,0) DEFAULT NULL,
  `STAFF_TYPE_ID` decimal(12,0) DEFAULT NULL COMMENT '²ÎÕÕPUB_DDV±í,ÆÕÍ¨ÓÃ»§£¬¹ÜÀíÔ±ÓÃ»§',
  `NAME` varchar(20) NOT NULL,
  `CODE` varchar(20) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL,
  `VALID_DATE` date NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff`
--

LOCK TABLES `sys_staff` WRITE;
/*!40000 ALTER TABLE `sys_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff_org_book`
--

DROP TABLE IF EXISTS `sys_staff_org_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_staff_org_book` (
  `SSOB_ID` decimal(12,0) NOT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  `ORG_ID` decimal(12,0) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff_org_book`
--

LOCK TABLES `sys_staff_org_book` WRITE;
/*!40000 ALTER TABLE `sys_staff_org_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_staff_org_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff_purview`
--

DROP TABLE IF EXISTS `sys_staff_purview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_staff_purview` (
  `STA_PUR_ID` decimal(12,0) NOT NULL,
  `STAFF_ID` decimal(12,0) DEFAULT NULL,
  `PURVIEW_ID` decimal(12,0) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
  `CFG_STAFF_ID` decimal(12,0) DEFAULT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`STA_PUR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_staff_purview`
--

LOCK TABLES `sys_staff_purview` WRITE;
/*!40000 ALTER TABLE `sys_staff_purview` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_staff_purview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_staff_reg_code`
--

DROP TABLE IF EXISTS `sys_staff_reg_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_staff_reg_code` (
  `SSRC_ID` decimal(12,0) NOT NULL,
  `STAFF_ID` decimal(12,0) NOT NULL,
  `BOOK_ID` decimal(12,0) NOT NULL,
  `REG_CODE_ID` decimal(12,0) NOT NULL,
  `CREATE_TIME` datetime NOT NULL,
  `UPDATE_TIME` datetime NOT NULL,
  `DELETE_STATE` int(11) NOT NULL COMMENT '1±íÊ¾É¾³ý£¬0±êÊ¶Õý³£',
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

-- Dump completed on 2013-12-11 21:24:05
