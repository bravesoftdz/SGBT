/*
Navicat MySQL Data Transfer

Source Server         : sg3fprodmysql
Source Server Version : 50628
Source Host           : localhost:3306
Source Database       : sgbtdb

Target Server Type    : MYSQL
Target Server Version : 50628
File Encoding         : 65001

Date: 2017-06-09 14:40:06
*/

SET FOREIGN_KEY_CHECKS=0;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_id_init
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



DROP TABLE IF EXISTS `T_MEMBER_INFO`;
CREATE TABLE `T_MEMBER_INFO` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  
  `CARD_ID` varchar(20) DEFAULT NULL,
  `PASSWORD` varchar(20) DEFAULT NULL,
  `MOBILE_NO` varchar(20) DEFAULT NULL,
  `COIN_TYPE` varchar(20) DEFAULT NULL, 
  `PAY_TYPE` varchar(20) DEFAULT NULL,
  `TOTAL_COIN` INT  DEFAULT NULL,   
  `COIN_LIMIT` INT DEFAULT NULL,
  `STATE` varchar(20) DEFAULT NULL,  
  `EXPIRETIME` datetime DEFAULT NULL,   
  `APPID` varchar(20) DEFAULT NULL,    
  `SHOPID` varchar(20) DEFAULT NULL,    
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATORNO` varchar(20) DEFAULT NULL,  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `T_COIN_LOG`;
CREATE TABLE `T_COIN_LOG` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,  
  `CARD_ID` varchar(20) DEFAULT NULL,
  `OPER_COIN` INT DEFAULT NULL,  
  `TOTAL_COIN` INT  DEFAULT NULL,
  `OPER_TYPE` varchar(20) DEFAULT NULL, 
  `OPER_STATE` varchar(20)   DEFAULT NULL,  
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATOR_NO` varchar(20) DEFAULT NULL,  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table T_MEMBER_CARD_CONFIGURATION;
CREATE TABLE `T_MEMBER_CARD_CONFIGURATION` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  
  `COIN_TYPE` varchar(20) DEFAULT NULL,
  `COIN_VALUE` INT DEFAULT NULL,    
  `COIN_TIME` datetime DEFAULT NULL,  
   `APPID` varchar(20) DEFAULT NULL,    
  `SHOPID` varchar(20) DEFAULT NULL,   
  `OPERATE_TIME` datetime DEFAULT NULL,
  `OPERATORNO` varchar(20) DEFAULT NULL,  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


delete from 
insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('年卡',320,'365','000645');
insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('季卡',80,'90','000645');
insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('月卡',80,'90','000645');




select * from  T_MEMBER_CARD_CONFIGURATION;
delete from t_member_info;
delete from t_member_coin;


CREATE TABLE T_MEMBER_CARD_CONFIGURATION (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  COIN_TYPE varchar(20) DEFAULT NULL,
  COIN_VALUE INT DEFAULT NULL,    
  COIN_TIME varchar(20) DEFAULT NULL,    
  OPERATORNO varchar(20) DEFAULT NULL  
);

insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('年卡',320,'365','000645');
insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('季卡',80,'90','000645');
insert into T_MEMBER_CARD_CONFIGURATION(COIN_TYPE,COIN_VALUE,COIN_TIME,OPERATORNO) values('月卡',80,'90','000645');