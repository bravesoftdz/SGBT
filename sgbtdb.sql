/*
Navicat MySQL Data Transfer

Source Server         : sg3fprodmysql
Source Server Version : 50628
Source Host           : localhost:3306
Source Database       : sgbtdb

Target Server Type    : MYSQL
Target Server Version : 50628
File Encoding         : 65001

Date: 2017-08-01 21:26:52
*/

--------------------------------------------------
delete from TMACHINESET;
delete from TPOSITIONSET;
delete from T_BIND_CARDHEADID;
delete from T_COIN_INITIAL;
delete from T_COIN_RECHARGE;
delete from T_BAR_FLOW;
delete from T_ACCOUNT_LOG;
delete from T_COIN_LOG;
delete from T_MEMBER_ACCOUNT;
delete from T_MEMBER_CARD_CONFIGURATION;
delete from T_MEMBER_INFO;
delete from T_PRESENT_LOG;





SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `tchargmacset`
-- ----------------------------
DROP TABLE IF EXISTS `TMACHINESET`;
CREATE TABLE `tmachineset` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
   MACHINE_NAME varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
   PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tchargmacset
-- ----------------------------

-- ----------------------------
-- Table structure for `tgameset`
-- ----------------------------
DROP TABLE IF EXISTS `TPOSITIONSET`;
CREATE TABLE `TPOSITIONSET` (
  	ID int(11) NOT NULL AUTO_INCREMENT,  
  `MACHINE_NO` varchar(10) DEFAULT NULL,
  `MACHINE_NAME` varchar(50) DEFAULT NULL,  
  CARD_POSITION_NO varchar(30) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
   PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS T_BIND_CARDHEADID;
CREATE TABLE `T_BIND_CARDHEADID` (
  	ID int(11) NOT NULL AUTO_INCREMENT,    
   CARDHEADID varchar(64) DEFAULT NULL, 
   MACHINE_NAME  varchar(50) DEFAULT NULL,     
   MACHINE_NO varchar(10) DEFAULT NULL,  
   POSITION_NO varchar(30) DEFAULT NULL,
   OPERATE_TIME datetime DEFAULT NULL,
   OPERATOR_NO  varchar(20) DEFAULT NULL,
   PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create unique index IDX_T_BIND_CARDHEADID_CARDHEADID ON T_BIND_CARDHEADID(CARDHEADID);
create unique index IDX_T_BIND_CARDHEADID_POSITION_NO ON T_BIND_CARDHEADID(POSITION_NO);



DROP TABLE IF EXISTS `T_COIN_INITIAL`;
CREATE TABLE `T_COIN_INITIAL` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `COIN_ID` varchar(20) NOT NULL DEFAULT '', 
  `APPID` varchar(20) DEFAULT NULL,
  `SHOPID` varchar(20) DEFAULT NULL,  
  `TYPE_ID` varchar(20) DEFAULT NULL,
  `TYPE_NAME` varchar(20) DEFAULT NULL, 
  `INITIAL_COIN` varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `T_COIN_RECHARGE`;
CREATE TABLE `T_COIN_RECHARGE` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `COIN_ID` varchar(20) DEFAULT NULL,
  `OPER_COIN` int(11) DEFAULT NULL,      
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `T_COIN_REFUND`;
CREATE TABLE `T_COIN_REFUND` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `COIN_ID` varchar(20) DEFAULT NULL,
  `OPER_COIN` int(11) DEFAULT NULL,      
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;








------------------原表----------------------------------
DROP TABLE IF EXISTS `3f_barflow`;
CREATE TABLE `3f_barflow` (
  `ID` bigint(20) DEFAULT NULL, --ok
  `FLOWbar` varchar(30) DEFAULT NULL,
  `COREbar` varchar(30) DEFAULT NULL,
  `CARDID` varchar(20) DEFAULT NULL,
  `CORE` varchar(20) DEFAULT NULL,
  `DATETIME_OPERATE` varchar(20) DEFAULT NULL,
  `DATETIME_SCAN` varchar(20) DEFAULT NULL,
  `Scaner` varchar(20) DEFAULT NULL,
  `MacNo` varchar(10) DEFAULT NULL,
  `GameName` varchar(20) DEFAULT NULL,
  `GameNo` varchar(10) DEFAULT NULL,
  `IDCardNo` varchar(50) DEFAULT NULL,
  `COREVALU_Bili` bigint(20) DEFAULT NULL,
  `Query_Enable` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
----------------------------------------------------

DROP TABLE IF EXISTS T_BAR_FLOW;
CREATE TABLE  T_BAR_FLOW  (
   ID int(11) NOT NULL AUTO_INCREMENT,
   FIRSTBAR varchar(30) DEFAULT NULL,
   SECONDBAR  varchar(30) DEFAULT NULL,  
   CARDHEADID  varchar(50) DEFAULT NULL,  
   COIN  varchar(20) DEFAULT NULL, 
   COIN_PROPORTION varchar(20)  DEFAULT NULL,  
   MACHINE_NAME varchar(20) DEFAULT NULL,
   POSITION_NO  varchar(10) DEFAULT NULL, 
   PRINT_TIME  datetime DEFAULT NULL,
   OPERATE_TIME  datetime DEFAULT NULL,
   OPERATOR_NO varchar(20) DEFAULT NULL,   
    
   PRIMARY KEY (ID)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tgameset
-- ----------------------------

-- ----------------------------
-- Table structure for `t_account_log`
-- ----------------------------
DROP TABLE IF EXISTS `T_ACCOUNT_LOG`;
CREATE TABLE `t_account_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ACCOUNT_CODE` varchar(20) DEFAULT NULL,
  `OPER_AMOUNT` int(11) DEFAULT NULL,
  `OPER_TYPE` varchar(20) DEFAULT NULL,
  `OPER_STATE` varchar(20) DEFAULT NULL,
  `EXT1` varchar(20) DEFAULT NULL,
  `EXT2` varchar(20) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `CREATED_BY` varchar(20) DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `UPDATED_BY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_account_log
-- ----------------------------

-- ----------------------------
-- Table structure for `t_coin_log`
-- ----------------------------
DROP TABLE IF EXISTS `T_COIN_LOG`;
CREATE TABLE `t_coin_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CARD_ID` varchar(20) DEFAULT NULL,
  `OPER_COIN` int(11) DEFAULT NULL,
  `TOTAL_COIN` int(11) DEFAULT NULL,
  `OPER_TYPE` varchar(20) DEFAULT NULL,
  `OPER_STATE` varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_coin_log
-- ----------------------------

-- ----------------------------
-- Table structure for `t_collect_account`
-- ----------------------------
DROP TABLE IF EXISTS `t_collect_account`;
CREATE TABLE `t_collect_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collectid` varchar(20) NOT NULL DEFAULT '',
  `appid` varchar(20) DEFAULT NULL,
  `shopid` varchar(20) DEFAULT NULL,
  `coin` varchar(20) DEFAULT NULL,
  `state` varchar(8) DEFAULT NULL,
  `operatorno` varchar(20) DEFAULT NULL,
  `operatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_collect_account
-- ----------------------------

-- ----------------------------
-- Table structure for `t_id_init`
-- ----------------------------
DROP TABLE IF EXISTS `t_id_init`;
CREATE TABLE `t_id_init` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bandid` varchar(20) NOT NULL DEFAULT '',
  `initdate` varchar(20) DEFAULT NULL,
  `appid` varchar(20) DEFAULT NULL,
  `shopid` varchar(20) DEFAULT NULL,
  `id_type` varchar(20) DEFAULT NULL,
  `id_typename` varchar(20) DEFAULT NULL,
  `coin` varchar(20) DEFAULT NULL,
  `operatorno` varchar(20) DEFAULT NULL,
  `operatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_id_init
-- ----------------------------
INSERT INTO `t_id_init` VALUES ('1', 'F54EF350', '170427', '000427', '000565', 'A5', '用户卡', '0', '001', '2017-06-19 21:19:51');
INSERT INTO `t_id_init` VALUES ('2', 'F54EF350', '170619', '000427', '000565', 'A5', '用户卡', '0', '001', '2017-06-19 21:22:22');
INSERT INTO `t_id_init` VALUES ('3', 'F54EF350', '170619', '000427', '000565', 'A5', '用户卡', '0', '001', '2017-06-19 21:22:30');
INSERT INTO `t_id_init` VALUES ('4', 'FDBD0E27', '170718', '000427', '000565', 'A5', '用户卡', '1306', '001', '2017-07-18 22:31:33');
INSERT INTO `t_id_init` VALUES ('5', 'FDBD0E27', '170718', '000427', '000565', 'A5', '用户卡', '0', '001', '2017-07-18 22:32:00');

-- ----------------------------
-- Table structure for `t_member_account`
-- ----------------------------
DROP TABLE IF EXISTS `t_member_account`;
CREATE TABLE `t_member_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ACCOUNT_CODE` varchar(20) DEFAULT NULL,
  `ACCOUNT_TYPE` varchar(20) DEFAULT NULL,
  `PAYT_TYPE` varchar(20) DEFAULT NULL,
  `TOTAL_COIN` int(11) DEFAULT NULL,
  `LEFT_COIN` int(11) DEFAULT NULL,
  `AVAIL_COIN` int(11) DEFAULT NULL,
  `COIN_LIMIT` int(11) DEFAULT NULL,
  `STATE` varchar(20) DEFAULT NULL,
  `EXPIRETIME` datetime DEFAULT NULL,
  `EXT1` varchar(20) DEFAULT NULL,
  `EXT2` varchar(20) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `CREATED_BY` varchar(20) DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `UPDATED_BY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_member_account
-- ----------------------------

-- ----------------------------
-- Table structure for `t_member_card_configuration`
-- ----------------------------
DROP TABLE IF EXISTS `T_MEMBER_CARD_CONFIGURATION`;
CREATE TABLE `t_member_card_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `COIN_TYPE` varchar(20) DEFAULT NULL,
  `COIN_VALUE` int(11) DEFAULT NULL,
  `COIN_TIME` varchar(20) DEFAULT NULL,
  `APPID` varchar(20) DEFAULT NULL,
  `SHOPID` varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATORNO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_member_card_configuration
-- ----------------------------
INSERT INTO `t_member_card_configuration` VALUES ('7', '1', '10', '2017-07-10 21:57:38', '000427', '000565', '2017-07-10 21:57:38', '000565');
INSERT INTO `t_member_card_configuration` VALUES ('8', '10', '90', '2017-07-10 21:57:46', '000427', '000565', '2017-07-10 21:57:46', '000565');
INSERT INTO `t_member_card_configuration` VALUES ('9', '20', '170', '2017-07-10 21:57:56', '000427', '000565', '2017-07-10 21:57:56', '000565');
INSERT INTO `t_member_card_configuration` VALUES ('10', '50', '420', '2017-07-10 21:58:03', '000427', '000565', '2017-07-10 21:59:16', '000565');
INSERT INTO `t_member_card_configuration` VALUES ('11', '100', '90', '2017-07-16 05:29:41', '000427', '000565', '2017-07-16 05:29:51', '000565');

-- ----------------------------
-- Table structure for `t_member_info`
-- ----------------------------
DROP TABLE IF EXISTS `T_MEMBER_INFO`;
CREATE TABLE `t_member_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `CARD_ID` varchar(20) DEFAULT NULL,
  `PASSWORD` varchar(20) DEFAULT NULL,
  `MOBILE_NO` varchar(20) DEFAULT NULL,
  `COIN_TYPE` varchar(20) DEFAULT NULL,
  `PAY_TYPE` varchar(20) DEFAULT NULL,
  `TOTAL_COIN` int(11) DEFAULT NULL,
  `COIN_LIMIT` int(11) DEFAULT NULL,
  `STATE` varchar(20) DEFAULT NULL,
  `EXPIRETIME` datetime DEFAULT NULL,
  `APPID` varchar(20) DEFAULT NULL,
  `SHOPID` varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATORNO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_member_info
-- ----------------------------
INSERT INTO `t_member_info` VALUES ('1', 'FDBD0E27', 'FDBD0E27', '13580393408', '50', '01', '10', '1000', '正常', null, '000427', '000565', '2017-07-18 22:39:44', '000565');

-- ----------------------------
-- Table structure for `t_present_log`
-- ----------------------------
DROP TABLE IF EXISTS `T_PRESENT_LOG`;
CREATE TABLE `t_present_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PRESENT_NAME` varchar(20) DEFAULT NULL,
  `PRESENT_VALUE` varchar(20) DEFAULT NULL,
  `TOTAL_NUM` int(11) DEFAULT NULL,
  `OPER_NUM` int(11) DEFAULT NULL,
  `OPER_TYPE` varchar(20) DEFAULT NULL,
  `OPER_STATE` varchar(20) DEFAULT NULL,
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_present_log
-- ----------------------------
-- ----------------------------
-- Table structure for `t_recharge_record`
-- ----------------------------
DROP TABLE IF EXISTS `t_recharge_record`;
CREATE TABLE `t_recharge_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trxid` varchar(28) NOT NULL DEFAULT '',
  `appid` varchar(20) DEFAULT NULL,
  `shopid` varchar(20) DEFAULT NULL,
  `bandid` varchar(20) DEFAULT NULL,
  `coin` int(11) DEFAULT NULL,
  `leftcoin` int(11) DEFAULT NULL,
  `totalcoin` int(11) DEFAULT NULL,
  `payid` varchar(20) DEFAULT NULL,
  `operatetime` datetime DEFAULT NULL,
  `operatorno` varchar(20) DEFAULT NULL,
  `note` varchar(20) DEFAULT NULL,
  `paystate` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_recharge_record
-- ----------------------------
