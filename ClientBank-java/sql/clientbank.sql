/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80100 (8.1.0)
 Source Host           : localhost:3306
 Source Schema         : clientbank

 Target Server Type    : MySQL
 Target Server Version : 80100 (8.1.0)
 File Encoding         : 65001

 Date: 10/11/2026 21:17:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bank_account
-- ----------------------------
DROP TABLE IF EXISTS `bank_account`;
CREATE TABLE `bank_account`  (
  `account_id` bigint NOT NULL AUTO_INCREMENT COMMENT '账户ID',
  `user_id` bigint NOT NULL COMMENT '关联sys_user的用户ID',
  `card_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '银行卡号',
  `account_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '账户类型（1-储蓄卡，11是一类卡，12是二类卡；2-信用卡）',
  `balance` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '当前账户余额（保留两位小数）',
  `credit_limit` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '贷款/信用额度',
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'CNY' COMMENT '货币类型',
  `create_time` datetime NULL DEFAULT NULL COMMENT '开户时间',
  `frozen_balance` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '冻结余额',
  `available_balance` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '可用余额',
  PRIMARY KEY (`account_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '银行账户资金表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bank_account
-- ----------------------------
INSERT INTO `bank_account` VALUES (1, 100, '622202196001011234', '11', 212995.00, 200000.00, 'CNY', '2026-10-22 12:24:03', 0.00, 212995.00);
INSERT INTO `bank_account` VALUES (3, 100, '622202197508230001', '12', 1098.90, 30000.00, 'CNY', '2026-10-22 09:15:30', 200.00, 898.90);
INSERT INTO `bank_account` VALUES (4, 100, '622202198205120002', '2', 739.00, 10000.00, 'CNY', '2026-10-22 10:05:12', 309.00, 430.00);
INSERT INTO `bank_account` VALUES (5, 100, '622202199511020003', '2', 3969.00, 10000.00, 'CNY', '2026-10-22 11:30:45', 0.00, 3969.00);
INSERT INTO `bank_account` VALUES (6, 101, '622202198809180004', '2', 300.00, 550.00, 'CNY', '2026-10-22 12:00:00', 298.00, 2.00);
INSERT INTO `bank_account` VALUES (7, 101, '622202199801250005', '11', 103201.00, 500000.00, 'CNY', '2026-10-22 13:01:59', 200.00, 102001.00);

-- ----------------------------
-- Table structure for bank_customer_ext
-- ----------------------------
DROP TABLE IF EXISTS `bank_customer_ext`;
CREATE TABLE `bank_customer_ext`  (
  `ext_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '关联sys_user的用户ID（一对一关联，唯一）',
  `real_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名（与身份证一致）',
  `id_card_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '证件号码（用于实名校验）',
  `residence_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '常用居住地址',
  `account_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账户状态（0正常，1冻结，2挂失）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `age` int NULL DEFAULT NULL COMMENT '用户年龄',
  PRIMARY KEY (`ext_id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '客户信息极简扩展表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bank_customer_ext
-- ----------------------------
INSERT INTO `bank_customer_ext` VALUES (1, 100, '高育良', '420106199001011244', '湖北省武汉市武昌区XX路', '1', '人大代表123', 30);
INSERT INTO `bank_customer_ext` VALUES (2, 101, '祁同伟', '420321555555558888', '汉东省汉东市汉东大街2号', '0', '汉东书籍', 45);

-- ----------------------------
-- Table structure for bank_transaction_log
-- ----------------------------
DROP TABLE IF EXISTS `bank_transaction_log`;
CREATE TABLE `bank_transaction_log`  (
  `id` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `account_id` bigint NOT NULL COMMENT '关联账户ID',
  `transaction_type` tinyint NOT NULL COMMENT '交易类型(1-借款, 2-还款)',
  `amount` decimal(18, 2) NULL DEFAULT NULL COMMENT '交易金额',
  `due_date` datetime NULL DEFAULT NULL COMMENT '到期还款日',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '交易发生时间',
  `accumulated_interest` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '累计产生利息',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态(0-未结清, 1-已结清)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_account_id`(`account_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '借贷流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bank_transaction_log
-- ----------------------------
INSERT INTO `bank_transaction_log` VALUES ('BTLog0210544484', 622202198809180004, 1, 200.00, '2026-11-29 21:56:18', '2026-10-29 21:56:28', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog0433019416', 622202198809180004, 1, 1000.00, '2026-11-29 21:49:36', '2026-10-29 21:54:00', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog0604400533', 622202199511020003, 1, 0.00, '2026-12-01 10:30:41', '2026-10-31 10:30:56', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog0888283994', 622202199511020003, 1, 0.00, '2026-12-01 10:43:38', '2026-10-31 10:44:11', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog1054448049', 622202199801250005, 1, 1000.00, '2026-11-29 21:56:09', '2026-10-29 21:56:16', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog123812321', 1, 1, 1101.00, '2026-10-30 19:58:00', '2026-10-29 19:58:43', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog123812323', 622202196001011234, 1, 0.00, '2026-10-30 20:03:15', '2026-10-29 20:03:18', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog1937303335', 622202199511020003, 1, 0.00, '2026-12-01 10:44:11', '2026-10-31 10:44:21', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog382137812', 622202198809180004, 1, 2000.00, '2026-10-20 20:18:38', '2026-10-29 20:18:48', 20.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog4246993429', 622202198809180004, 1, 10000.00, '2027-10-30 14:32:23', '2026-10-30 14:32:30', 3650.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog4930855220', 622202199511020003, 1, 1000.00, '2026-12-01 10:43:28', '2026-10-31 10:43:38', 31.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog4938557757', 622202199511020003, 1, 1000.00, '2026-12-01 10:38:43', '2026-10-31 10:43:17', 31.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog5592443631', 622202196001011234, 1, 0.00, '2026-12-03 12:56:58', '2026-11-03 12:57:01', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog5761732572', 622202198809180004, 1, 1000.00, '2026-11-30 14:16:51', '2026-10-30 14:17:01', 31.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog6541226410', 622202196001011234, 1, 10000.00, '2029-10-30 15:32:46', '2026-10-30 15:32:48', 10960.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog7563476978', 622202199801250005, 1, 100.00, '2026-11-29 21:56:47', '2026-10-29 21:57:05', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog7577791424', 622202199801250005, 1, 100.00, '2026-11-30 13:56:36', '2026-10-30 13:56:46', 0.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog7998784542', 622202199511020003, 1, 200.00, '2026-12-01 10:35:33', '2026-10-01 10:37:08', 20.00, 0);
INSERT INTO `bank_transaction_log` VALUES ('BTLog8330810280', 622202199511020003, 1, 0.00, '2026-12-01 10:35:07', '2026-10-31 10:35:34', 0.00, 1);
INSERT INTO `bank_transaction_log` VALUES ('BTLog9283491195', 622202199511020003, 1, 0.00, '2026-12-01 10:37:46', '2026-10-31 10:38:43', 0.00, 1);

-- ----------------------------
-- Table structure for biz_reservation
-- ----------------------------
DROP TABLE IF EXISTS `biz_reservation`;
CREATE TABLE `biz_reservation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约单号(主键)',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `service_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务编码(如:OPEN_I_ACCOUNT)',
  `service_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务名称(冗余展示)',
  `service_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '办理渠道(1自主 2需临柜)',
  `reserve_time` datetime NULL DEFAULT NULL COMMENT '预约到店时间(仅临柜需填)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0待处理 1已受理 2已完成 3已取消)',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户备注',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志(0存在 2删除)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '业务预约主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_reservation
-- ----------------------------
INSERT INTO `biz_reservation` VALUES (100, 1, 'OPEN_II_ACCOUNT', 'Ⅱ类户开立', '1', '2026-11-01 19:35:57', '2', '线上自助开通', '0', 'admin', '2026-11-09 19:35:29', '', NULL);
INSERT INTO `biz_reservation` VALUES (101, 2, 'OPEN_I_ACCOUNT', 'Ⅰ类户开卡', '2', '2026-11-10 10:00:00', '0', '需现场核验身份证原件', '0', 'user001', '2026-11-09 19:35:29', '', NULL);

-- ----------------------------
-- Table structure for biz_reservation_log
-- ----------------------------
DROP TABLE IF EXISTS `biz_reservation_log`;
CREATE TABLE `biz_reservation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水主键',
  `reservation_id` bigint NOT NULL COMMENT '预约单号(关联主表id)',
  `handler_id` bigint NOT NULL COMMENT '处理柜员ID',
  `handler_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理柜员姓名',
  `action` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '处理动作(受理/退回/完成)',
  `handle_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '柜员处理意见(原主表审核字段)',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reservation_id`(`reservation_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约处理流水子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of biz_reservation_log
-- ----------------------------
INSERT INTO `biz_reservation_log` VALUES (1, 2, 3, '张柜员', '受理', '已核对预约信息，请客户按时到店', '2026-11-09 19:35:29', '张柜员', '2026-11-09 19:35:29');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (2, 'bank_account', '银行账户资金表', NULL, NULL, 'BankAccount', 'crud', 'element-plus', 'com.ClientBank.manage', 'manage', 'account', '银行账户资金', 'ruoyi', 3, '0', '/', '{\"genView\":\"0\",\"parentMenuId\":2000}', 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43', NULL);
INSERT INTO `gen_table` VALUES (3, 'bank_customer_ext', '客户信息极简扩展表', 'bank_account', 'account_id', 'BankCustomerExt', 'sub', 'element-plus', 'com.ClientBank.manage', 'manage', 'customerExt', '客户信息', 'ruoyi', 3, '0', '/', '{\"genView\":\"0\",\"parentMenuId\":2000}', 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15', NULL);
INSERT INTO `gen_table` VALUES (5, 'transfer_record', '用户转账记录表', NULL, NULL, 'TransferRecord', 'crud', 'element-plus', 'com.ClientBank.manage', 'manage', 'TransferRecord', '用户转账记录', 'WangAiling', 1, '0', '/', '{\"genView\":\"0\",\"parentMenuId\":0}', 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52', NULL);
INSERT INTO `gen_table` VALUES (7, 'bank_transaction_log', '借贷流水表', NULL, NULL, 'BankTransactionLog', 'crud', 'element-plus', 'com.ClientBank.system', 'system', 'log', '借贷流水', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-10-27 18:45:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (8, 'biz_reservation', '业务预约主表', 'biz_reservation_log', 'reservation_id', 'BizReservation', 'sub', 'element-plus', 'com.ClientBank.manage', 'manage', 'reservation', '业务预约表', 'WangAiling', 1, '0', '/', '{\"genView\":\"0\",\"parentMenuId\":0}', 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59', NULL);
INSERT INTO `gen_table` VALUES (9, 'biz_reservation_log', '预约处理流水子表', NULL, NULL, 'BizReservationLog', 'crud', 'element-plus', 'com.ClientBank.system', 'system', 'log', '预约处理流水子', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-11-09 20:15:58', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (21, 2, 'account_id', '账户ID', 'bigint', 'Long', 'accountId', '1', '1', '0', '0', NULL, NULL, '0', 'EQ', 'input', '', 1, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (22, 2, 'user_id', '关联sys_user的用户ID', 'bigint', 'Long', 'userId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 2, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (23, 2, 'card_number', '银行卡号', 'varchar(20)', 'String', 'cardNumber', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 3, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (24, 2, 'account_type', '账户类型（1-储蓄卡，2-信用卡）', 'char(1)', 'String', 'accountType', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'select', '', 4, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (25, 2, 'balance', '当前账户余额（保留两位小数）', 'decimal(18,2)', 'BigDecimal', 'balance', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 5, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (26, 2, 'credit_limit', '贷款/信用额度', 'decimal(18,2)', 'BigDecimal', 'creditLimit', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 6, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (27, 2, 'currency', '货币类型', 'char(3)', 'String', 'currency', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 7, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (28, 2, 'create_time', '开户时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', '0', 'EQ', 'datetime', '', 8, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:43');
INSERT INTO `gen_table_column` VALUES (29, 3, 'ext_id', '主键ID', 'bigint', 'Long', 'extId', '1', '1', '0', '0', NULL, NULL, '0', 'EQ', 'input', '', 1, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (30, 3, 'user_id', '关联sys_user的用户ID（一对一关联，唯一）', 'bigint', 'Long', 'userId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 2, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (31, 3, 'real_name', '真实姓名（与身份证一致）', 'varchar(30)', 'String', 'realName', '0', '0', '0', '0', '0', '1', '0', 'LIKE', 'input', '', 3, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (32, 3, 'id_card_number', '证件号码（用于实名校验）', 'varchar(20)', 'String', 'idCardNumber', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (33, 3, 'residence_address', '常用居住地址', 'varchar(255)', 'String', 'residenceAddress', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'input', '', 5, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (34, 3, 'account_status', '账户状态（0正常，1冻结，2挂失）', 'char(1)', 'String', 'accountStatus', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'radio', '', 6, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (35, 3, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'textarea', '', 7, 'admin', '2026-10-21 23:33:33', '', '2026-10-22 14:07:15');
INSERT INTO `gen_table_column` VALUES (44, 5, 'id', '主键ID', 'bigint', 'Long', 'id', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (45, 5, 'transfer_no', '转账业务单号', 'varchar(64)', 'String', 'transferNo', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 2, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (46, 5, 'from_account_id', '转出账户ID', 'bigint', 'Long', 'fromAccountId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 3, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (47, 5, 'to_account_id', '转入账户ID', 'bigint', 'Long', 'toAccountId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 4, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (48, 5, 'from_user_id', '转出用户ID', 'bigint', 'Long', 'fromUserId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 5, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (49, 5, 'to_user_id', '转入用户ID', 'bigint', 'Long', 'toUserId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 6, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (50, 5, 'amount', '转账金额', 'decimal(20,2)', 'BigDecimal', 'amount', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 7, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (51, 5, 'fee', '手续费', 'decimal(20,2)', 'BigDecimal', 'fee', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 8, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (52, 5, 'status', '状态：0待处理 1成功 2失败 3已取消', 'tinyint', 'Long', 'status', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'radio', '', 9, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (53, 5, 'fail_reason', '失败原因', 'varchar(255)', 'String', 'failReason', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 10, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (54, 5, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (55, 5, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2026-10-22 16:09:24', '', '2026-10-22 16:17:52');
INSERT INTO `gen_table_column` VALUES (68, 7, 'id', '主键ID', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 7, 'account_id', '关联账户ID', 'bigint', 'Long', 'accountId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 7, 'transaction_type', '交易类型(1-借款, 2-还款)', 'tinyint', 'Long', 'transactionType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 7, 'amount', '交易金额', 'decimal(18,2)', 'BigDecimal', 'amount', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 7, 'due_date', '到期还款日', 'datetime', 'Date', 'dueDate', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 5, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 7, 'create_time', '交易发生时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2026-10-27 18:45:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 8, 'id', '预约单号(主键)', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (75, 8, 'user_id', '用户ID', 'bigint', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (76, 8, 'service_code', '服务编码(如:OPEN_I_ACCOUNT)', 'varchar(50)', 'String', 'serviceCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', 'account_type', 3, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (77, 8, 'service_name', '服务名称(冗余展示)', 'varchar(100)', 'String', 'serviceName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (78, 8, 'service_type', '办理渠道(1自主 2需临柜)', 'char(1)', 'String', 'serviceType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'biz_service_type', 5, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (79, 8, 'reserve_time', '预约到店时间(仅临柜需填)', 'datetime', 'Date', 'reserveTime', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 6, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (80, 8, 'status', '状态(0待处理 1已受理 2已完成 3已取消)', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'biz_reservation_status', 7, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (81, 8, 'remark', '用户备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 8, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (82, 8, 'del_flag', '删除标志(0存在 2删除)', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (83, 8, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (84, 8, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (85, 8, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (86, 8, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2026-11-09 20:15:58', '', '2026-11-09 20:44:59');
INSERT INTO `gen_table_column` VALUES (87, 9, 'id', '流水主键', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (88, 9, 'reservation_id', '预约单号(关联主表id)', 'bigint', 'Long', 'reservationId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (89, 9, 'handler_id', '处理柜员ID', 'bigint', 'Long', 'handlerId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (90, 9, 'handler_name', '处理柜员姓名', 'varchar(64)', 'String', 'handlerName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (91, 9, 'action', '处理动作(受理/退回/完成)', 'varchar(30)', 'String', 'action', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (92, 9, 'handle_remark', '柜员处理意见(原主表审核字段)', 'varchar(500)', 'String', 'handleRemark', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 6, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (93, 9, 'handle_time', '处理时间', 'datetime', 'Date', 'handleTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 7, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (94, 9, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2026-11-09 20:15:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (95, 9, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2026-11-09 20:15:58', '', NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2026-10-21 22:32:12', 'admin', '2026-10-22 13:03:18', '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2026-10-21 22:32:12', 'admin', '2026-11-09 18:56:42', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '0', 'Y', 'admin', '2026-10-21 22:32:12', 'admin', '2026-10-30 13:04:16', '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-10-21 22:32:12', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
INSERT INTO `sys_config` VALUES (100, '转账冻结时长', 'transfer.free.hours', '24', 'Y', 'admin', '2026-10-24 20:46:49', '', NULL, '默认 24 小时');
INSERT INTO `sys_config` VALUES (101, '解冻任务是否开启解冻任务是否开启', 'transfer.unfree.enable', 'true', 'Y', 'admin', '2026-10-24 20:47:20', '', NULL, '控制任务是否执行');
INSERT INTO `sys_config` VALUES (102, '借款日利率', 'loan.daily.interest.rate', '0.001', 'N', 'admin', '2026-10-30 14:02:53', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '银行客户部', 0, '王爱灵', '18871961105', '2309683834@qq.com', '0', '0', 'admin', '2026-10-21 23:12:51', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '一类卡', '1', 'account_type', NULL, 'default', 'N', '0', 'admin', '2026-10-21 23:37:56', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 0, '储蓄卡', '2', 'account_type', NULL, 'default', 'N', '0', 'admin', '2026-10-21 23:38:07', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 0, '信用卡', '3', 'account_type', NULL, 'default', 'N', '0', 'admin', '2026-10-21 23:38:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 0, 'Ⅱ类户开立', '1', 'biz_service_type', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:20:32', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (104, 0, 'Ⅰ类户开卡', '2', 'biz_service_type', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:20:42', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (105, 0, '大额取现预约', '3', 'biz_service_type', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:23:03', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (106, 0, '待处理 (刚提交)', '0', 'biz_reservation_status', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:25:21', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (107, 0, '已受理 (柜员接单)', '1', 'biz_reservation_status', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:25:32', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (108, 0, '已完成 (办理完)', '2', 'biz_reservation_status', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:25:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (109, 0, '已取消 (客户放弃)', '3', 'biz_reservation_status', NULL, 'default', 'N', '0', 'admin', '2026-11-09 20:25:47', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '银行卡类型', 'account_type', '0', 'admin', '2026-10-21 23:36:36', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (101, '业务服务清单', 'biz_service_type', '0', 'admin', '2026-11-09 20:19:34', '', NULL, '业务服务清单');
INSERT INTO `sys_dict_type` VALUES (102, '预约状态', 'biz_reservation_status', '0', 'admin', '2026-11-09 20:24:58', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_job` VALUES (100, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '0 0/5 * * * ?', '1', '1', '0', 'admin', '2026-10-24 20:52:56', 'admin', '2026-10-26 23:31:36', '');
INSERT INTO `sys_job` VALUES (101, '逾期账户检查', 'SYSTEM', 'loanOverdueTask.checkAndMarkOverdueAsException', '0 0 0 * * ?', '1', '1', '0', 'admin', '2026-11-03 14:46:37', '', '2026-11-03 14:46:49', '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 293 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------
INSERT INTO `sys_job_log` VALUES (1, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-26 23:40:40', '2026-10-26 23:40:40', '2026-10-26 23:40:39');
INSERT INTO `sys_job_log` VALUES (2, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：19毫秒', '0', '', '2026-10-26 23:43:33', '2026-10-26 23:43:33', '2026-10-26 23:43:32');
INSERT INTO `sys_job_log` VALUES (3, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-26 23:44:17', '2026-10-26 23:44:17', '2026-10-26 23:44:16');
INSERT INTO `sys_job_log` VALUES (4, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-10-26 23:44:51', '2026-10-26 23:44:51', '2026-10-26 23:44:51');
INSERT INTO `sys_job_log` VALUES (5, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-26 23:45:00', '2026-10-26 23:45:00', '2026-10-26 23:45:00');
INSERT INTO `sys_job_log` VALUES (6, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-26 23:45:44', '2026-10-26 23:45:44', '2026-10-26 23:45:43');
INSERT INTO `sys_job_log` VALUES (7, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：16毫秒', '0', '', '2026-10-26 23:55:00', '2026-10-26 23:55:00', '2026-10-26 23:55:00');
INSERT INTO `sys_job_log` VALUES (8, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：44毫秒', '0', '', '2026-10-27 12:30:00', '2026-10-27 12:30:00', '2026-10-27 12:30:00');
INSERT INTO `sys_job_log` VALUES (9, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 12:35:00', '2026-10-27 12:35:00', '2026-10-27 12:35:00');
INSERT INTO `sys_job_log` VALUES (10, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-27 12:40:00', '2026-10-27 12:40:00', '2026-10-27 12:40:00');
INSERT INTO `sys_job_log` VALUES (11, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-10-27 12:45:00', '2026-10-27 12:45:00', '2026-10-27 12:45:00');
INSERT INTO `sys_job_log` VALUES (12, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 12:50:00', '2026-10-27 12:50:00', '2026-10-27 12:50:00');
INSERT INTO `sys_job_log` VALUES (13, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-27 12:55:00', '2026-10-27 12:55:00', '2026-10-27 12:55:00');
INSERT INTO `sys_job_log` VALUES (14, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-27 13:00:00', '2026-10-27 13:00:00', '2026-10-27 13:00:00');
INSERT INTO `sys_job_log` VALUES (15, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-27 13:05:00', '2026-10-27 13:05:00', '2026-10-27 13:05:00');
INSERT INTO `sys_job_log` VALUES (16, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-27 13:10:00', '2026-10-27 13:10:00', '2026-10-27 13:10:00');
INSERT INTO `sys_job_log` VALUES (17, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-27 13:15:00', '2026-10-27 13:15:00', '2026-10-27 13:15:00');
INSERT INTO `sys_job_log` VALUES (18, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-27 13:20:00', '2026-10-27 13:20:00', '2026-10-27 13:20:00');
INSERT INTO `sys_job_log` VALUES (19, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：35毫秒', '0', '', '2026-10-27 13:25:00', '2026-10-27 13:25:00', '2026-10-27 13:25:00');
INSERT INTO `sys_job_log` VALUES (20, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 13:30:00', '2026-10-27 13:30:00', '2026-10-27 13:30:00');
INSERT INTO `sys_job_log` VALUES (21, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-10-27 13:35:00', '2026-10-27 13:35:00', '2026-10-27 13:35:00');
INSERT INTO `sys_job_log` VALUES (22, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 13:40:00', '2026-10-27 13:40:00', '2026-10-27 13:40:00');
INSERT INTO `sys_job_log` VALUES (23, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-27 13:45:00', '2026-10-27 13:45:00', '2026-10-27 13:45:00');
INSERT INTO `sys_job_log` VALUES (24, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-27 13:50:00', '2026-10-27 13:50:00', '2026-10-27 13:50:00');
INSERT INTO `sys_job_log` VALUES (25, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-27 13:55:00', '2026-10-27 13:55:00', '2026-10-27 13:55:00');
INSERT INTO `sys_job_log` VALUES (26, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-27 14:00:00', '2026-10-27 14:00:00', '2026-10-27 14:00:00');
INSERT INTO `sys_job_log` VALUES (27, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 14:05:00', '2026-10-27 14:05:00', '2026-10-27 14:05:00');
INSERT INTO `sys_job_log` VALUES (28, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-27 14:10:00', '2026-10-27 14:10:00', '2026-10-27 14:10:00');
INSERT INTO `sys_job_log` VALUES (29, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-27 14:15:00', '2026-10-27 14:15:00', '2026-10-27 14:15:00');
INSERT INTO `sys_job_log` VALUES (30, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：67毫秒', '0', '', '2026-10-27 18:30:00', '2026-10-27 18:30:00', '2026-10-27 18:30:00');
INSERT INTO `sys_job_log` VALUES (31, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-27 18:35:00', '2026-10-27 18:35:00', '2026-10-27 18:35:00');
INSERT INTO `sys_job_log` VALUES (32, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-27 18:40:00', '2026-10-27 18:40:00', '2026-10-27 18:40:00');
INSERT INTO `sys_job_log` VALUES (33, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-27 18:45:00', '2026-10-27 18:45:00', '2026-10-27 18:45:00');
INSERT INTO `sys_job_log` VALUES (34, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-27 18:50:00', '2026-10-27 18:50:00', '2026-10-27 18:50:00');
INSERT INTO `sys_job_log` VALUES (35, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-27 18:55:00', '2026-10-27 18:55:00', '2026-10-27 18:55:00');
INSERT INTO `sys_job_log` VALUES (36, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：35毫秒', '0', '', '2026-10-27 19:20:00', '2026-10-27 19:20:00', '2026-10-27 19:20:00');
INSERT INTO `sys_job_log` VALUES (37, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-27 19:25:00', '2026-10-27 19:25:00', '2026-10-27 19:25:00');
INSERT INTO `sys_job_log` VALUES (38, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-27 19:30:00', '2026-10-27 19:30:00', '2026-10-27 19:30:00');
INSERT INTO `sys_job_log` VALUES (39, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：24毫秒', '0', '', '2026-10-29 13:30:00', '2026-10-29 13:30:00', '2026-10-29 13:30:00');
INSERT INTO `sys_job_log` VALUES (40, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：19毫秒', '0', '', '2026-10-29 13:35:00', '2026-10-29 13:35:00', '2026-10-29 13:35:00');
INSERT INTO `sys_job_log` VALUES (41, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 13:40:00', '2026-10-29 13:40:00', '2026-10-29 13:40:00');
INSERT INTO `sys_job_log` VALUES (42, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 13:45:00', '2026-10-29 13:45:00', '2026-10-29 13:45:00');
INSERT INTO `sys_job_log` VALUES (43, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 13:50:00', '2026-10-29 13:50:00', '2026-10-29 13:50:00');
INSERT INTO `sys_job_log` VALUES (44, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 13:55:00', '2026-10-29 13:55:00', '2026-10-29 13:55:00');
INSERT INTO `sys_job_log` VALUES (45, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 14:00:00', '2026-10-29 14:00:00', '2026-10-29 14:00:00');
INSERT INTO `sys_job_log` VALUES (46, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-29 14:05:00', '2026-10-29 14:05:00', '2026-10-29 14:05:00');
INSERT INTO `sys_job_log` VALUES (47, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：9毫秒', '0', '', '2026-10-29 14:10:00', '2026-10-29 14:10:00', '2026-10-29 14:10:00');
INSERT INTO `sys_job_log` VALUES (48, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-29 14:15:00', '2026-10-29 14:15:00', '2026-10-29 14:15:00');
INSERT INTO `sys_job_log` VALUES (49, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-29 14:20:00', '2026-10-29 14:20:00', '2026-10-29 14:20:00');
INSERT INTO `sys_job_log` VALUES (50, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-29 14:25:00', '2026-10-29 14:25:00', '2026-10-29 14:25:00');
INSERT INTO `sys_job_log` VALUES (51, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-29 14:30:00', '2026-10-29 14:30:00', '2026-10-29 14:30:00');
INSERT INTO `sys_job_log` VALUES (52, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 14:35:00', '2026-10-29 14:35:00', '2026-10-29 14:35:00');
INSERT INTO `sys_job_log` VALUES (53, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 14:40:00', '2026-10-29 14:40:00', '2026-10-29 14:40:00');
INSERT INTO `sys_job_log` VALUES (54, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 14:45:00', '2026-10-29 14:45:00', '2026-10-29 14:45:00');
INSERT INTO `sys_job_log` VALUES (55, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 14:50:00', '2026-10-29 14:50:00', '2026-10-29 14:50:00');
INSERT INTO `sys_job_log` VALUES (56, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 14:55:00', '2026-10-29 14:55:00', '2026-10-29 14:55:00');
INSERT INTO `sys_job_log` VALUES (57, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-29 15:00:00', '2026-10-29 15:00:00', '2026-10-29 15:00:00');
INSERT INTO `sys_job_log` VALUES (58, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 15:05:00', '2026-10-29 15:05:00', '2026-10-29 15:05:00');
INSERT INTO `sys_job_log` VALUES (59, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 15:10:00', '2026-10-29 15:10:00', '2026-10-29 15:10:00');
INSERT INTO `sys_job_log` VALUES (60, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 15:15:00', '2026-10-29 15:15:00', '2026-10-29 15:15:00');
INSERT INTO `sys_job_log` VALUES (61, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：18毫秒', '0', '', '2026-10-29 15:20:00', '2026-10-29 15:20:00', '2026-10-29 15:20:00');
INSERT INTO `sys_job_log` VALUES (62, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-29 15:25:00', '2026-10-29 15:25:00', '2026-10-29 15:25:00');
INSERT INTO `sys_job_log` VALUES (63, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：34毫秒', '0', '', '2026-10-29 17:15:00', '2026-10-29 17:15:00', '2026-10-29 17:15:00');
INSERT INTO `sys_job_log` VALUES (64, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：18毫秒', '0', '', '2026-10-29 18:50:00', '2026-10-29 18:50:00', '2026-10-29 18:50:00');
INSERT INTO `sys_job_log` VALUES (65, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-10-29 18:55:00', '2026-10-29 18:55:00', '2026-10-29 18:55:00');
INSERT INTO `sys_job_log` VALUES (66, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:00:00', '2026-10-29 19:00:00', '2026-10-29 19:00:00');
INSERT INTO `sys_job_log` VALUES (67, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：16毫秒', '0', '', '2026-10-29 19:05:00', '2026-10-29 19:05:00', '2026-10-29 19:05:00');
INSERT INTO `sys_job_log` VALUES (68, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:10:00', '2026-10-29 19:10:00', '2026-10-29 19:10:00');
INSERT INTO `sys_job_log` VALUES (69, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:15:00', '2026-10-29 19:15:00', '2026-10-29 19:15:00');
INSERT INTO `sys_job_log` VALUES (70, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:20:00', '2026-10-29 19:20:00', '2026-10-29 19:20:00');
INSERT INTO `sys_job_log` VALUES (71, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 19:25:00', '2026-10-29 19:25:00', '2026-10-29 19:25:00');
INSERT INTO `sys_job_log` VALUES (72, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 19:30:00', '2026-10-29 19:30:00', '2026-10-29 19:30:00');
INSERT INTO `sys_job_log` VALUES (73, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:35:00', '2026-10-29 19:35:00', '2026-10-29 19:35:00');
INSERT INTO `sys_job_log` VALUES (74, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-29 19:40:00', '2026-10-29 19:40:00', '2026-10-29 19:40:00');
INSERT INTO `sys_job_log` VALUES (75, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:45:00', '2026-10-29 19:45:00', '2026-10-29 19:45:00');
INSERT INTO `sys_job_log` VALUES (76, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 19:50:00', '2026-10-29 19:50:00', '2026-10-29 19:50:00');
INSERT INTO `sys_job_log` VALUES (77, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 19:55:00', '2026-10-29 19:55:00', '2026-10-29 19:55:00');
INSERT INTO `sys_job_log` VALUES (78, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-29 20:00:00', '2026-10-29 20:00:00', '2026-10-29 20:00:00');
INSERT INTO `sys_job_log` VALUES (79, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 20:05:00', '2026-10-29 20:05:00', '2026-10-29 20:05:00');
INSERT INTO `sys_job_log` VALUES (80, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 20:10:00', '2026-10-29 20:10:00', '2026-10-29 20:10:00');
INSERT INTO `sys_job_log` VALUES (81, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-29 20:15:00', '2026-10-29 20:15:00', '2026-10-29 20:15:00');
INSERT INTO `sys_job_log` VALUES (82, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-29 20:20:00', '2026-10-29 20:20:00', '2026-10-29 20:20:00');
INSERT INTO `sys_job_log` VALUES (83, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：15毫秒', '0', '', '2026-10-29 20:25:00', '2026-10-29 20:25:00', '2026-10-29 20:25:00');
INSERT INTO `sys_job_log` VALUES (84, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：9毫秒', '0', '', '2026-10-29 20:30:00', '2026-10-29 20:30:00', '2026-10-29 20:30:00');
INSERT INTO `sys_job_log` VALUES (85, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：28毫秒', '0', '', '2026-10-29 20:35:02', '2026-10-29 20:35:02', '2026-10-29 20:35:01');
INSERT INTO `sys_job_log` VALUES (86, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-10-29 20:40:00', '2026-10-29 20:40:00', '2026-10-29 20:40:00');
INSERT INTO `sys_job_log` VALUES (87, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-29 20:45:00', '2026-10-29 20:45:00', '2026-10-29 20:45:00');
INSERT INTO `sys_job_log` VALUES (88, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-29 20:50:00', '2026-10-29 20:50:00', '2026-10-29 20:50:00');
INSERT INTO `sys_job_log` VALUES (89, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 20:55:00', '2026-10-29 20:55:00', '2026-10-29 20:55:00');
INSERT INTO `sys_job_log` VALUES (90, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-29 21:00:00', '2026-10-29 21:00:00', '2026-10-29 21:00:00');
INSERT INTO `sys_job_log` VALUES (91, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 21:05:00', '2026-10-29 21:05:00', '2026-10-29 21:05:00');
INSERT INTO `sys_job_log` VALUES (92, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 21:10:00', '2026-10-29 21:10:00', '2026-10-29 21:10:00');
INSERT INTO `sys_job_log` VALUES (93, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 21:15:00', '2026-10-29 21:15:00', '2026-10-29 21:15:00');
INSERT INTO `sys_job_log` VALUES (94, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 21:20:00', '2026-10-29 21:20:00', '2026-10-29 21:20:00');
INSERT INTO `sys_job_log` VALUES (95, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 21:25:00', '2026-10-29 21:25:00', '2026-10-29 21:25:00');
INSERT INTO `sys_job_log` VALUES (96, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-29 21:30:00', '2026-10-29 21:30:00', '2026-10-29 21:30:00');
INSERT INTO `sys_job_log` VALUES (97, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 21:35:00', '2026-10-29 21:35:00', '2026-10-29 21:35:00');
INSERT INTO `sys_job_log` VALUES (98, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-29 21:40:00', '2026-10-29 21:40:00', '2026-10-29 21:40:00');
INSERT INTO `sys_job_log` VALUES (99, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-29 21:45:00', '2026-10-29 21:45:00', '2026-10-29 21:45:00');
INSERT INTO `sys_job_log` VALUES (100, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-29 21:50:00', '2026-10-29 21:50:00', '2026-10-29 21:50:00');
INSERT INTO `sys_job_log` VALUES (101, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-29 21:55:00', '2026-10-29 21:55:00', '2026-10-29 21:55:00');
INSERT INTO `sys_job_log` VALUES (102, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：25毫秒', '0', '', '2026-10-30 13:05:00', '2026-10-30 13:05:00', '2026-10-30 13:05:00');
INSERT INTO `sys_job_log` VALUES (103, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：22毫秒', '0', '', '2026-10-30 13:10:00', '2026-10-30 13:10:00', '2026-10-30 13:10:00');
INSERT INTO `sys_job_log` VALUES (104, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-10-30 13:15:00', '2026-10-30 13:15:00', '2026-10-30 13:15:00');
INSERT INTO `sys_job_log` VALUES (105, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：15毫秒', '0', '', '2026-10-30 13:20:00', '2026-10-30 13:20:00', '2026-10-30 13:20:00');
INSERT INTO `sys_job_log` VALUES (106, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：9毫秒', '0', '', '2026-10-30 13:25:00', '2026-10-30 13:25:00', '2026-10-30 13:25:00');
INSERT INTO `sys_job_log` VALUES (107, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：22毫秒', '0', '', '2026-10-30 13:35:00', '2026-10-30 13:35:00', '2026-10-30 13:35:00');
INSERT INTO `sys_job_log` VALUES (108, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-30 13:40:00', '2026-10-30 13:40:00', '2026-10-30 13:40:00');
INSERT INTO `sys_job_log` VALUES (109, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：33毫秒', '0', '', '2026-10-30 13:45:00', '2026-10-30 13:45:00', '2026-10-30 13:45:00');
INSERT INTO `sys_job_log` VALUES (110, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：32毫秒', '0', '', '2026-10-30 13:50:00', '2026-10-30 13:50:00', '2026-10-30 13:50:00');
INSERT INTO `sys_job_log` VALUES (111, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-30 13:55:00', '2026-10-30 13:55:00', '2026-10-30 13:55:00');
INSERT INTO `sys_job_log` VALUES (112, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-30 14:00:00', '2026-10-30 14:00:00', '2026-10-30 14:00:00');
INSERT INTO `sys_job_log` VALUES (113, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-30 14:05:00', '2026-10-30 14:05:00', '2026-10-30 14:05:00');
INSERT INTO `sys_job_log` VALUES (114, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：22毫秒', '0', '', '2026-10-30 14:20:00', '2026-10-30 14:20:00', '2026-10-30 14:20:00');
INSERT INTO `sys_job_log` VALUES (115, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-30 14:35:00', '2026-10-30 14:35:00', '2026-10-30 14:35:00');
INSERT INTO `sys_job_log` VALUES (116, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-30 14:40:00', '2026-10-30 14:40:00', '2026-10-30 14:40:00');
INSERT INTO `sys_job_log` VALUES (117, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-30 14:45:00', '2026-10-30 14:45:00', '2026-10-30 14:45:00');
INSERT INTO `sys_job_log` VALUES (118, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-30 14:50:00', '2026-10-30 14:50:00', '2026-10-30 14:50:00');
INSERT INTO `sys_job_log` VALUES (119, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-30 14:55:00', '2026-10-30 14:55:00', '2026-10-30 14:55:00');
INSERT INTO `sys_job_log` VALUES (120, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-30 15:00:00', '2026-10-30 15:00:00', '2026-10-30 15:00:00');
INSERT INTO `sys_job_log` VALUES (121, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-30 15:05:00', '2026-10-30 15:05:00', '2026-10-30 15:05:00');
INSERT INTO `sys_job_log` VALUES (122, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-30 15:10:00', '2026-10-30 15:10:00', '2026-10-30 15:10:00');
INSERT INTO `sys_job_log` VALUES (123, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-30 15:15:00', '2026-10-30 15:15:00', '2026-10-30 15:15:00');
INSERT INTO `sys_job_log` VALUES (124, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-30 15:20:00', '2026-10-30 15:20:00', '2026-10-30 15:20:00');
INSERT INTO `sys_job_log` VALUES (125, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-30 15:25:00', '2026-10-30 15:25:00', '2026-10-30 15:25:00');
INSERT INTO `sys_job_log` VALUES (126, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-30 15:30:00', '2026-10-30 15:30:00', '2026-10-30 15:30:00');
INSERT INTO `sys_job_log` VALUES (127, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-10-30 15:35:00', '2026-10-30 15:35:00', '2026-10-30 15:35:00');
INSERT INTO `sys_job_log` VALUES (128, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-30 15:40:00', '2026-10-30 15:40:00', '2026-10-30 15:40:00');
INSERT INTO `sys_job_log` VALUES (129, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：32毫秒', '0', '', '2026-10-31 09:30:00', '2026-10-31 09:30:00', '2026-10-31 09:30:00');
INSERT INTO `sys_job_log` VALUES (130, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-31 09:35:00', '2026-10-31 09:35:00', '2026-10-31 09:35:00');
INSERT INTO `sys_job_log` VALUES (131, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：9毫秒', '0', '', '2026-10-31 09:40:00', '2026-10-31 09:40:00', '2026-10-31 09:40:00');
INSERT INTO `sys_job_log` VALUES (132, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：23毫秒', '0', '', '2026-10-31 09:50:00', '2026-10-31 09:50:00', '2026-10-31 09:50:00');
INSERT INTO `sys_job_log` VALUES (133, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-31 10:00:00', '2026-10-31 10:00:00', '2026-10-31 10:00:00');
INSERT INTO `sys_job_log` VALUES (134, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-31 10:05:00', '2026-10-31 10:05:00', '2026-10-31 10:05:00');
INSERT INTO `sys_job_log` VALUES (135, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-10-31 10:10:00', '2026-10-31 10:10:00', '2026-10-31 10:10:00');
INSERT INTO `sys_job_log` VALUES (136, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 10:15:00', '2026-10-31 10:15:00', '2026-10-31 10:15:00');
INSERT INTO `sys_job_log` VALUES (137, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 10:35:00', '2026-10-31 10:35:00', '2026-10-31 10:35:00');
INSERT INTO `sys_job_log` VALUES (138, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 10:40:00', '2026-10-31 10:40:00', '2026-10-31 10:40:00');
INSERT INTO `sys_job_log` VALUES (139, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 10:45:00', '2026-10-31 10:45:00', '2026-10-31 10:45:00');
INSERT INTO `sys_job_log` VALUES (140, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 10:50:00', '2026-10-31 10:50:00', '2026-10-31 10:50:00');
INSERT INTO `sys_job_log` VALUES (141, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 10:55:00', '2026-10-31 10:55:00', '2026-10-31 10:55:00');
INSERT INTO `sys_job_log` VALUES (142, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 11:00:00', '2026-10-31 11:00:00', '2026-10-31 11:00:00');
INSERT INTO `sys_job_log` VALUES (143, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：1毫秒', '0', '', '2026-10-31 11:05:00', '2026-10-31 11:05:00', '2026-10-31 11:05:00');
INSERT INTO `sys_job_log` VALUES (144, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 11:10:00', '2026-10-31 11:10:00', '2026-10-31 11:10:00');
INSERT INTO `sys_job_log` VALUES (145, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 11:15:00', '2026-10-31 11:15:00', '2026-10-31 11:15:00');
INSERT INTO `sys_job_log` VALUES (146, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 11:20:00', '2026-10-31 11:20:00', '2026-10-31 11:20:00');
INSERT INTO `sys_job_log` VALUES (147, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 11:25:00', '2026-10-31 11:25:00', '2026-10-31 11:25:00');
INSERT INTO `sys_job_log` VALUES (148, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 11:30:00', '2026-10-31 11:30:00', '2026-10-31 11:30:00');
INSERT INTO `sys_job_log` VALUES (149, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 11:35:00', '2026-10-31 11:35:00', '2026-10-31 11:35:00');
INSERT INTO `sys_job_log` VALUES (150, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-31 11:40:00', '2026-10-31 11:40:00', '2026-10-31 11:40:00');
INSERT INTO `sys_job_log` VALUES (151, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-31 11:45:00', '2026-10-31 11:45:00', '2026-10-31 11:45:00');
INSERT INTO `sys_job_log` VALUES (152, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-31 11:50:00', '2026-10-31 11:50:00', '2026-10-31 11:50:00');
INSERT INTO `sys_job_log` VALUES (153, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-31 11:55:00', '2026-10-31 11:55:00', '2026-10-31 11:55:00');
INSERT INTO `sys_job_log` VALUES (154, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-10-31 12:00:00', '2026-10-31 12:00:00', '2026-10-31 12:00:00');
INSERT INTO `sys_job_log` VALUES (155, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 12:05:00', '2026-10-31 12:05:00', '2026-10-31 12:05:00');
INSERT INTO `sys_job_log` VALUES (156, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 12:10:00', '2026-10-31 12:10:00', '2026-10-31 12:10:00');
INSERT INTO `sys_job_log` VALUES (157, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 12:15:00', '2026-10-31 12:15:00', '2026-10-31 12:15:00');
INSERT INTO `sys_job_log` VALUES (158, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 12:20:00', '2026-10-31 12:20:00', '2026-10-31 12:20:00');
INSERT INTO `sys_job_log` VALUES (159, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-31 12:25:00', '2026-10-31 12:25:00', '2026-10-31 12:25:00');
INSERT INTO `sys_job_log` VALUES (160, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 12:30:00', '2026-10-31 12:30:00', '2026-10-31 12:30:00');
INSERT INTO `sys_job_log` VALUES (161, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 12:35:00', '2026-10-31 12:35:00', '2026-10-31 12:35:00');
INSERT INTO `sys_job_log` VALUES (162, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-10-31 12:40:00', '2026-10-31 12:40:00', '2026-10-31 12:40:00');
INSERT INTO `sys_job_log` VALUES (163, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 12:45:00', '2026-10-31 12:45:00', '2026-10-31 12:45:00');
INSERT INTO `sys_job_log` VALUES (164, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-10-31 12:50:00', '2026-10-31 12:50:00', '2026-10-31 12:50:00');
INSERT INTO `sys_job_log` VALUES (165, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-10-31 12:55:00', '2026-10-31 12:55:00', '2026-10-31 12:55:00');
INSERT INTO `sys_job_log` VALUES (166, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 13:00:00', '2026-10-31 13:00:00', '2026-10-31 13:00:00');
INSERT INTO `sys_job_log` VALUES (167, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-31 13:05:00', '2026-10-31 13:05:00', '2026-10-31 13:05:00');
INSERT INTO `sys_job_log` VALUES (168, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 13:10:00', '2026-10-31 13:10:00', '2026-10-31 13:10:00');
INSERT INTO `sys_job_log` VALUES (169, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-10-31 13:15:00', '2026-10-31 13:15:00', '2026-10-31 13:15:00');
INSERT INTO `sys_job_log` VALUES (170, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 13:20:00', '2026-10-31 13:20:00', '2026-10-31 13:20:00');
INSERT INTO `sys_job_log` VALUES (171, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-10-31 13:25:00', '2026-10-31 13:25:00', '2026-10-31 13:25:00');
INSERT INTO `sys_job_log` VALUES (172, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-10-31 13:30:00', '2026-10-31 13:30:00', '2026-10-31 13:30:00');
INSERT INTO `sys_job_log` VALUES (173, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：23毫秒', '0', '', '2026-10-31 13:50:00', '2026-10-31 13:50:00', '2026-10-31 13:50:00');
INSERT INTO `sys_job_log` VALUES (174, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-31 13:55:00', '2026-10-31 13:55:00', '2026-10-31 13:55:00');
INSERT INTO `sys_job_log` VALUES (175, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-10-31 14:00:00', '2026-10-31 14:00:00', '2026-10-31 14:00:00');
INSERT INTO `sys_job_log` VALUES (176, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-31 14:05:00', '2026-10-31 14:05:00', '2026-10-31 14:05:00');
INSERT INTO `sys_job_log` VALUES (177, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-10-31 14:10:00', '2026-10-31 14:10:00', '2026-10-31 14:10:00');
INSERT INTO `sys_job_log` VALUES (178, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-10-31 14:15:00', '2026-10-31 14:15:00', '2026-10-31 14:15:00');
INSERT INTO `sys_job_log` VALUES (179, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：12毫秒', '0', '', '2026-10-31 14:20:00', '2026-10-31 14:20:00', '2026-10-31 14:20:00');
INSERT INTO `sys_job_log` VALUES (180, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-10-31 14:25:00', '2026-10-31 14:25:00', '2026-10-31 14:25:00');
INSERT INTO `sys_job_log` VALUES (181, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-10-31 14:30:00', '2026-10-31 14:30:00', '2026-10-31 14:30:00');
INSERT INTO `sys_job_log` VALUES (182, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：86毫秒', '0', '', '2026-11-02 20:30:00', '2026-11-02 20:30:00', '2026-11-02 20:30:00');
INSERT INTO `sys_job_log` VALUES (183, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：26毫秒', '0', '', '2026-11-02 20:35:00', '2026-11-02 20:35:00', '2026-11-02 20:35:00');
INSERT INTO `sys_job_log` VALUES (184, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：21毫秒', '0', '', '2026-11-02 20:40:00', '2026-11-02 20:40:00', '2026-11-02 20:40:00');
INSERT INTO `sys_job_log` VALUES (185, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：56毫秒', '0', '', '2026-11-02 20:45:00', '2026-11-02 20:45:00', '2026-11-02 20:45:00');
INSERT INTO `sys_job_log` VALUES (186, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：112毫秒', '0', '', '2026-11-02 20:50:00', '2026-11-02 20:50:00', '2026-11-02 20:50:00');
INSERT INTO `sys_job_log` VALUES (187, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：203毫秒', '0', '', '2026-11-02 20:55:00', '2026-11-02 20:55:00', '2026-11-02 20:55:00');
INSERT INTO `sys_job_log` VALUES (188, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-02 21:00:00', '2026-11-02 21:00:00', '2026-11-02 21:00:00');
INSERT INTO `sys_job_log` VALUES (189, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：139毫秒', '0', '', '2026-11-02 21:05:00', '2026-11-02 21:05:00', '2026-11-02 21:05:00');
INSERT INTO `sys_job_log` VALUES (190, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：25毫秒', '0', '', '2026-11-02 21:10:00', '2026-11-02 21:10:00', '2026-11-02 21:10:00');
INSERT INTO `sys_job_log` VALUES (191, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：61毫秒', '0', '', '2026-11-02 21:15:00', '2026-11-02 21:15:00', '2026-11-02 21:15:00');
INSERT INTO `sys_job_log` VALUES (192, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：12毫秒', '0', '', '2026-11-02 21:20:00', '2026-11-02 21:20:00', '2026-11-02 21:20:00');
INSERT INTO `sys_job_log` VALUES (193, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：17毫秒', '0', '', '2026-11-02 21:25:00', '2026-11-02 21:25:00', '2026-11-02 21:25:00');
INSERT INTO `sys_job_log` VALUES (194, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：9毫秒', '0', '', '2026-11-02 21:30:00', '2026-11-02 21:30:00', '2026-11-02 21:30:00');
INSERT INTO `sys_job_log` VALUES (195, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：282毫秒', '0', '', '2026-11-02 21:35:00', '2026-11-02 21:35:00', '2026-11-02 21:35:00');
INSERT INTO `sys_job_log` VALUES (196, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：60毫秒', '0', '', '2026-11-03 12:30:00', '2026-11-03 12:30:00', '2026-11-03 12:30:00');
INSERT INTO `sys_job_log` VALUES (197, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-11-03 12:35:00', '2026-11-03 12:35:00', '2026-11-03 12:35:00');
INSERT INTO `sys_job_log` VALUES (198, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-11-03 12:40:00', '2026-11-03 12:40:00', '2026-11-03 12:40:00');
INSERT INTO `sys_job_log` VALUES (199, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：12毫秒', '0', '', '2026-11-03 12:45:00', '2026-11-03 12:45:00', '2026-11-03 12:45:00');
INSERT INTO `sys_job_log` VALUES (200, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：27毫秒', '0', '', '2026-11-03 12:50:00', '2026-11-03 12:50:00', '2026-11-03 12:50:00');
INSERT INTO `sys_job_log` VALUES (201, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-11-03 12:55:00', '2026-11-03 12:55:00', '2026-11-03 12:55:00');
INSERT INTO `sys_job_log` VALUES (202, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-11-03 13:00:00', '2026-11-03 13:00:00', '2026-11-03 13:00:00');
INSERT INTO `sys_job_log` VALUES (203, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-03 13:05:00', '2026-11-03 13:05:00', '2026-11-03 13:05:00');
INSERT INTO `sys_job_log` VALUES (204, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-03 13:10:00', '2026-11-03 13:10:00', '2026-11-03 13:10:00');
INSERT INTO `sys_job_log` VALUES (205, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-11-03 13:15:00', '2026-11-03 13:15:00', '2026-11-03 13:15:00');
INSERT INTO `sys_job_log` VALUES (206, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：18毫秒', '0', '', '2026-11-03 13:20:00', '2026-11-03 13:20:00', '2026-11-03 13:20:00');
INSERT INTO `sys_job_log` VALUES (207, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：15毫秒', '0', '', '2026-11-03 13:25:00', '2026-11-03 13:25:00', '2026-11-03 13:25:00');
INSERT INTO `sys_job_log` VALUES (208, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-03 13:30:00', '2026-11-03 13:30:00', '2026-11-03 13:30:00');
INSERT INTO `sys_job_log` VALUES (209, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：49毫秒', '0', '', '2026-11-03 13:35:00', '2026-11-03 13:35:00', '2026-11-03 13:35:00');
INSERT INTO `sys_job_log` VALUES (210, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：139毫秒', '0', '', '2026-11-03 14:45:00', '2026-11-03 14:45:00', '2026-11-03 14:45:00');
INSERT INTO `sys_job_log` VALUES (211, '逾期账户检查', 'SYSTEM', 'loanOverdueTask.checkAndMarkOverdueAsException', '逾期账户检查 总共耗时：319毫秒', '0', '', '2026-11-03 14:47:04', '2026-11-03 14:47:04', '2026-11-03 14:47:04');
INSERT INTO `sys_job_log` VALUES (212, '逾期账户检查', 'SYSTEM', 'loanOverdueTask.checkAndMarkOverdueAsException', '逾期账户检查 总共耗时：35毫秒', '0', '', '2026-11-03 14:48:53', '2026-11-03 14:48:53', '2026-11-03 14:48:53');
INSERT INTO `sys_job_log` VALUES (213, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-03 14:50:00', '2026-11-03 14:50:00', '2026-11-03 14:50:00');
INSERT INTO `sys_job_log` VALUES (214, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-03 14:55:00', '2026-11-03 14:55:00', '2026-11-03 14:55:00');
INSERT INTO `sys_job_log` VALUES (215, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-03 15:00:00', '2026-11-03 15:00:00', '2026-11-03 15:00:00');
INSERT INTO `sys_job_log` VALUES (216, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-03 15:05:00', '2026-11-03 15:05:00', '2026-11-03 15:05:00');
INSERT INTO `sys_job_log` VALUES (217, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-11-03 15:10:00', '2026-11-03 15:10:00', '2026-11-03 15:10:00');
INSERT INTO `sys_job_log` VALUES (218, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-03 15:15:00', '2026-11-03 15:15:00', '2026-11-03 15:15:00');
INSERT INTO `sys_job_log` VALUES (219, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-03 15:20:00', '2026-11-03 15:20:00', '2026-11-03 15:20:00');
INSERT INTO `sys_job_log` VALUES (220, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：27毫秒', '0', '', '2026-11-03 15:25:00', '2026-11-03 15:25:00', '2026-11-03 15:25:00');
INSERT INTO `sys_job_log` VALUES (221, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-11-03 15:30:00', '2026-11-03 15:30:00', '2026-11-03 15:30:00');
INSERT INTO `sys_job_log` VALUES (222, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-03 15:35:00', '2026-11-03 15:35:00', '2026-11-03 15:35:00');
INSERT INTO `sys_job_log` VALUES (223, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：35毫秒', '0', '', '2026-11-09 18:25:00', '2026-11-09 18:25:00', '2026-11-09 18:25:00');
INSERT INTO `sys_job_log` VALUES (224, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-11-09 18:30:00', '2026-11-09 18:30:00', '2026-11-09 18:30:00');
INSERT INTO `sys_job_log` VALUES (225, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：19毫秒', '0', '', '2026-11-09 18:35:00', '2026-11-09 18:35:00', '2026-11-09 18:35:00');
INSERT INTO `sys_job_log` VALUES (226, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：7毫秒', '0', '', '2026-11-09 18:40:00', '2026-11-09 18:40:00', '2026-11-09 18:40:00');
INSERT INTO `sys_job_log` VALUES (227, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 18:45:00', '2026-11-09 18:45:00', '2026-11-09 18:45:00');
INSERT INTO `sys_job_log` VALUES (228, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 18:50:00', '2026-11-09 18:50:00', '2026-11-09 18:50:00');
INSERT INTO `sys_job_log` VALUES (229, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 18:55:00', '2026-11-09 18:55:00', '2026-11-09 18:55:00');
INSERT INTO `sys_job_log` VALUES (230, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 19:00:00', '2026-11-09 19:00:00', '2026-11-09 19:00:00');
INSERT INTO `sys_job_log` VALUES (231, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 19:05:00', '2026-11-09 19:05:00', '2026-11-09 19:05:00');
INSERT INTO `sys_job_log` VALUES (232, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：43毫秒', '0', '', '2026-11-09 19:10:00', '2026-11-09 19:10:00', '2026-11-09 19:10:00');
INSERT INTO `sys_job_log` VALUES (233, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-09 19:15:00', '2026-11-09 19:15:00', '2026-11-09 19:15:00');
INSERT INTO `sys_job_log` VALUES (234, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：18毫秒', '0', '', '2026-11-09 19:20:00', '2026-11-09 19:20:00', '2026-11-09 19:20:00');
INSERT INTO `sys_job_log` VALUES (235, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-09 19:25:00', '2026-11-09 19:25:00', '2026-11-09 19:25:00');
INSERT INTO `sys_job_log` VALUES (236, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：17毫秒', '0', '', '2026-11-09 19:30:00', '2026-11-09 19:30:00', '2026-11-09 19:30:00');
INSERT INTO `sys_job_log` VALUES (237, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-09 19:35:00', '2026-11-09 19:35:00', '2026-11-09 19:35:00');
INSERT INTO `sys_job_log` VALUES (238, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 19:40:00', '2026-11-09 19:40:00', '2026-11-09 19:40:00');
INSERT INTO `sys_job_log` VALUES (239, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 19:45:00', '2026-11-09 19:45:00', '2026-11-09 19:45:00');
INSERT INTO `sys_job_log` VALUES (240, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-09 19:50:00', '2026-11-09 19:50:00', '2026-11-09 19:50:00');
INSERT INTO `sys_job_log` VALUES (241, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 19:55:00', '2026-11-09 19:55:00', '2026-11-09 19:55:00');
INSERT INTO `sys_job_log` VALUES (242, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-09 20:00:00', '2026-11-09 20:00:00', '2026-11-09 20:00:00');
INSERT INTO `sys_job_log` VALUES (243, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 20:05:00', '2026-11-09 20:05:00', '2026-11-09 20:05:00');
INSERT INTO `sys_job_log` VALUES (244, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 20:10:00', '2026-11-09 20:10:00', '2026-11-09 20:10:00');
INSERT INTO `sys_job_log` VALUES (245, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 20:15:00', '2026-11-09 20:15:00', '2026-11-09 20:15:00');
INSERT INTO `sys_job_log` VALUES (246, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-09 20:20:00', '2026-11-09 20:20:00', '2026-11-09 20:20:00');
INSERT INTO `sys_job_log` VALUES (247, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：8毫秒', '0', '', '2026-11-09 20:25:00', '2026-11-09 20:25:00', '2026-11-09 20:25:00');
INSERT INTO `sys_job_log` VALUES (248, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-09 20:30:00', '2026-11-09 20:30:00', '2026-11-09 20:30:00');
INSERT INTO `sys_job_log` VALUES (249, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-09 20:35:00', '2026-11-09 20:35:00', '2026-11-09 20:35:00');
INSERT INTO `sys_job_log` VALUES (250, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-09 20:40:00', '2026-11-09 20:40:00', '2026-11-09 20:40:00');
INSERT INTO `sys_job_log` VALUES (251, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-09 20:45:00', '2026-11-09 20:45:00', '2026-11-09 20:45:00');
INSERT INTO `sys_job_log` VALUES (252, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：40毫秒', '0', '', '2026-11-09 20:50:00', '2026-11-09 20:50:00', '2026-11-09 20:50:00');
INSERT INTO `sys_job_log` VALUES (253, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-09 20:55:00', '2026-11-09 20:55:00', '2026-11-09 20:55:00');
INSERT INTO `sys_job_log` VALUES (254, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-09 21:00:00', '2026-11-09 21:00:00', '2026-11-09 21:00:00');
INSERT INTO `sys_job_log` VALUES (255, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 21:05:00', '2026-11-09 21:05:00', '2026-11-09 21:05:00');
INSERT INTO `sys_job_log` VALUES (256, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-09 21:10:00', '2026-11-09 21:10:00', '2026-11-09 21:10:00');
INSERT INTO `sys_job_log` VALUES (257, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-09 21:15:00', '2026-11-09 21:15:00', '2026-11-09 21:15:00');
INSERT INTO `sys_job_log` VALUES (258, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-09 21:20:00', '2026-11-09 21:20:00', '2026-11-09 21:20:00');
INSERT INTO `sys_job_log` VALUES (259, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：33毫秒', '0', '', '2026-11-10 18:25:00', '2026-11-10 18:25:00', '2026-11-10 18:25:00');
INSERT INTO `sys_job_log` VALUES (260, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-10 18:30:00', '2026-11-10 18:30:00', '2026-11-10 18:30:00');
INSERT INTO `sys_job_log` VALUES (261, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-10 18:35:00', '2026-11-10 18:35:00', '2026-11-10 18:35:00');
INSERT INTO `sys_job_log` VALUES (262, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 18:40:00', '2026-11-10 18:40:00', '2026-11-10 18:40:00');
INSERT INTO `sys_job_log` VALUES (263, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-10 18:45:00', '2026-11-10 18:45:00', '2026-11-10 18:45:00');
INSERT INTO `sys_job_log` VALUES (264, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 18:50:00', '2026-11-10 18:50:00', '2026-11-10 18:50:00');
INSERT INTO `sys_job_log` VALUES (265, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-10 18:55:00', '2026-11-10 18:55:00', '2026-11-10 18:55:00');
INSERT INTO `sys_job_log` VALUES (266, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-10 19:00:00', '2026-11-10 19:00:00', '2026-11-10 19:00:00');
INSERT INTO `sys_job_log` VALUES (267, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：30毫秒', '0', '', '2026-11-10 19:10:00', '2026-11-10 19:10:00', '2026-11-10 19:10:00');
INSERT INTO `sys_job_log` VALUES (268, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：47毫秒', '0', '', '2026-11-10 19:15:00', '2026-11-10 19:15:00', '2026-11-10 19:15:00');
INSERT INTO `sys_job_log` VALUES (269, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-10 19:20:00', '2026-11-10 19:20:00', '2026-11-10 19:20:00');
INSERT INTO `sys_job_log` VALUES (270, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 19:25:00', '2026-11-10 19:25:00', '2026-11-10 19:25:00');
INSERT INTO `sys_job_log` VALUES (271, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-10 19:30:00', '2026-11-10 19:30:00', '2026-11-10 19:30:00');
INSERT INTO `sys_job_log` VALUES (272, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-11-10 19:35:00', '2026-11-10 19:35:00', '2026-11-10 19:35:00');
INSERT INTO `sys_job_log` VALUES (273, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-11-10 19:40:00', '2026-11-10 19:40:00', '2026-11-10 19:40:00');
INSERT INTO `sys_job_log` VALUES (274, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：6毫秒', '0', '', '2026-11-10 19:45:00', '2026-11-10 19:45:00', '2026-11-10 19:45:00');
INSERT INTO `sys_job_log` VALUES (275, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-10 19:50:00', '2026-11-10 19:50:00', '2026-11-10 19:50:00');
INSERT INTO `sys_job_log` VALUES (276, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 19:55:00', '2026-11-10 19:55:00', '2026-11-10 19:55:00');
INSERT INTO `sys_job_log` VALUES (277, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 20:00:00', '2026-11-10 20:00:00', '2026-11-10 20:00:00');
INSERT INTO `sys_job_log` VALUES (278, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-10 20:05:00', '2026-11-10 20:05:00', '2026-11-10 20:05:00');
INSERT INTO `sys_job_log` VALUES (279, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-10 20:10:00', '2026-11-10 20:10:00', '2026-11-10 20:10:00');
INSERT INTO `sys_job_log` VALUES (280, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-10 20:15:00', '2026-11-10 20:15:00', '2026-11-10 20:15:00');
INSERT INTO `sys_job_log` VALUES (281, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 20:20:00', '2026-11-10 20:20:00', '2026-11-10 20:20:00');
INSERT INTO `sys_job_log` VALUES (282, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：5毫秒', '0', '', '2026-11-10 20:25:00', '2026-11-10 20:25:00', '2026-11-10 20:25:00');
INSERT INTO `sys_job_log` VALUES (283, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-10 20:30:00', '2026-11-10 20:30:00', '2026-11-10 20:30:00');
INSERT INTO `sys_job_log` VALUES (284, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：49毫秒', '0', '', '2026-11-10 20:35:00', '2026-11-10 20:35:00', '2026-11-10 20:35:00');
INSERT INTO `sys_job_log` VALUES (285, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 20:40:00', '2026-11-10 20:40:00', '2026-11-10 20:40:00');
INSERT INTO `sys_job_log` VALUES (286, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：14毫秒', '0', '', '2026-11-10 20:45:00', '2026-11-10 20:45:00', '2026-11-10 20:45:00');
INSERT INTO `sys_job_log` VALUES (287, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：13毫秒', '0', '', '2026-11-10 20:50:00', '2026-11-10 20:50:00', '2026-11-10 20:50:00');
INSERT INTO `sys_job_log` VALUES (288, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：4毫秒', '0', '', '2026-11-10 20:55:00', '2026-11-10 20:55:00', '2026-11-10 20:55:00');
INSERT INTO `sys_job_log` VALUES (289, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：2毫秒', '0', '', '2026-11-10 21:00:00', '2026-11-10 21:00:00', '2026-11-10 21:00:00');
INSERT INTO `sys_job_log` VALUES (290, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：3毫秒', '0', '', '2026-11-10 21:05:00', '2026-11-10 21:05:00', '2026-11-10 21:05:00');
INSERT INTO `sys_job_log` VALUES (291, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：11毫秒', '0', '', '2026-11-10 21:10:00', '2026-11-10 21:10:00', '2026-11-10 21:10:00');
INSERT INTO `sys_job_log` VALUES (292, '转账自动解冻', 'SYSTEM', 'transferUnfreezeTask.unfreezeExpiredRecords()', '转账自动解冻 总共耗时：10毫秒', '0', '', '2026-11-10 21:15:00', '2026-11-10 21:15:00', '2026-11-10 21:15:00');

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 380 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-21 22:32:46');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-21 23:02:27');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 10:36:25');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 11:49:57');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 11:50:33');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 13:02:32');
INSERT INTO `sys_logininfor` VALUES (106, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '1', '验证码错误', '2026-10-22 13:02:38');
INSERT INTO `sys_logininfor` VALUES (107, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 13:02:42');
INSERT INTO `sys_logininfor` VALUES (108, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 13:02:50');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 13:02:56');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 13:03:49');
INSERT INTO `sys_logininfor` VALUES (111, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '1', '用户不存在/密码错误', '2026-10-22 13:03:55');
INSERT INTO `sys_logininfor` VALUES (112, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 13:04:06');
INSERT INTO `sys_logininfor` VALUES (113, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 13:54:26');
INSERT INTO `sys_logininfor` VALUES (114, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 13:54:26');
INSERT INTO `sys_logininfor` VALUES (115, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 14:04:49');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 14:04:50');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 14:16:25');
INSERT INTO `sys_logininfor` VALUES (118, 'ry', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 14:16:27');
INSERT INTO `sys_logininfor` VALUES (119, 'ry', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 14:16:32');
INSERT INTO `sys_logininfor` VALUES (120, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '1', '用户不存在/密码错误', '2026-10-22 14:16:37');
INSERT INTO `sys_logininfor` VALUES (121, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 14:16:41');
INSERT INTO `sys_logininfor` VALUES (122, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 15:54:41');
INSERT INTO `sys_logininfor` VALUES (123, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 15:56:32');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 15:56:38');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:21:30');
INSERT INTO `sys_logininfor` VALUES (126, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:21:38');
INSERT INTO `sys_logininfor` VALUES (127, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:21:46');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:21:48');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:22:06');
INSERT INTO `sys_logininfor` VALUES (130, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:22:18');
INSERT INTO `sys_logininfor` VALUES (131, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:22:26');
INSERT INTO `sys_logininfor` VALUES (132, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:22:32');
INSERT INTO `sys_logininfor` VALUES (133, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:26:08');
INSERT INTO `sys_logininfor` VALUES (134, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:26:10');
INSERT INTO `sys_logininfor` VALUES (135, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:28:58');
INSERT INTO `sys_logininfor` VALUES (136, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:29:04');
INSERT INTO `sys_logininfor` VALUES (137, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:31:20');
INSERT INTO `sys_logininfor` VALUES (138, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:31:32');
INSERT INTO `sys_logininfor` VALUES (139, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 16:58:19');
INSERT INTO `sys_logininfor` VALUES (140, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 16:58:19');
INSERT INTO `sys_logininfor` VALUES (141, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 17:23:16');
INSERT INTO `sys_logininfor` VALUES (142, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 17:23:19');
INSERT INTO `sys_logininfor` VALUES (143, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 17:23:57');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 17:24:00');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 17:34:33');
INSERT INTO `sys_logininfor` VALUES (146, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 17:34:36');
INSERT INTO `sys_logininfor` VALUES (147, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 17:34:43');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 17:34:45');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 18:43:34');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 18:43:40');
INSERT INTO `sys_logininfor` VALUES (151, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 18:43:43');
INSERT INTO `sys_logininfor` VALUES (152, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 18:43:49');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 18:43:51');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-22 18:44:13');
INSERT INTO `sys_logininfor` VALUES (155, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-22 18:44:16');
INSERT INTO `sys_logininfor` VALUES (156, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-24 17:23:54');
INSERT INTO `sys_logininfor` VALUES (157, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-24 17:24:22');
INSERT INTO `sys_logininfor` VALUES (158, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-24 17:24:25');
INSERT INTO `sys_logininfor` VALUES (159, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-24 18:59:35');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-24 20:43:44');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-24 21:05:45');
INSERT INTO `sys_logininfor` VALUES (162, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-24 21:05:46');
INSERT INTO `sys_logininfor` VALUES (163, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 20:47:03');
INSERT INTO `sys_logininfor` VALUES (164, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 21:11:55');
INSERT INTO `sys_logininfor` VALUES (165, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 21:11:56');
INSERT INTO `sys_logininfor` VALUES (166, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 22:10:29');
INSERT INTO `sys_logininfor` VALUES (167, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 22:10:53');
INSERT INTO `sys_logininfor` VALUES (168, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 22:10:56');
INSERT INTO `sys_logininfor` VALUES (169, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 22:11:24');
INSERT INTO `sys_logininfor` VALUES (170, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 22:11:27');
INSERT INTO `sys_logininfor` VALUES (171, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 22:16:39');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 22:16:43');
INSERT INTO `sys_logininfor` VALUES (173, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 22:49:41');
INSERT INTO `sys_logininfor` VALUES (174, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 23:05:31');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 23:05:34');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 23:10:28');
INSERT INTO `sys_logininfor` VALUES (177, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 23:10:30');
INSERT INTO `sys_logininfor` VALUES (178, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-26 23:11:43');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 23:11:45');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-26 23:53:32');
INSERT INTO `sys_logininfor` VALUES (181, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-27 12:26:58');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-27 18:37:22');
INSERT INTO `sys_logininfor` VALUES (183, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 13:25:53');
INSERT INTO `sys_logininfor` VALUES (184, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 13:27:30');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 13:27:33');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 13:28:01');
INSERT INTO `sys_logininfor` VALUES (187, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 13:28:04');
INSERT INTO `sys_logininfor` VALUES (188, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 15:21:18');
INSERT INTO `sys_logininfor` VALUES (189, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 18:48:24');
INSERT INTO `sys_logininfor` VALUES (190, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 19:55:32');
INSERT INTO `sys_logininfor` VALUES (191, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:37:00');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:37:02');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:43:23');
INSERT INTO `sys_logininfor` VALUES (194, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:43:25');
INSERT INTO `sys_logininfor` VALUES (195, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:43:43');
INSERT INTO `sys_logininfor` VALUES (196, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:43:46');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:44:33');
INSERT INTO `sys_logininfor` VALUES (198, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:44:33');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:47:23');
INSERT INTO `sys_logininfor` VALUES (200, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:47:26');
INSERT INTO `sys_logininfor` VALUES (201, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:49:20');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:49:23');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:49:38');
INSERT INTO `sys_logininfor` VALUES (204, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:49:43');
INSERT INTO `sys_logininfor` VALUES (205, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-29 20:49:54');
INSERT INTO `sys_logininfor` VALUES (206, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 20:49:59');
INSERT INTO `sys_logininfor` VALUES (207, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-29 21:43:07');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 13:03:45');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 13:04:29');
INSERT INTO `sys_logininfor` VALUES (210, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 13:04:32');
INSERT INTO `sys_logininfor` VALUES (211, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 13:35:38');
INSERT INTO `sys_logininfor` VALUES (212, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 14:01:56');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 14:02:00');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 14:05:53');
INSERT INTO `sys_logininfor` VALUES (215, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 14:05:54');
INSERT INTO `sys_logininfor` VALUES (216, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 15:20:10');
INSERT INTO `sys_logininfor` VALUES (217, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 15:20:45');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 15:20:48');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 15:22:31');
INSERT INTO `sys_logininfor` VALUES (220, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 15:22:31');
INSERT INTO `sys_logininfor` VALUES (221, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 15:23:25');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 15:23:28');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-30 15:24:03');
INSERT INTO `sys_logininfor` VALUES (224, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-30 15:24:07');
INSERT INTO `sys_logininfor` VALUES (225, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 09:29:26');
INSERT INTO `sys_logininfor` VALUES (226, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 10:46:31');
INSERT INTO `sys_logininfor` VALUES (227, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 10:46:31');
INSERT INTO `sys_logininfor` VALUES (228, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 10:48:51');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 10:48:53');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 10:49:38');
INSERT INTO `sys_logininfor` VALUES (231, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 10:49:40');
INSERT INTO `sys_logininfor` VALUES (232, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 10:54:36');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 10:54:39');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 10:59:16');
INSERT INTO `sys_logininfor` VALUES (235, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 10:59:18');
INSERT INTO `sys_logininfor` VALUES (236, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:02:49');
INSERT INTO `sys_logininfor` VALUES (237, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:02:51');
INSERT INTO `sys_logininfor` VALUES (238, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:31:19');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:31:23');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:31:46');
INSERT INTO `sys_logininfor` VALUES (241, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '1', '用户不存在/密码错误', '2026-10-31 11:31:57');
INSERT INTO `sys_logininfor` VALUES (242, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '1', '用户不存在/密码错误', '2026-10-31 11:31:59');
INSERT INTO `sys_logininfor` VALUES (243, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:32:08');
INSERT INTO `sys_logininfor` VALUES (244, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:32:19');
INSERT INTO `sys_logininfor` VALUES (245, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:32:24');
INSERT INTO `sys_logininfor` VALUES (246, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:32:37');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:32:39');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:34:26');
INSERT INTO `sys_logininfor` VALUES (249, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:34:29');
INSERT INTO `sys_logininfor` VALUES (250, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 11:42:08');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 11:42:12');
INSERT INTO `sys_logininfor` VALUES (252, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:01:30');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:01:30');
INSERT INTO `sys_logininfor` VALUES (254, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:01:41');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:01:43');
INSERT INTO `sys_logininfor` VALUES (256, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:01:55');
INSERT INTO `sys_logininfor` VALUES (257, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:01:57');
INSERT INTO `sys_logininfor` VALUES (258, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:02:13');
INSERT INTO `sys_logininfor` VALUES (259, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:02:16');
INSERT INTO `sys_logininfor` VALUES (260, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:04:18');
INSERT INTO `sys_logininfor` VALUES (261, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:04:21');
INSERT INTO `sys_logininfor` VALUES (262, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:05:02');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:05:06');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:07:43');
INSERT INTO `sys_logininfor` VALUES (265, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:07:46');
INSERT INTO `sys_logininfor` VALUES (266, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:13:24');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:13:26');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:16:55');
INSERT INTO `sys_logininfor` VALUES (269, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:16:58');
INSERT INTO `sys_logininfor` VALUES (270, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 12:25:56');
INSERT INTO `sys_logininfor` VALUES (271, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 12:25:58');
INSERT INTO `sys_logininfor` VALUES (272, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 13:28:02');
INSERT INTO `sys_logininfor` VALUES (273, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 13:52:39');
INSERT INTO `sys_logininfor` VALUES (274, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 13:52:44');
INSERT INTO `sys_logininfor` VALUES (275, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 13:52:56');
INSERT INTO `sys_logininfor` VALUES (276, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 13:52:58');
INSERT INTO `sys_logininfor` VALUES (277, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 13:53:18');
INSERT INTO `sys_logininfor` VALUES (278, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 13:53:21');
INSERT INTO `sys_logininfor` VALUES (279, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 14:07:24');
INSERT INTO `sys_logininfor` VALUES (280, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 14:07:26');
INSERT INTO `sys_logininfor` VALUES (281, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 14:10:01');
INSERT INTO `sys_logininfor` VALUES (282, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 14:10:04');
INSERT INTO `sys_logininfor` VALUES (283, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 14:30:39');
INSERT INTO `sys_logininfor` VALUES (284, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 14:30:39');
INSERT INTO `sys_logininfor` VALUES (285, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 14:30:47');
INSERT INTO `sys_logininfor` VALUES (286, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 14:30:52');
INSERT INTO `sys_logininfor` VALUES (287, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '退出成功', '2026-10-31 14:31:15');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '127.0.0.1', '内网IP', 'Chrome 158', 'Windows10', '0', '登录成功', '2026-10-31 14:31:19');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-02 20:35:12');
INSERT INTO `sys_logininfor` VALUES (290, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 12:39:33');
INSERT INTO `sys_logininfor` VALUES (291, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 12:50:01');
INSERT INTO `sys_logininfor` VALUES (292, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 12:50:03');
INSERT INTO `sys_logininfor` VALUES (293, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 12:57:39');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 12:57:41');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 12:58:14');
INSERT INTO `sys_logininfor` VALUES (296, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 12:58:16');
INSERT INTO `sys_logininfor` VALUES (297, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 13:06:43');
INSERT INTO `sys_logininfor` VALUES (298, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 13:06:46');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 14:41:55');
INSERT INTO `sys_logininfor` VALUES (300, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 14:49:09');
INSERT INTO `sys_logininfor` VALUES (301, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 14:49:10');
INSERT INTO `sys_logininfor` VALUES (302, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 14:49:17');
INSERT INTO `sys_logininfor` VALUES (303, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 14:49:21');
INSERT INTO `sys_logininfor` VALUES (304, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-03 15:09:19');
INSERT INTO `sys_logininfor` VALUES (305, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-03 15:09:22');
INSERT INTO `sys_logininfor` VALUES (306, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:17:05');
INSERT INTO `sys_logininfor` VALUES (307, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:25:27');
INSERT INTO `sys_logininfor` VALUES (308, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:26:59');
INSERT INTO `sys_logininfor` VALUES (309, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:30:19');
INSERT INTO `sys_logininfor` VALUES (310, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:31:50');
INSERT INTO `sys_logininfor` VALUES (311, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-03 15:32:10');
INSERT INTO `sys_logininfor` VALUES (312, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 18:21:16');
INSERT INTO `sys_logininfor` VALUES (313, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 18:56:19');
INSERT INTO `sys_logininfor` VALUES (314, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 18:56:21');
INSERT INTO `sys_logininfor` VALUES (315, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 18:56:45');
INSERT INTO `sys_logininfor` VALUES (316, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 18:56:54');
INSERT INTO `sys_logininfor` VALUES (317, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 19:01:08');
INSERT INTO `sys_logininfor` VALUES (318, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 19:01:13');
INSERT INTO `sys_logininfor` VALUES (319, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 19:01:16');
INSERT INTO `sys_logininfor` VALUES (320, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 19:02:55');
INSERT INTO `sys_logininfor` VALUES (321, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 19:02:59');
INSERT INTO `sys_logininfor` VALUES (322, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 19:10:30');
INSERT INTO `sys_logininfor` VALUES (323, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 20:15:30');
INSERT INTO `sys_logininfor` VALUES (324, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:02:19');
INSERT INTO `sys_logininfor` VALUES (325, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:05:12');
INSERT INTO `sys_logininfor` VALUES (326, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:05:14');
INSERT INTO `sys_logininfor` VALUES (327, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:08:28');
INSERT INTO `sys_logininfor` VALUES (328, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:08:30');
INSERT INTO `sys_logininfor` VALUES (329, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:15:31');
INSERT INTO `sys_logininfor` VALUES (330, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:15:33');
INSERT INTO `sys_logininfor` VALUES (331, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:15:41');
INSERT INTO `sys_logininfor` VALUES (332, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:15:43');
INSERT INTO `sys_logininfor` VALUES (333, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:15:51');
INSERT INTO `sys_logininfor` VALUES (334, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:15:53');
INSERT INTO `sys_logininfor` VALUES (335, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-09 21:21:32');
INSERT INTO `sys_logininfor` VALUES (336, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-09 21:21:36');
INSERT INTO `sys_logininfor` VALUES (337, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:24:00');
INSERT INTO `sys_logininfor` VALUES (338, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 18:32:58');
INSERT INTO `sys_logininfor` VALUES (339, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:33:00');
INSERT INTO `sys_logininfor` VALUES (340, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 18:41:27');
INSERT INTO `sys_logininfor` VALUES (341, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:41:29');
INSERT INTO `sys_logininfor` VALUES (342, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 18:44:23');
INSERT INTO `sys_logininfor` VALUES (343, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:44:25');
INSERT INTO `sys_logininfor` VALUES (344, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 18:46:21');
INSERT INTO `sys_logininfor` VALUES (345, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:46:23');
INSERT INTO `sys_logininfor` VALUES (346, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 18:46:59');
INSERT INTO `sys_logininfor` VALUES (347, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 18:47:02');
INSERT INTO `sys_logininfor` VALUES (348, 'gaoyuliang', '127.0.0.1', '内网IP', 'Postman Runtime 7.51.1', '', '0', '登录成功', '2026-11-10 19:23:26');
INSERT INTO `sys_logininfor` VALUES (349, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 19:27:11');
INSERT INTO `sys_logininfor` VALUES (350, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:22:21');
INSERT INTO `sys_logininfor` VALUES (351, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:22:21');
INSERT INTO `sys_logininfor` VALUES (352, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:22:27');
INSERT INTO `sys_logininfor` VALUES (353, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:22:29');
INSERT INTO `sys_logininfor` VALUES (354, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:22:34');
INSERT INTO `sys_logininfor` VALUES (355, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:22:37');
INSERT INTO `sys_logininfor` VALUES (356, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-11-10 20:22:39');
INSERT INTO `sys_logininfor` VALUES (357, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:23:05');
INSERT INTO `sys_logininfor` VALUES (358, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:23:57');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:23:58');
INSERT INTO `sys_logininfor` VALUES (360, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:28:55');
INSERT INTO `sys_logininfor` VALUES (361, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:28:58');
INSERT INTO `sys_logininfor` VALUES (362, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:29:00');
INSERT INTO `sys_logininfor` VALUES (363, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:29:02');
INSERT INTO `sys_logininfor` VALUES (364, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:29:06');
INSERT INTO `sys_logininfor` VALUES (365, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:29:12');
INSERT INTO `sys_logininfor` VALUES (366, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:29:14');
INSERT INTO `sys_logininfor` VALUES (367, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:29:17');
INSERT INTO `sys_logininfor` VALUES (368, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:31:16');
INSERT INTO `sys_logininfor` VALUES (369, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:31:55');
INSERT INTO `sys_logininfor` VALUES (370, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:35:27');
INSERT INTO `sys_logininfor` VALUES (371, 'admin', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:35:29');
INSERT INTO `sys_logininfor` VALUES (372, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:35:32');
INSERT INTO `sys_logininfor` VALUES (373, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 20:35:36');
INSERT INTO `sys_logininfor` VALUES (374, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '用户不存在/密码错误', '2026-11-10 20:35:40');
INSERT INTO `sys_logininfor` VALUES (375, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-11-10 20:35:44');
INSERT INTO `sys_logininfor` VALUES (376, 'gaoyuliang', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-11-10 20:35:49');
INSERT INTO `sys_logininfor` VALUES (377, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 20:35:53');
INSERT INTO `sys_logininfor` VALUES (378, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '退出成功', '2026-11-10 21:15:11');
INSERT INTO `sys_logininfor` VALUES (379, 'qitongwei', '127.0.0.1', '内网IP', 'Chrome 159', 'Windows10', '0', '登录成功', '2026-11-10 21:15:20');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2063 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 3, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-10-21 22:32:12', 'admin', '2026-11-09 20:53:17', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 3, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-10-21 22:32:12', 'admin', '2026-11-09 20:53:10', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 4, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-10-21 22:32:12', 'admin', '2026-11-09 20:53:01', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '1', '', 'guide', 'admin', '2026-10-21 22:32:12', 'admin', '2026-10-21 22:33:13', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-10-21 22:32:12', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-10-21 22:32:12', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-10-21 22:32:12', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-10-21 22:32:12', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-10-21 22:32:12', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-10-21 22:32:12', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-10-21 22:32:12', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-10-21 22:32:12', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-10-21 22:32:12', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-10-21 22:32:12', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-10-21 22:32:12', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-10-21 22:32:12', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-10-21 22:32:12', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-10-21 22:32:12', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-10-21 22:32:12', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-10-21 22:32:12', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-10-21 22:32:12', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-10-21 22:32:12', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-10-21 22:32:12', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-10-21 22:32:12', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '个人信息', 0, 0, 'info', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'logininfor', 'admin', '2026-10-21 23:52:13', 'admin', '2026-10-22 17:34:26', '');
INSERT INTO `sys_menu` VALUES (2019, '我的信息', 2000, 1, 'customerExt', 'manage/customerExt/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:customerExt:list', 'user', 'admin', '2026-10-22 14:11:14', 'admin', '2026-11-03 12:58:04', '客户信息菜单');
INSERT INTO `sys_menu` VALUES (2020, '客户信息查询', 2019, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:customerExt:query', '#', 'admin', '2026-10-22 14:11:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '客户信息新增', 2019, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:customerExt:add', '#', 'admin', '2026-10-22 14:11:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '客户信息修改', 2019, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:customerExt:edit', '#', 'admin', '2026-10-22 14:11:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '转账记录', 2043, 1, 'TransferRecord', 'manage/TransferRecord/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:TransferRecord:list', 'money', 'admin', '2026-10-22 16:18:12', 'admin', '2026-10-31 12:26:35', '用户转账记录菜单');
INSERT INTO `sys_menu` VALUES (2038, '用户转账记录查询', 2037, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:TransferRecord:query', '#', 'admin', '2026-10-22 16:18:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '用户转账记录新增', 2037, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:TransferRecord:add', '#', 'admin', '2026-10-22 16:18:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '用户转账记录修改', 2037, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:TransferRecord:edit', '#', 'admin', '2026-10-22 16:18:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '用户转账记录删除', 2037, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:TransferRecord:remove', '#', 'admin', '2026-10-22 16:18:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '用户转账记录导出', 2037, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:TransferRecord:export', '#', 'admin', '2026-10-22 16:18:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '我的记录', 0, 2, 'func', NULL, NULL, '', 1, 0, 'M', '0', '0', '', '系统功能', 'admin', '2026-10-22 17:32:10', 'admin', '2026-11-10 18:42:46', '');
INSERT INTO `sys_menu` VALUES (2044, '小额转账', 2060, 1, 'transferFunc', 'manage/transferFunc/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:transferFunc:add', '转账', 'admin', '2026-10-22 17:39:52', 'admin', '2026-11-10 18:46:43', '');
INSERT INTO `sys_menu` VALUES (2049, '借贷与还款', 2060, 2, 'loan', 'manage/loan/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:loan', '还钱', 'admin', '2026-10-31 11:56:22', 'admin', '2026-11-10 18:42:35', '');
INSERT INTO `sys_menu` VALUES (2050, '借款', 2049, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'manage:loan:add', '#', 'admin', '2026-10-31 12:06:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '还贷', 2049, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'manage:loan:update', '#', 'admin', '2026-10-31 12:07:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '查询', 2049, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'manage:loan:query', '#', 'admin', '2026-10-31 12:07:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '我的概况', 2000, 2, 'manage/overview', 'manage/overview/index', '', '', 1, 0, 'C', '0', '0', 'manage:account:dashboard', '概览', 'admin', '2026-10-31 13:49:31', 'admin', '2026-11-03 12:58:10', '');
INSERT INTO `sys_menu` VALUES (2060, '个人自助', 0, 1, 'biz_manage', NULL, NULL, '', 1, 0, 'M', '0', '0', '', '自助服务', 'admin', '2026-11-09 20:52:53', 'admin', '2026-11-10 18:42:49', '');
INSERT INTO `sys_menu` VALUES (2061, '业务预约', 2060, 3, 'reservation', 'manage/reservation/index', NULL, 'Reservation', 1, 0, 'C', '0', '0', 'manage:reservation', '自助ATM终端', 'admin', '2026-11-09 20:56:39', 'admin', '2026-11-10 18:43:50', '');
INSERT INTO `sys_menu` VALUES (2062, '自助大厅', 2060, 0, 'servicehall', 'manage/servicehall/index', NULL, 'ServiceHall', 1, 0, 'C', '0', '0', '', '业务', 'admin', '2026-11-09 21:19:25', 'admin', '2026-11-10 18:32:28', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313737333933313834383334323433393033322F61346432323331335F313831353039352E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------
INSERT INTO `sys_notice_read` VALUES (1, 3, 100, '2026-10-22 19:18:22');
INSERT INTO `sys_notice_read` VALUES (2, 2, 100, '2026-10-22 19:18:22');
INSERT INTO `sys_notice_read` VALUES (3, 1, 100, '2026-10-22 19:18:22');
INSERT INTO `sys_notice_read` VALUES (4, 3, 1, '2026-10-26 23:55:32');
INSERT INTO `sys_notice_read` VALUES (5, 2, 1, '2026-10-26 23:55:32');
INSERT INTO `sys_notice_read` VALUES (6, 1, 1, '2026-10-26 23:55:32');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 477 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 22:32:12\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 22:33:13', 23);
INSERT INTO `sys_oper_log` VALUES (101, '角色管理', 1, 'com.ClientBank.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"银行管理系统一号客户\",\"roleKey\":\"common\",\"roleName\":\"高育良\",\"roleSort\":2,\"status\":\"0\"} ', '{\"msg\":\"新增角色\'高育良\'失败，角色权限已存在\",\"code\":500}', 0, NULL, '2026-10-21 23:08:53', 18);
INSERT INTO `sys_oper_log` VALUES (102, '部门管理', 1, 'com.ClientBank.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"银行客户部\",\"email\":\"2309683834@qq.com\",\"leader\":\"王爱灵\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"phone\":\"18871961105\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:12:51', 16);
INSERT INTO `sys_oper_log` VALUES (103, '角色管理', 1, 'com.ClientBank.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:13:37', 34);
INSERT INTO `sys_oper_log` VALUES (104, '岗位管理', 1, 'com.ClientBank.web.controller.system.SysPostController.add()', 'POST', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"flag\":false,\"params\":{},\"postCode\":\"customer\",\"postId\":5,\"postName\":\"普通用户\",\"postSort\":5,\"remark\":\"银行系统的普通用户\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:18:08', 30);
INSERT INTO `sys_oper_log` VALUES (105, '岗位管理', 2, 'com.ClientBank.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-10-21 22:32:12\",\"flag\":false,\"params\":{},\"postCode\":\"teller\",\"postId\":4,\"postName\":\"柜员\",\"postSort\":4,\"remark\":\"办理开户、实名、存取款\",\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:18:40', 15);
INSERT INTO `sys_oper_log` VALUES (106, '岗位管理', 2, 'com.ClientBank.web.controller.system.SysPostController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/post', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:18:07\",\"flag\":false,\"params\":{},\"postCode\":\"customer\",\"postId\":5,\"postName\":\"银行系统的普通用户\",\"postSort\":5,\"remark\":\"银行系统的普通用户\",\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:18:50', 10);
INSERT INTO `sys_oper_log` VALUES (107, '用户管理', 1, 'com.ClientBank.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":200,\"email\":\"230968888@qq.com\",\"nickName\":\"高育良\",\"params\":{},\"phonenumber\":\"18925631452\",\"postIds\":[5],\"remark\":\"本银行系统的第一位注册用户\",\"roleIds\":[100],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"gaoyuliang\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:20:47', 104);
INSERT INTO `sys_oper_log` VALUES (108, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"bank_customer_ext\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:26:37', 89);
INSERT INTO `sys_oper_log` VALUES (109, '代码生成', 3, 'com.ClientBank.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:33:29', 10);
INSERT INTO `sys_oper_log` VALUES (110, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"bank_account,bank_customer_ext\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:33:33', 77);
INSERT INTO `sys_oper_log` VALUES (111, '字典类型', 1, 'com.ClientBank.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"银行卡类型\",\"dictType\":\"account_type\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:36:36', 13);
INSERT INTO `sys_oper_log` VALUES (112, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"一类卡\",\"dictSort\":0,\"dictType\":\"account_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:37:56', 17);
INSERT INTO `sys_oper_log` VALUES (113, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"储蓄卡\",\"dictSort\":0,\"dictType\":\"account_type\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:38:07', 7);
INSERT INTO `sys_oper_log` VALUES (114, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"信用卡\",\"dictSort\":0,\"dictType\":\"account_type\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:38:16', 10);
INSERT INTO `sys_oper_log` VALUES (115, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"ext\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:47:35', 47);
INSERT INTO `sys_oper_log` VALUES (116, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"select\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:48:18', 20);
INSERT INTO `sys_oper_log` VALUES (117, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"ext\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:47:35\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:47:35\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:47:35\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:48:29', 33);
INSERT INTO `sys_oper_log` VALUES (118, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"ext\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:29\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:29\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:29\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:48:35', 15);
INSERT INTO `sys_oper_log` VALUES (119, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"logininfor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"个人信息\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"clientBank\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:52:13', 30);
INSERT INTO `sys_oper_log` VALUES (120, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:18\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:18\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:18\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"ed', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:53:28', 19);
INSERT INTO `sys_oper_log` VALUES (121, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"ext\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:35\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:35\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:48:35\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:54:22', 17);
INSERT INTO `sys_oper_log` VALUES (122, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:53:28\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:53:28\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:53:28\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"ed', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:54:40', 16);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_account\"}', NULL, 0, NULL, '2026-10-21 23:54:53', 58);
INSERT INTO `sys_oper_log` VALUES (124, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_customer_ext\"}', NULL, 0, NULL, '2026-10-21 23:54:53', 76);
INSERT INTO `sys_oper_log` VALUES (125, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"customerExt\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:22\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:22\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:22\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dict', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:56:49', 40);
INSERT INTO `sys_oper_log` VALUES (126, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:40\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:40\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:54:40\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"ed', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-21 23:57:03', 17);
INSERT INTO `sys_oper_log` VALUES (127, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_account\"}', NULL, 0, NULL, '2026-10-21 23:57:05', 133);
INSERT INTO `sys_oper_log` VALUES (128, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_customer_ext\"}', NULL, 0, NULL, '2026-10-21 23:57:06', 37);
INSERT INTO `sys_oper_log` VALUES (129, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"customerExt\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:56:48\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:56:48\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:56:48\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dict', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:40:06', 50);
INSERT INTO `sys_oper_log` VALUES (130, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:57:03\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:57:03\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-21 23:57:03\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"ed', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:40:14', 50);
INSERT INTO `sys_oper_log` VALUES (131, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_account\"}', NULL, 0, NULL, '2026-10-22 10:40:18', 327);
INSERT INTO `sys_oper_log` VALUES (132, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_customer_ext\"}', NULL, 0, NULL, '2026-10-22 10:40:19', 54);
INSERT INTO `sys_oper_log` VALUES (133, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:42', 20);
INSERT INTO `sys_oper_log` VALUES (134, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2003', '127.0.0.1', '内网IP', '2003 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:43', 8);
INSERT INTO `sys_oper_log` VALUES (135, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2004', '127.0.0.1', '内网IP', '2004 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:45', 9);
INSERT INTO `sys_oper_log` VALUES (136, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2005', '127.0.0.1', '内网IP', '2005 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:46', 8);
INSERT INTO `sys_oper_log` VALUES (137, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2006', '127.0.0.1', '内网IP', '2006 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:48', 5);
INSERT INTO `sys_oper_log` VALUES (138, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2001', '127.0.0.1', '内网IP', '2001 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 10:45:50', 21);
INSERT INTO `sys_oper_log` VALUES (139, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'cust_ext.account_id\' in \'where clause\'\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankAccountMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT             acc.card_number         FROM             bank_account acc                 INNER JOIN             bank_customer_ext cust_ext ON acc.user_id = cust_ext.user_id         WHERE             cust_ext.account_id = ?           AND cust_ext.id_card_number = ?           AND cust_ext.account_status = 0           AND acc.card_number IS NOT NULL             LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'cust_ext.account_id\' in \'where clause\'\n; bad SQL grammar []', '2026-10-22 11:47:31', 162);
INSERT INTO `sys_oper_log` VALUES (140, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'acc.id_card_number\' in \'where clause\'\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankAccountMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT             acc.card_number         FROM             bank_account acc                 INNER JOIN             bank_customer_ext cust_ext ON acc.user_id = cust_ext.user_id         WHERE             acc.account_id = ?           AND acc.id_card_number = ?           AND cust_ext.account_status = 0           AND acc.card_number IS NOT NULL             LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'acc.id_card_number\' in \'where clause\'\n; bad SQL grammar []', '2026-10-22 11:49:07', 149);
INSERT INTO `sys_oper_log` VALUES (141, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'acc.id_card_number\' in \'where clause\'\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankAccountMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: SELECT             acc.card_number         FROM             bank_account acc                 INNER JOIN             bank_customer_ext cust_ext ON acc.user_id = cust_ext.user_id         WHERE             acc.account_id = ?           AND acc.id_card_number = ?           AND cust_ext.account_status = 0           AND acc.card_number IS NOT NULL             LIMIT 1\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'acc.id_card_number\' in \'where clause\'\n; bad SQL grammar []', '2026-10-22 11:50:45', 139);
INSERT INTO `sys_oper_log` VALUES (142, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', '{\"msg\":\"622202196001011234\",\"code\":200}', 0, NULL, '2026-10-22 11:53:26', 46);
INSERT INTO `sys_oper_log` VALUES (143, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', '{\"msg\":\"622202196001011234\",\"code\":200}', 0, NULL, '2026-10-22 11:54:37', 4);
INSERT INTO `sys_oper_log` VALUES (144, '实名校验查看卡号', 0, 'com.ClientBank.manage.controller.BankAccountController.verifyIdCard()', 'POST', 1, 'admin', '研发部门', '/manage/account/verifyIdCard', '127.0.0.1', '内网IP', '{\"accountId\":\"1\",\"idCardNumber\":\"622202196001011234\"}', '{\"msg\":\"622202196001011234\",\"code\":200,\"data\":\"622202196001011234\"}', 0, NULL, '2026-10-22 11:56:07', 44);
INSERT INTO `sys_oper_log` VALUES (145, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"idCardNumber\":\"420101196001010000\",\"params\":{},\"realName\":\"高育良\",\"remark\":\"人大代表\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:01:23', 34);
INSERT INTO `sys_oper_log` VALUES (146, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"params\":{},\"remark\":\"人大代表1\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_time\' in \'field list\'\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankCustomerExtMapper.xml]\r\n### The error may involve com.ClientBank.manage.mapper.BankCustomerExtMapper.updateBankCustomerExt-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE bank_customer_ext         SET             residence_address = ?,             remark = ?,             update_time = sysdate()         WHERE ext_id = ?           AND user_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_time\' in \'field list\'\n; bad SQL grammar []', '2026-10-22 12:15:35', 230);
INSERT INTO `sys_oper_log` VALUES (147, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"params\":{},\"remark\":\"人大代表1\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_time\' in \'field list\'\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankCustomerExtMapper.xml]\r\n### The error may involve com.ClientBank.manage.mapper.BankCustomerExtMapper.updateBankCustomerExt-Inline\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE bank_customer_ext         SET             residence_address = ?,             remark = ?,             update_time = sysdate()         WHERE ext_id = ?           AND user_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'update_time\' in \'field list\'\n; bad SQL grammar []', '2026-10-22 12:22:42', 13);
INSERT INTO `sys_oper_log` VALUES (148, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"params\":{},\"remark\":\"人大代表1\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:23:34', 21);
INSERT INTO `sys_oper_log` VALUES (149, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"params\":{},\"remark\":\"人大代表12\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:23:39', 6);
INSERT INTO `sys_oper_log` VALUES (150, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'admin', '研发部门', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"extId\":1,\"params\":{},\"remark\":\"人大代表123\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":101} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:24:30', 7);
INSERT INTO `sys_oper_log` VALUES (151, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"bank_wealth_ad\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:29:33', 73);
INSERT INTO `sys_oper_log` VALUES (152, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"ad\",\"className\":\"BankWealthAd\",\"columns\":[{\"capJavaField\":\"AdId\",\"columnComment\":\"广告ID\",\"columnId\":36,\"columnName\":\"ad_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 12:29:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"adId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"广告标题\",\"columnId\":37,\"columnName\":\"title\",\"columnType\":\"varchar(128)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 12:29:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SubTitle\",\"columnComment\":\"广告副标题\",\"columnId\":38,\"columnName\":\"sub_title\",\"columnType\":\"varchar(256)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 12:29:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"subTitle\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AnnualRate\",\"columnComment\":\"预期年化收益率(%)\",\"columnId\":39,\"columnName\":\"annual_rate\",\"columnType\":\"decimal(10,4)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 12:29:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isR', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 12:30:31', 60);
INSERT INTO `sys_oper_log` VALUES (153, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_wealth_ad\"}', NULL, 0, NULL, '2026-10-22 12:30:36', 611);
INSERT INTO `sys_oper_log` VALUES (154, '参数管理', 2, 'com.ClientBank.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":4,\"configKey\":\"sys.account.captchaEnabled\",\"configName\":\"账号自助-验证码开关\",\"configType\":\"Y\",\"configValue\":\"false\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 22:32:12\",\"params\":{},\"remark\":\"是否开启验证码功能（true开启，false关闭）\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 13:03:18', 14);
INSERT INTO `sys_oper_log` VALUES (155, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 13:03:46', 72);
INSERT INTO `sys_oper_log` VALUES (156, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2008', '127.0.0.1', '内网IP', '2008 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-22 14:05:13', 18);
INSERT INTO `sys_oper_log` VALUES (157, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2008', '127.0.0.1', '内网IP', '2008 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-22 14:05:14', 6);
INSERT INTO `sys_oper_log` VALUES (158, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:29', 35);
INSERT INTO `sys_oper_log` VALUES (159, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2014', '127.0.0.1', '内网IP', '2014 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:41', 8);
INSERT INTO `sys_oper_log` VALUES (160, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-10-22 14:05:43', 3);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2015', '127.0.0.1', '内网IP', '2015 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:44', 7);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2016', '127.0.0.1', '内网IP', '2016 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:46', 19);
INSERT INTO `sys_oper_log` VALUES (163, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2017', '127.0.0.1', '内网IP', '2017 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:47', 9);
INSERT INTO `sys_oper_log` VALUES (164, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2018', '127.0.0.1', '内网IP', '2018 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:49', 7);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:55', 8);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2012', '127.0.0.1', '内网IP', '2012 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:57', 6);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2010', '127.0.0.1', '内网IP', '2010 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:05:59', 7);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2011', '127.0.0.1', '内网IP', '2011 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:06:00', 8);
INSERT INTO `sys_oper_log` VALUES (169, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2009', '127.0.0.1', '内网IP', '2009 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:06:02', 6);
INSERT INTO `sys_oper_log` VALUES (170, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2008', '127.0.0.1', '内网IP', '2008 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:06:03', 6);
INSERT INTO `sys_oper_log` VALUES (171, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2007', '127.0.0.1', '内网IP', '2007 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:06:06', 6);
INSERT INTO `sys_oper_log` VALUES (172, '代码生成', 3, 'com.ClientBank.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/4', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:06:45', 24);
INSERT INTO `sys_oper_log` VALUES (173, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"customerExt\",\"className\":\"BankCustomerExt\",\"columns\":[{\"capJavaField\":\"ExtId\",\"columnComment\":\"主键ID\",\"columnId\":29,\"columnName\":\"ext_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"extId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:06\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID（一对一关联，唯一）\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:06\",\"usableColumn\":false},{\"capJavaField\":\"RealName\",\"columnComment\":\"真实姓名（与身份证一致）\",\"columnId\":31,\"columnName\":\"real_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"realName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:06\",\"usableColumn\":false},{\"capJavaField\":\"IdCardNumber\",\"columnComment\":\"证件号码（用于实名校验）\",\"columnId\":32,\"columnName\":\"id_card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"d', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:07:15', 58);
INSERT INTO `sys_oper_log` VALUES (174, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"account\",\"className\":\"BankAccount\",\"columns\":[{\"capJavaField\":\"AccountId\",\"columnComment\":\"账户ID\",\"columnId\":21,\"columnName\":\"account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"accountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:14\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"关联sys_user的用户ID\",\"columnId\":22,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:14\",\"usableColumn\":false},{\"capJavaField\":\"CardNumber\",\"columnComment\":\"银行卡号\",\"columnId\":23,\"columnName\":\"card_number\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"cardNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 10:40:14\",\"usableColumn\":false},{\"capJavaField\":\"AccountType\",\"columnComment\":\"账户类型（1-储蓄卡，2-信用卡）\",\"columnId\":24,\"columnName\":\"account_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:33:33\",\"dictType\":\"\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:07:43', 27);
INSERT INTO `sys_oper_log` VALUES (175, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"bank_customer_ext\"}', NULL, 0, NULL, '2026-10-22 14:07:50', 297);
INSERT INTO `sys_oper_log` VALUES (176, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2023,2024],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 14:16:00', 292);
INSERT INTO `sys_oper_log` VALUES (177, '客户信息', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.edit()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/manage/customerExt', '127.0.0.1', '内网IP', '{\"accountStatus\":\"0\",\"bankAccountList\":[{\"accountId\":1,\"accountType\":\"1\",\"balance\":100000,\"cardNumber\":\"622202196001011234\",\"createTime\":\"2026-10-22 12:24:03\",\"creditLimit\":200000,\"currency\":\"CNY\",\"params\":{}},{\"accountId\":1,\"accountType\":\"1\",\"balance\":58234.5,\"cardNumber\":\"622202197508230001\",\"createTime\":\"2026-10-22 09:15:30\",\"creditLimit\":30000,\"currency\":\"CNY\",\"params\":{}},{\"accountId\":1,\"accountType\":\"1\",\"balance\":2500.8,\"cardNumber\":\"622202198205120002\",\"createTime\":\"2026-10-22 10:05:12\",\"creditLimit\":10000,\"currency\":\"CNY\",\"params\":{}},{\"accountId\":1,\"accountType\":\"2\",\"balance\":15.2,\"cardNumber\":\"622202199511020003\",\"createTime\":\"2026-10-22 11:30:45\",\"creditLimit\":5000,\"currency\":\"CNY\",\"params\":{}}],\"extId\":1,\"idCardNumber\":\"420101196001010000\",\"params\":{},\"realName\":\"高育良\",\"remark\":\"人大代表123\",\"residenceAddress\":\"汉东省汉东市汉东大街1号\",\"userId\":100} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'user_id\' cannot be null\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\BankCustomerExtMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: insert into bank_account( account_id, user_id, card_number, account_type, balance, credit_limit, currency, create_time) values                        ( ?, ?, ?, ?, ?, ?, ?, ?)          ,              ( ?, ?, ?, ?, ?, ?, ?, ?)          ,              ( ?, ?, ?, ?, ?, ?, ?, ?)          ,              ( ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'user_id\' cannot be null\n; Column \'user_id\' cannot be null', '2026-10-22 15:08:44', 483);
INSERT INTO `sys_oper_log` VALUES (178, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"230968889@qq.com\",\"nickName\":\"高育良\",\"params\":{},\"phonenumber\":\"18925631452\",\"sex\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 15:12:17', 17);
INSERT INTO `sys_oper_log` VALUES (179, '用户管理', 1, 'com.ClientBank.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":200,\"email\":\"26877777777@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332222\",\"postIds\":[5],\"roleIds\":[100],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 15:57:56', 131);
INSERT INTO `sys_oper_log` VALUES (180, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"transfer_record\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:09:24', 111);
INSERT INTO `sys_oper_log` VALUES (181, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"record\",\"className\":\"TransferRecord\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":44,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TransferNo\",\"columnComment\":\"转账业务单号\",\"columnId\":45,\"columnName\":\"transfer_no\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"transferNo\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"FromAccountId\",\"columnComment\":\"转出账户ID\",\"columnId\":46,\"columnName\":\"from_account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"fromAccountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ToAccountId\",\"columnComment\":\"转入账户ID\",\"columnId\":47,\"columnName\":\"to_account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:10:22', 49);
INSERT INTO `sys_oper_log` VALUES (182, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"transfer_record\"}', NULL, 0, NULL, '2026-10-22 16:10:26', 275);
INSERT INTO `sys_oper_log` VALUES (183, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2032', '127.0.0.1', '内网IP', '2032 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:26', 57);
INSERT INTO `sys_oper_log` VALUES (184, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2033', '127.0.0.1', '内网IP', '2033 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:28', 11);
INSERT INTO `sys_oper_log` VALUES (185, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2034', '127.0.0.1', '内网IP', '2034 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:29', 30);
INSERT INTO `sys_oper_log` VALUES (186, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2035', '127.0.0.1', '内网IP', '2035 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:31', 9);
INSERT INTO `sys_oper_log` VALUES (187, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2036', '127.0.0.1', '内网IP', '2036 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:33', 26);
INSERT INTO `sys_oper_log` VALUES (188, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2031', '127.0.0.1', '内网IP', '2031 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:15:35', 10);
INSERT INTO `sys_oper_log` VALUES (189, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2025', '127.0.0.1', '内网IP', '2025 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-10-22 16:16:55', 3);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2026', '127.0.0.1', '内网IP', '2026 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:16:57', 9);
INSERT INTO `sys_oper_log` VALUES (191, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2027', '127.0.0.1', '内网IP', '2027 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:16:58', 23);
INSERT INTO `sys_oper_log` VALUES (192, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2028', '127.0.0.1', '内网IP', '2028 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:17:00', 12);
INSERT INTO `sys_oper_log` VALUES (193, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2029', '127.0.0.1', '内网IP', '2029 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:17:02', 15);
INSERT INTO `sys_oper_log` VALUES (194, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2030', '127.0.0.1', '内网IP', '2030 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:17:03', 16);
INSERT INTO `sys_oper_log` VALUES (195, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2025', '127.0.0.1', '内网IP', '2025 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:17:05', 13);
INSERT INTO `sys_oper_log` VALUES (196, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"TransferRecord\",\"className\":\"TransferRecord\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":44,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 16:10:22\",\"usableColumn\":false},{\"capJavaField\":\"TransferNo\",\"columnComment\":\"转账业务单号\",\"columnId\":45,\"columnName\":\"transfer_no\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"transferNo\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 16:10:22\",\"usableColumn\":false},{\"capJavaField\":\"FromAccountId\",\"columnComment\":\"转出账户ID\",\"columnId\":46,\"columnName\":\"from_account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"fromAccountId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-10-22 16:10:22\",\"usableColumn\":false},{\"capJavaField\":\"ToAccountId\",\"columnComment\":\"转入账户ID\",\"columnId\":47,\"columnName\":\"to_account_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-10-22 16:09:24\",\"dictType\":\"\",\"edit\":false,\"htmlTyp', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:17:52', 101);
INSERT INTO `sys_oper_log` VALUES (197, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"transfer_record\"}', NULL, 0, NULL, '2026-10-22 16:17:54', 305);
INSERT INTO `sys_oper_log` VALUES (198, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferRecord/index\",\"createTime\":\"2026-10-22 16:18:12\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"用户转账记录\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"TransferRecord\",\"perms\":\"manage:TransferRecord:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:20:35', 35);
INSERT INTO `sys_oper_log` VALUES (199, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/customerExt/index\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"客户信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"customerExt\",\"perms\":\"manage:customerExt:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:21:11', 17);
INSERT INTO `sys_oper_log` VALUES (200, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2023,2024,2037,2038,2039,2040,2041,2042],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 16:22:03', 29);
INSERT INTO `sys_oper_log` VALUES (201, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"系统功能\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"/manage/func\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:32:10', 31);
INSERT INTO `sys_oper_log` VALUES (202, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"用户功能\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"/manage/func\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:32:23', 9);
INSERT INTO `sys_oper_log` VALUES (203, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"用户功能\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"manage/func\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:32:38', 8);
INSERT INTO `sys_oper_log` VALUES (204, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"用户功能\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"clientBank\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'用户功能\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-10-22 17:32:48', 5);
INSERT INTO `sys_oper_log` VALUES (205, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"用户功能\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"func\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:34:18', 16);
INSERT INTO `sys_oper_log` VALUES (206, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 23:52:13\",\"icon\":\"logininfor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"个人信息\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"info\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:34:26', 12);
INSERT INTO `sys_oper_log` VALUES (207, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/customerExt/index\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"客户信息\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"customerExt\",\"perms\":\"manage:customerExt:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:36:40', 11);
INSERT INTO `sys_oper_log` VALUES (208, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferRecord/index\",\"createTime\":\"2026-10-22 16:18:12\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"用户转账记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"TransferRecord\",\"perms\":\"manage:TransferRecord:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:37:56', 8);
INSERT INTO `sys_oper_log` VALUES (209, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/customerExt/index\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"客户信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"customerExt\",\"perms\":\"manage:customerExt:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:38:03', 15);
INSERT INTO `sys_oper_log` VALUES (210, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:39:52', 20);
INSERT INTO `sys_oper_log` VALUES (211, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 22:32:12\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:40:01', 10);
INSERT INTO `sys_oper_log` VALUES (212, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:40:20', 10);
INSERT INTO `sys_oper_log` VALUES (213, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:40:44', 11);
INSERT INTO `sys_oper_log` VALUES (214, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"perms\":\"add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:42:26', 13);
INSERT INTO `sys_oper_log` VALUES (215, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"perms\":\"manage:TransferFunc:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 17:42:45', 8);
INSERT INTO `sys_oper_log` VALUES (216, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2023,2024,2037,2038,2039,2040,2041,2042,2043,2044],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-22 18:44:11', 55);
INSERT INTO `sys_oper_log` VALUES (217, '用户转账', 1, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"高育良\",\"code\":200}', 0, NULL, '2026-10-22 18:57:32', 40);
INSERT INTO `sys_oper_log` VALUES (218, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"高育良\",\"code\":200}', 0, NULL, '2026-10-22 19:12:48', 14);
INSERT INTO `sys_oper_log` VALUES (219, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"高育良\",\"code\":200}', 0, NULL, '2026-10-22 19:12:59', 2);
INSERT INTO `sys_oper_log` VALUES (220, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"高育良\",\"code\":200}', 0, NULL, '2026-10-22 19:14:06', 3);
INSERT INTO `sys_oper_log` VALUES (221, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"高育良\"}', 0, NULL, '2026-10-22 19:16:39', 10);
INSERT INTO `sys_oper_log` VALUES (222, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"高育良\"}', 0, NULL, '2026-10-22 19:17:00', 3);
INSERT INTO `sys_oper_log` VALUES (223, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"高育良\"}', 0, NULL, '2026-10-22 19:22:53', 3);
INSERT INTO `sys_oper_log` VALUES (224, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-22 20:02:30', 112);
INSERT INTO `sys_oper_log` VALUES (225, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202197508230000\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:26:33', 15);
INSERT INTO `sys_oper_log` VALUES (226, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202197508230000\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:26:37', 4);
INSERT INTO `sys_oper_log` VALUES (227, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 17:26:47', 3);
INSERT INTO `sys_oper_log` VALUES (228, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202196001011234\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"高育良\"}', 0, NULL, '2026-10-24 17:26:53', 3);
INSERT INTO `sys_oper_log` VALUES (229, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 17:26:58', 3);
INSERT INTO `sys_oper_log` VALUES (230, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 17:33:50', 4);
INSERT INTO `sys_oper_log` VALUES (231, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 17:35:01', 4);
INSERT INTO `sys_oper_log` VALUES (232, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250000\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:35:07', 3);
INSERT INTO `sys_oper_log` VALUES (233, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"321342\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:35:31', 3);
INSERT INTO `sys_oper_log` VALUES (234, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"432\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:35:42', 3);
INSERT INTO `sys_oper_log` VALUES (235, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"13412\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:36:03', 3);
INSERT INTO `sys_oper_log` VALUES (236, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"13412\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:37:57', 7);
INSERT INTO `sys_oper_log` VALUES (237, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"13412\"}', '{\"msg\":\"未找到该账户对应的用户信息\",\"code\":500}', 0, NULL, '2026-10-24 17:38:01', 2);
INSERT INTO `sys_oper_log` VALUES (238, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 17:38:03', 2);
INSERT INTO `sys_oper_log` VALUES (239, '用户转账', 0, 'com.ClientBank.manage.controller.TransferRecordController.getRealName()', 'GET', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord/getRealName', '127.0.0.1', '内网IP', '{\"cardNum\":\"622202199801250005\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":\"祁同伟\"}', 0, NULL, '2026-10-24 18:59:53', 2);
INSERT INTO `sys_oper_log` VALUES (240, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100.00,\"createTime\":\"2026-10-24 19:10:45\",\"fromAccountId\":1,\"params\":{},\"toAccountId\":2} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'transfer_no\' doesn\'t have a default value\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\TransferRecordMapper.xml]\r\n### The error may involve com.ClientBank.manage.mapper.TransferRecordMapper.insertTransferRecord-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into transfer_record          ( from_account_id,             to_account_id,                                       amount,                                                    create_time )           values ( ?,             ?,                                       ?,                                                    ? )\r\n### Cause: java.sql.SQLException: Field \'transfer_no\' doesn\'t have a default value\n; Field \'transfer_no\' doesn\'t have a default value', '2026-10-24 19:10:46', 490);
INSERT INTO `sys_oper_log` VALUES (241, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100.00,\"createTime\":\"2026-10-24 19:13:59\",\"fromAccountId\":1,\"params\":{},\"toAccountId\":2} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'transfer_no\' doesn\'t have a default value\r\n### The error may exist in file [D:\\IntelliJ IDEA\\projects\\ClientBank\\ClientBank-java\\ClientBank-manage\\target\\classes\\mapper\\manage\\TransferRecordMapper.xml]\r\n### The error may involve com.ClientBank.manage.mapper.TransferRecordMapper.insertTransferRecord-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into transfer_record          ( from_account_id,             to_account_id,                                       amount,                                                    create_time )           values ( ?,             ?,                                       ?,                                                    ? )\r\n### Cause: java.sql.SQLException: Field \'transfer_no\' doesn\'t have a default value\n; Field \'transfer_no\' doesn\'t have a default value', '2026-10-24 19:13:59', 21);
INSERT INTO `sys_oper_log` VALUES (242, '参数管理', 1, 'com.ClientBank.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"transfer.free.hours\",\"configName\":\"转账冻结时长\",\"configType\":\"Y\",\"configValue\":\"24\",\"createBy\":\"admin\",\"params\":{},\"remark\":\"默认 24 小时\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:46:49', 20);
INSERT INTO `sys_oper_log` VALUES (243, '参数管理', 1, 'com.ClientBank.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"transfer.unfree.enable\",\"configName\":\"解冻任务是否开启解冻任务是否开启\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"params\":{},\"remark\":\"控制任务是否执行\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:47:20', 9);
INSERT INTO `sys_oper_log` VALUES (244, '定时任务', 1, 'com.ClientBank.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"1\",\"createBy\":\"admin\",\"cronExpression\":\"0 0/5 * * * ?\",\"invokeTarget\":\"transferUnfreezeTask.unfreezeExpiredRecords()\",\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"jobName\":\"转账记录自动解冻\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-10-24 20:55:00\",\"params\":{},\"status\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:52:56', 52);
INSERT INTO `sys_oper_log` VALUES (245, '参数管理', 9, 'com.ClientBank.web.controller.system.SysConfigController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/config/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:55:09', 36);
INSERT INTO `sys_oper_log` VALUES (246, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:55:43', 48);
INSERT INTO `sys_oper_log` VALUES (247, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/changeStatus', '127.0.0.1', '内网IP', '{\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 20:55:51', 14);
INSERT INTO `sys_oper_log` VALUES (248, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":99.990000,\"createTime\":\"2026-10-24 21:18:51\",\"fee\":0.010000,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":8,\"params\":{},\"remark\":\"测试转账\",\"status\":1,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR8303520708\",\"updateTime\":\"2026-10-24 21:18:51\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-24 21:18:51', 66);
INSERT INTO `sys_oper_log` VALUES (249, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100.00,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 20:47:23', 54);
INSERT INTO `sys_oper_log` VALUES (250, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100.00,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 20:49:26', 18);
INSERT INTO `sys_oper_log` VALUES (251, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100.00,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 20:51:39', 12);
INSERT INTO `sys_oper_log` VALUES (252, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":99.90000,\"createTime\":\"2026-10-26 20:54:00\",\"fee\":0.10000,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":9,\"params\":{},\"remark\":\"测试转账\",\"status\":1,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR8575072098\",\"updateTime\":\"2026-10-26 20:54:00\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 20:54:00', 40);
INSERT INTO `sys_oper_log` VALUES (253, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 21:03:04\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 21:03:04\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":10,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR0199668886\",\"updateTime\":\"2026-10-26 21:03:04\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 21:03:04', 171);
INSERT INTO `sys_oper_log` VALUES (254, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 21:08:00\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 21:08:00\",\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"101\",\"id\":11,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"100\",\"transferNo\":\"TR3184191427\",\"updateTime\":\"2026-10-26 21:08:00\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 21:08:00', 14);
INSERT INTO `sys_oper_log` VALUES (255, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 21:17:19', 67);
INSERT INTO `sys_oper_log` VALUES (256, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 21:17:36\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 21:17:36\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR4807777973\",\"updateTime\":\"2026-10-26 21:17:36\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-26 21:17:36', 388);
INSERT INTO `sys_oper_log` VALUES (257, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 21:21:08\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 21:21:08\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR6075175148\",\"updateTime\":\"2026-10-26 21:21:08\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-26 21:21:08', 259);
INSERT INTO `sys_oper_log` VALUES (258, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 21:23:08\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 21:23:08\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":12,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR3967861680\",\"updateTime\":\"2026-10-26 21:23:08\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 21:23:09', 42);
INSERT INTO `sys_oper_log` VALUES (259, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":10000.00,\"availableBalance\":0,\"createTime\":\"2026-10-26 22:13:09\",\"fee\":10.00000,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"frozenBalance\":0,\"id\":13,\"params\":{},\"remark\":\"测试转账\",\"status\":1,\"toAccountId\":\"622202197508230001\",\"toUserId\":\"100\",\"transferNo\":\"TR2928209020\",\"updateTime\":\"2026-10-26 22:13:09\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 22:13:09', 43);
INSERT INTO `sys_oper_log` VALUES (260, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"availableBalance\":0,\"createTime\":\"2026-10-26 22:15:55\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 22:15:55\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"frozenBalance\":100000.00,\"id\":14,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR6172095269\",\"updateTime\":\"2026-10-26 22:15:55\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 22:15:55', 18);
INSERT INTO `sys_oper_log` VALUES (261, '调度日志', 9, 'com.ClientBank.quartz.controller.SysJobLogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/jobLog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 22:16:55', 188);
INSERT INTO `sys_oper_log` VALUES (262, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 22:17:10', 9);
INSERT INTO `sys_oper_log` VALUES (263, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"availableBalance\":0,\"createTime\":\"2026-10-26 22:20:27\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 22:20:27\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"frozenBalance\":100000.00,\"id\":15,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR6938001783\",\"updateTime\":\"2026-10-26 22:20:27\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 22:20:28', 15);
INSERT INTO `sys_oper_log` VALUES (264, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 22:22:22', 5);
INSERT INTO `sys_oper_log` VALUES (265, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 22:50:59', 50);
INSERT INTO `sys_oper_log` VALUES (266, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-26 22:51:42', 5);
INSERT INTO `sys_oper_log` VALUES (267, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000.00,\"createTime\":\"2026-10-26 22:53:02\",\"fee\":100.00000,\"freeTime\":\"2026-10-27 22:53:02\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":16,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR0201697408\",\"updateTime\":\"2026-10-26 22:53:02\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 22:53:02', 35);
INSERT INTO `sys_oper_log` VALUES (268, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:05:09\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:05:09\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":17,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR9552544546\",\"updateTime\":\"2026-10-26 23:05:09\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:05:09', 41);
INSERT INTO `sys_oper_log` VALUES (269, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'qitongwei', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:11:21\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:11:21\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":18,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR1799106757\",\"updateTime\":\"2026-10-26 23:11:21\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:11:21', 157);
INSERT INTO `sys_oper_log` VALUES (270, '调度日志', 9, 'com.ClientBank.quartz.controller.SysJobLogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/jobLog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:12:13', 133);
INSERT INTO `sys_oper_log` VALUES (271, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:12:19', 10);
INSERT INTO `sys_oper_log` VALUES (272, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:13:13', 6);
INSERT INTO `sys_oper_log` VALUES (273, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:19:43\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:19:43\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":19,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR2018216554\",\"updateTime\":\"2026-10-26 23:19:43\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:19:43', 145);
INSERT INTO `sys_oper_log` VALUES (274, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:20:02', 10);
INSERT INTO `sys_oper_log` VALUES (275, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:21:01', 6);
INSERT INTO `sys_oper_log` VALUES (276, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:25:09\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:25:09\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":20,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR8740851447\",\"updateTime\":\"2026-10-26 23:25:09\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:25:09', 25);
INSERT INTO `sys_oper_log` VALUES (277, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:25:41', 6);
INSERT INTO `sys_oper_log` VALUES (278, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:26:13', 10);
INSERT INTO `sys_oper_log` VALUES (279, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":150.00,\"createTime\":\"2026-10-26 23:26:31\",\"fee\":0.15000,\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":21,\"params\":{},\"remark\":\"测试转账\",\"status\":1,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR9538034800\",\"updateTime\":\"2026-10-26 23:26:31\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:26:31', 13);
INSERT INTO `sys_oper_log` VALUES (280, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:30:55', 42);
INSERT INTO `sys_oper_log` VALUES (281, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.edit()', 'PUT', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"1\",\"createBy\":\"admin\",\"createTime\":\"2026-10-24 20:52:56\",\"cronExpression\":\"0 0/5 * * * ?\",\"invokeTarget\":\"transferUnfreezeTask.unfreezeExpiredRecords()\",\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"jobName\":\"转账自动解冻\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-10-26 23:35:00\",\"params\":{},\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-10-24 20:55:51\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:31:36', 11);
INSERT INTO `sys_oper_log` VALUES (282, '调度日志', 9, 'com.ClientBank.quartz.controller.SysJobLogController.clean()', 'DELETE', 1, 'admin', '研发部门', '/monitor/jobLog/clean', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:40:35', 114);
INSERT INTO `sys_oper_log` VALUES (283, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:40:39', 9);
INSERT INTO `sys_oper_log` VALUES (284, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:43:32', 11);
INSERT INTO `sys_oper_log` VALUES (285, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:44:05\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:44:05\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":22,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR4077128281\",\"updateTime\":\"2026-10-26 23:44:05\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:44:05', 29);
INSERT INTO `sys_oper_log` VALUES (286, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:44:16', 5);
INSERT INTO `sys_oper_log` VALUES (287, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:44:51', 9);
INSERT INTO `sys_oper_log` VALUES (288, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'admin', '研发部门', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":15000.00,\"createTime\":\"2026-10-26 23:45:20\",\"fee\":15.00000,\"freeTime\":\"2026-10-27 23:45:20\",\"fromAccountId\":\"622202199801250005\",\"fromUserId\":\"101\",\"id\":23,\"params\":{},\"remark\":\"测试转账\",\"status\":0,\"toAccountId\":\"622202196001011234\",\"toUserId\":\"100\",\"transferNo\":\"TR5359360194\",\"updateTime\":\"2026-10-26 23:45:20\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-26 23:45:20', 14);
INSERT INTO `sys_oper_log` VALUES (289, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-26 23:45:43', 5);
INSERT INTO `sys_oper_log` VALUES (290, '部门管理', 3, 'com.ClientBank.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/101', '127.0.0.1', '内网IP', '101 ', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2026-10-26 23:54:07', 38);
INSERT INTO `sys_oper_log` VALUES (291, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"fromUserId\":\"100\",\"params\":{}} ', '{\"msg\":\"转出账户和转入账户不能为空\",\"code\":500}', 0, NULL, '2026-10-27 12:51:05', 250);
INSERT INTO `sys_oper_log` VALUES (292, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"fromUserId\":\"100\",\"params\":{}} ', '{\"msg\":\"转出账户和转入账户不能为空\",\"code\":500}', 0, NULL, '2026-10-27 12:51:15', 2);
INSERT INTO `sys_oper_log` VALUES (293, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"params\":{},\"remark\":\"ui网页测试转账\"} ', '{\"msg\":\"转出账户和转入账户不能为空\",\"code\":500}', 0, NULL, '2026-10-27 12:56:34', 6);
INSERT INTO `sys_oper_log` VALUES (294, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"params\":{},\"remark\":\"ui网页测试转账2\"} ', '{\"msg\":\"转出账户和转入账户不能为空\",\"code\":500}', 0, NULL, '2026-10-27 12:59:13', 5);
INSERT INTO `sys_oper_log` VALUES (295, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:06:11\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"网页测试转账\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR4597768826\",\"updateTime\":\"2026-10-27 13:06:11\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:06:12', 538);
INSERT INTO `sys_oper_log` VALUES (296, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:07:50\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"1233423\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR4346093655\",\"updateTime\":\"2026-10-27 13:07:50\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:07:50', 20);
INSERT INTO `sys_oper_log` VALUES (297, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:08:02\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"1233423\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR6230948390\",\"updateTime\":\"2026-10-27 13:08:02\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:08:02', 18);
INSERT INTO `sys_oper_log` VALUES (298, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:10:21\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"气142342\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR5275594301\",\"updateTime\":\"2026-10-27 13:10:21\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:10:21', 11);
INSERT INTO `sys_oper_log` VALUES (299, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:13:38\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"546\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR1116638923\",\"updateTime\":\"2026-10-27 13:13:38\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:13:38', 9);
INSERT INTO `sys_oper_log` VALUES (300, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:14:01\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"32435\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR5056421099\",\"updateTime\":\"2026-10-27 13:14:01\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:14:01', 15);
INSERT INTO `sys_oper_log` VALUES (301, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:36:00\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"6754456\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"transferNo\":\"TR6984981858\",\"updateTime\":\"2026-10-27 13:36:00\"} ', '{\"msg\":\"系统异常，转账失败\",\"code\":500}', 0, NULL, '2026-10-27 13:36:00', 186);
INSERT INTO `sys_oper_log` VALUES (302, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:39:45\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"id\":24,\"params\":{},\"remark\":\"32143423\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\",\"transferNo\":\"TR2438845793\",\"updateTime\":\"2026-10-27 13:39:45\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-27 13:39:45', 19);
INSERT INTO `sys_oper_log` VALUES (303, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":10000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足或账户异常，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-27 13:41:22', 6);
INSERT INTO `sys_oper_log` VALUES (304, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":10000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足或账户异常，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-27 13:41:26', 4);
INSERT INTO `sys_oper_log` VALUES (305, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100,\"createTime\":\"2026-10-27 13:41:35\",\"fee\":0.100,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"id\":25,\"params\":{},\"remark\":\"1213214\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\",\"transferNo\":\"TR1058154026\",\"updateTime\":\"2026-10-27 13:41:35\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-27 13:41:35', 9);
INSERT INTO `sys_oper_log` VALUES (306, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:42:46\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"id\":26,\"params\":{},\"remark\":\"13123\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\",\"transferNo\":\"TR6389900328\",\"updateTime\":\"2026-10-27 13:42:46\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-27 13:42:46', 14);
INSERT INTO `sys_oper_log` VALUES (307, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1000,\"createTime\":\"2026-10-27 13:47:16\",\"fee\":1.000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"id\":27,\"params\":{},\"remark\":\"6346345\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\",\"transferNo\":\"TR9297020861\",\"updateTime\":\"2026-10-27 13:47:16\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-10-27 13:47:16', 27);
INSERT INTO `sys_oper_log` VALUES (308, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"213124\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足或账户异常，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-27 13:47:51', 8);
INSERT INTO `sys_oper_log` VALUES (309, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"213124\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足或账户异常，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-27 13:47:58', 4);
INSERT INTO `sys_oper_log` VALUES (310, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100000000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"213124\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', NULL, 1, '余额不足或账户异常，无法完成转账', '2026-10-27 13:50:37', 31);
INSERT INTO `sys_oper_log` VALUES (311, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":10000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"325453\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', NULL, 1, '余额不足或账户异常，无法完成转账', '2026-10-27 13:51:43', 6);
INSERT INTO `sys_oper_log` VALUES (312, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":10000000000000,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"5645\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', NULL, 1, '余额不足或账户异常，无法完成转账', '2026-10-27 14:06:33', 37);
INSERT INTO `sys_oper_log` VALUES (313, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":3245452334,\"fromAccountId\":\"622202196001011234\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足或账户异常，无法完成转账\",\"code\":500}', 0, NULL, '2026-10-27 14:16:01', 27);
INSERT INTO `sys_oper_log` VALUES (314, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"bank_transaction_log\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:41:40', 81);
INSERT INTO `sys_oper_log` VALUES (315, '代码生成', 3, 'com.ClientBank.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/6', '127.0.0.1', '内网IP', '[6] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:44:39', 10);
INSERT INTO `sys_oper_log` VALUES (316, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"bank_transaction_log\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:45:09', 23);
INSERT INTO `sys_oper_log` VALUES (317, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:48:57', 15);
INSERT INTO `sys_oper_log` VALUES (318, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage:load\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:49:44', 12);
INSERT INTO `sys_oper_log` VALUES (319, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"manage:load\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:49:51', 11);
INSERT INTO `sys_oper_log` VALUES (320, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"manage:load:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:50:00', 9);
INSERT INTO `sys_oper_log` VALUES (321, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/load/index.vue\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"manage:load:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:51:38', 15);
INSERT INTO `sys_oper_log` VALUES (322, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/load/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"manage:load:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 18:51:44', 8);
INSERT INTO `sys_oper_log` VALUES (323, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/load/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"load\",\"perms\":\"manage:load:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 19:20:00', 27);
INSERT INTO `sys_oper_log` VALUES (324, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-27 19:23:28', 13);
INSERT INTO `sys_oper_log` VALUES (325, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2023,2024,2037,2038,2039,2040,2041,2042,2043,2044,2045],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 13:27:59', 45);
INSERT INTO `sys_oper_log` VALUES (326, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"信用借贷\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:38:12', 39);
INSERT INTO `sys_oper_log` VALUES (327, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2023', '127.0.0.1', '内网IP', '2023 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-29 20:39:03', 18);
INSERT INTO `sys_oper_log` VALUES (328, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2023', '127.0.0.1', '内网IP', '2023 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-29 20:39:17', 3);
INSERT INTO `sys_oper_log` VALUES (329, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2024', '127.0.0.1', '内网IP', '2024 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-29 20:39:20', 4);
INSERT INTO `sys_oper_log` VALUES (330, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"客户信息导出\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2019,\"path\":\"#\",\"perms\":\"manage:customerExt:export\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:39:25', 9);
INSERT INTO `sys_oper_log` VALUES (331, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2024', '127.0.0.1', '内网IP', '2024 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-29 20:39:28', 3);
INSERT INTO `sys_oper_log` VALUES (332, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"客户信息导出\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2019,\"path\":\"#\",\"perms\":\"manage:customerExt:export\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:39:31', 10);
INSERT INTO `sys_oper_log` VALUES (333, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2043,2044,2045],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:40:16', 83);
INSERT INTO `sys_oper_log` VALUES (334, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2024', '127.0.0.1', '内网IP', '2024 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:40:22', 7);
INSERT INTO `sys_oper_log` VALUES (335, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2023', '127.0.0.1', '内网IP', '2023 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:40:25', 8);
INSERT INTO `sys_oper_log` VALUES (336, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2043,2044,2045],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:40:31', 20);
INSERT INTO `sys_oper_log` VALUES (337, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:41:23', 6);
INSERT INTO `sys_oper_log` VALUES (338, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"借贷或还款\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2045,\"perms\":\"manage:loan:add\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:42:44', 9);
INSERT INTO `sys_oper_log` VALUES (339, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"查询个人信息\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2045,\"perms\":\"manage:loan:query\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:43:19', 17);
INSERT INTO `sys_oper_log` VALUES (340, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-29 20:49:34', 57);
INSERT INTO `sys_oper_log` VALUES (341, '参数管理', 2, 'com.ClientBank.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":7,\"configKey\":\"sys.account.initPasswordModify\",\"configName\":\"用户管理-初始密码修改策略\",\"configType\":\"Y\",\"configValue\":\"0\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 22:32:12\",\"params\":{},\"remark\":\"0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-30 13:04:16', 36);
INSERT INTO `sys_oper_log` VALUES (342, '参数管理', 1, 'com.ClientBank.web.controller.system.SysConfigController.add()', 'POST', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configKey\":\"loan.daily.interest.rate\",\"configName\":\"借款日利率\",\"configType\":\"N\",\"configValue\":\"0.001\",\"createBy\":\"admin\",\"params\":{},\"remark\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-30 14:02:53', 35);
INSERT INTO `sys_oper_log` VALUES (343, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"还款\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2045,\"perms\":\"manage:loan:update\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-30 15:22:18', 345);
INSERT INTO `sys_oper_log` VALUES (344, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,2048],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-30 15:24:00', 52);
INSERT INTO `sys_oper_log` VALUES (345, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/transferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"transferFunc\",\"perms\":\"manage:transferFunc:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 10:58:12', 36);
INSERT INTO `sys_oper_log` VALUES (346, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:31:38', 22);
INSERT INTO `sys_oper_log` VALUES (347, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"民间借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:33:09', 10);
INSERT INTO `sys_oper_log` VALUES (348, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2046', '127.0.0.1', '内网IP', '2046 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-31 11:51:29', 24);
INSERT INTO `sys_oper_log` VALUES (349, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2046', '127.0.0.1', '内网IP', '2046 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-10-31 11:51:32', 4);
INSERT INTO `sys_oper_log` VALUES (350, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2043,2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2044],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:51:47', 64);
INSERT INTO `sys_oper_log` VALUES (351, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2046', '127.0.0.1', '内网IP', '2046 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:51:51', 9);
INSERT INTO `sys_oper_log` VALUES (352, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2047', '127.0.0.1', '内网IP', '2047 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:51:53', 12);
INSERT INTO `sys_oper_log` VALUES (353, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2048', '127.0.0.1', '内网IP', '2048 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:51:54', 8);
INSERT INTO `sys_oper_log` VALUES (354, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:53:31', 21);
INSERT INTO `sys_oper_log` VALUES (355, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-27 18:48:57\",\"icon\":\"借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2045,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:54:29', 9);
INSERT INTO `sys_oper_log` VALUES (356, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2045', '127.0.0.1', '内网IP', '2045 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:54:42', 10);
INSERT INTO `sys_oper_log` VALUES (357, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan\",\"createBy\":\"admin\",\"icon\":\"借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"manage/loan/index\",\"perms\":\"manage:loan\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:56:22', 14);
INSERT INTO `sys_oper_log` VALUES (358, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-31 11:56:22\",\"icon\":\"借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"manage/loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:56:32', 11);
INSERT INTO `sys_oper_log` VALUES (359, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-31 11:56:22\",\"icon\":\"借贷\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 11:56:44', 11);
INSERT INTO `sys_oper_log` VALUES (360, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2043,2044,2049],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:01:53', 13);
INSERT INTO `sys_oper_log` VALUES (361, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"借款\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2049,\"perms\":\"manage:loan:add\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:06:46', 22);
INSERT INTO `sys_oper_log` VALUES (362, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"还贷\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2049,\"perms\":\"manage:loan:update\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:07:08', 8);
INSERT INTO `sys_oper_log` VALUES (363, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"查询\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2049,\"perms\":\"manage:loan:query\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:07:22', 9);
INSERT INTO `sys_oper_log` VALUES (364, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2037,2038,2039,2040,2041,2042,2043,2044,2049,2050,2051,2052],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:07:41', 23);
INSERT INTO `sys_oper_log` VALUES (365, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-31 11:56:22\",\"icon\":\"还钱\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:13:43', 7);
INSERT INTO `sys_oper_log` VALUES (366, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-31 11:56:22\",\"icon\":\"还钱\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2043,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:15:08', 7);
INSERT INTO `sys_oper_log` VALUES (367, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferRecord/index\",\"createTime\":\"2026-10-22 16:18:12\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"用户转账记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"TransferRecord\",\"perms\":\"manage:TransferRecord:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:26:18', 13);
INSERT INTO `sys_oper_log` VALUES (368, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/TransferRecord/index\",\"createTime\":\"2026-10-22 16:18:12\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2037,\"menuName\":\"转账记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2043,\"path\":\"TransferRecord\",\"perms\":\"manage:TransferRecord:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 12:26:35', 11);
INSERT INTO `sys_oper_log` VALUES (369, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"个人概况\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:49:31', 195);
INSERT INTO `sys_oper_log` VALUES (370, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"overview\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"个人概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:overiew\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:50:15', 14);
INSERT INTO `sys_oper_log` VALUES (371, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"overview\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"个人概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:overiew\",\"query\":\"manage/overview/dashboard\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:51:08', 21);
INSERT INTO `sys_oper_log` VALUES (372, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"overview\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"个人概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:overiew\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:51:18', 11);
INSERT INTO `sys_oper_log` VALUES (373, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"overview\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"个人概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:account:dashboard\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:52:25', 25);
INSERT INTO `sys_oper_log` VALUES (374, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2053,2043,2037,2038,2039,2040,2041,2042,2044,2049,2050,2051,2052],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 13:53:16', 71);
INSERT INTO `sys_oper_log` VALUES (375, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/overview/index\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"个人概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:account:dashboard\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-10-31 14:08:54', 23);
INSERT INTO `sys_oper_log` VALUES (376, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/customerExt/index\",\"createTime\":\"2026-10-22 14:11:14\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"我的信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"customerExt\",\"perms\":\"manage:customerExt:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 12:58:04', 38);
INSERT INTO `sys_oper_log` VALUES (377, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/overview/index\",\"createTime\":\"2026-10-31 13:49:31\",\"icon\":\"概览\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2053,\"menuName\":\"我的概况\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"manage/overview\",\"perms\":\"manage:account:dashboard\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 12:58:10', 13);
INSERT INTO `sys_oper_log` VALUES (378, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-11-03 13:04:34', 23);
INSERT INTO `sys_oper_log` VALUES (379, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-11-03 13:04:37', 6);
INSERT INTO `sys_oper_log` VALUES (380, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-11-03 13:05:05', 5);
INSERT INTO `sys_oper_log` VALUES (381, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"params\":{},\"remark\":\"测试转账\",\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\"} ', '{\"msg\":\"余额不足，无法完成转账\",\"code\":500}', 0, NULL, '2026-11-03 13:05:09', 8);
INSERT INTO `sys_oper_log` VALUES (382, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":1,\"createTime\":\"2026-11-03 13:05:27\",\"fee\":0.001,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"id\":28,\"params\":{},\"remark\":\"测试转账\",\"status\":1,\"toAccountId\":\"622202199801250005\",\"toUserId\":\"101\",\"transferNo\":\"TR9756873266\",\"updateTime\":\"2026-11-03 13:05:27\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-11-03 13:05:27', 19);
INSERT INTO `sys_oper_log` VALUES (383, '用户转账记录', 1, 'com.ClientBank.manage.controller.TransferRecordController.add()', 'POST', 1, 'gaoyuliang', '银行客户部', '/manage/TransferRecord', '127.0.0.1', '内网IP', '{\"amount\":100,\"createTime\":\"2026-11-03 13:05:57\",\"fee\":0.100,\"fromAccountId\":\"622202197508230001\",\"fromUserId\":\"100\",\"id\":29,\"params\":{},\"remark\":\"贪污款\",\"status\":1,\"toAccountId\":\"622202198205120002\",\"toUserId\":\"100\",\"transferNo\":\"TR0443267185\",\"updateTime\":\"2026-11-03 13:05:57\"} ', '{\"msg\":\"转账成功\",\"code\":200}', 0, NULL, '2026-11-03 13:05:57', 9);
INSERT INTO `sys_oper_log` VALUES (384, '定时任务', 1, 'com.ClientBank.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"1\",\"createBy\":\"admin\",\"cronExpression\":\"0 0 0 * * ?\",\"invokeTarget\":\"loanOverdueTask.checkAndMarkOverdueAsException\",\"jobGroup\":\"SYSTEM\",\"jobId\":101,\"jobName\":\"逾期账户检查\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-11-04 00:00:00\",\"params\":{},\"status\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 14:46:37', 97);
INSERT INTO `sys_oper_log` VALUES (385, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/changeStatus', '127.0.0.1', '内网IP', '{\"jobId\":101,\"misfirePolicy\":\"0\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 14:46:50', 17);
INSERT INTO `sys_oper_log` VALUES (386, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":101,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 14:47:03', 17);
INSERT INTO `sys_oper_log` VALUES (387, '定时任务', 2, 'com.ClientBank.quartz.controller.SysJobController.run()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/run', '127.0.0.1', '内网IP', '{\"jobGroup\":\"SYSTEM\",\"jobId\":101,\"misfirePolicy\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-03 14:48:53', 14);
INSERT INTO `sys_oper_log` VALUES (388, '参数管理', 2, 'com.ClientBank.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 22:32:12\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 18:56:42', 43);
INSERT INTO `sys_oper_log` VALUES (389, '代码生成', 6, 'com.ClientBank.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"biz_reservation_log,biz_reservation\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:15:58', 222);
INSERT INTO `sys_oper_log` VALUES (390, '字典类型', 1, 'com.ClientBank.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"业务服务清单\",\"dictType\":\"biz_service_type\",\"params\":{},\"remark\":\"业务服务清单\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:19:34', 12);
INSERT INTO `sys_oper_log` VALUES (391, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅱ类户开立\",\"dictSort\":0,\"dictType\":\"biz_service_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:20:32', 10);
INSERT INTO `sys_oper_log` VALUES (392, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"Ⅰ类户开卡\",\"dictSort\":0,\"dictType\":\"biz_service_type\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:20:42', 6);
INSERT INTO `sys_oper_log` VALUES (393, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"大额取现预约\",\"dictSort\":0,\"dictType\":\"biz_service_type\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:23:03', 9);
INSERT INTO `sys_oper_log` VALUES (394, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"reservation\",\"className\":\"BizReservation\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"预约单号(主键)\",\"columnId\":74,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":75,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ServiceCode\",\"columnComment\":\"服务编码(如:OPEN_I_ACCOUNT)\",\"columnId\":76,\"columnName\":\"service_code\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"serviceCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ServiceName\",\"columnComment\":\"服务名称(冗余展示)\",\"columnId\":77,\"columnName\":\"service_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:24:21', 49);
INSERT INTO `sys_oper_log` VALUES (395, '字典类型', 1, 'com.ClientBank.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"预约状态\",\"dictType\":\"biz_reservation_status\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:24:58', 7);
INSERT INTO `sys_oper_log` VALUES (396, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"待处理 (刚提交)\",\"dictSort\":0,\"dictType\":\"biz_reservation_status\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:25:21', 8);
INSERT INTO `sys_oper_log` VALUES (397, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已受理 (柜员接单)\",\"dictSort\":0,\"dictType\":\"biz_reservation_status\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:25:32', 5);
INSERT INTO `sys_oper_log` VALUES (398, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已完成 (办理完)\",\"dictSort\":0,\"dictType\":\"biz_reservation_status\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:25:39', 7);
INSERT INTO `sys_oper_log` VALUES (399, '字典数据', 1, 'com.ClientBank.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已取消 (客户放弃)\",\"dictSort\":0,\"dictType\":\"biz_reservation_status\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:25:47', 83);
INSERT INTO `sys_oper_log` VALUES (400, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"reservation\",\"className\":\"BizReservation\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"预约单号(主键)\",\"columnId\":74,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:24:21\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":75,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:24:21\",\"usableColumn\":false},{\"capJavaField\":\"ServiceCode\",\"columnComment\":\"服务编码(如:OPEN_I_ACCOUNT)\",\"columnId\":76,\"columnName\":\"service_code\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"serviceCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:24:21\",\"usableColumn\":false},{\"capJavaField\":\"ServiceName\",\"columnComment\":\"服务名称(冗余展示)\",\"columnId\":77,\"columnName\":\"service_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"inp', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:27:14', 33);
INSERT INTO `sys_oper_log` VALUES (401, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"reservation\",\"className\":\"BizReservation\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"预约单号(主键)\",\"columnId\":74,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:27:14\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":75,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:27:14\",\"usableColumn\":false},{\"capJavaField\":\"ServiceCode\",\"columnComment\":\"服务编码(如:OPEN_I_ACCOUNT)\",\"columnId\":76,\"columnName\":\"service_code\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"account_type\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"serviceCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:27:14\",\"usableColumn\":false},{\"capJavaField\":\"ServiceName\",\"columnComment\":\"服务名称(冗余展示)\",\"columnId\":77,\"columnName\":\"service_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"ht', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:43:34', 31);
INSERT INTO `sys_oper_log` VALUES (402, '代码生成', 2, 'com.ClientBank.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"reservation\",\"className\":\"BizReservation\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"预约单号(主键)\",\"columnId\":74,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:43:34\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":75,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:43:34\",\"usableColumn\":false},{\"capJavaField\":\"ServiceCode\",\"columnComment\":\"服务编码(如:OPEN_I_ACCOUNT)\",\"columnId\":76,\"columnName\":\"service_code\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"account_type\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"serviceCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":8,\"updateBy\":\"\",\"updateTime\":\"2026-11-09 20:43:34\",\"usableColumn\":false},{\"capJavaField\":\"ServiceName\",\"columnComment\":\"服务名称(冗余展示)\",\"columnId\":77,\"columnName\":\"service_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-11-09 20:15:58\",\"dictType\":\"\",\"edit\":true,\"ht', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:44:59', 30);
INSERT INTO `sys_oper_log` VALUES (403, '代码生成', 8, 'com.ClientBank.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"biz_reservation\"}', NULL, 0, NULL, '2026-11-09 20:45:03', 521);
INSERT INTO `sys_oper_log` VALUES (404, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"自助功能\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'自助功能\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:51:15', 32);
INSERT INTO `sys_oper_log` VALUES (405, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2055', '127.0.0.1', '内网IP', '2055 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:51:33', 26);
INSERT INTO `sys_oper_log` VALUES (406, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2056', '127.0.0.1', '内网IP', '2056 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:51:34', 7);
INSERT INTO `sys_oper_log` VALUES (407, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2057', '127.0.0.1', '内网IP', '2057 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:51:36', 4);
INSERT INTO `sys_oper_log` VALUES (408, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2058', '127.0.0.1', '内网IP', '2058 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:51:37', 3);
INSERT INTO `sys_oper_log` VALUES (409, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2059', '127.0.0.1', '内网IP', '2059 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:51:39', 6);
INSERT INTO `sys_oper_log` VALUES (410, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2054', '127.0.0.1', '内网IP', '2054 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:52:28', 5);
INSERT INTO `sys_oper_log` VALUES (411, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"自助版块\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:52:53', 16);
INSERT INTO `sys_oper_log` VALUES (412, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 22:32:12\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:53:01', 13);
INSERT INTO `sys_oper_log` VALUES (413, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 22:32:12\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:53:10', 7);
INSERT INTO `sys_oper_log` VALUES (414, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-21 22:32:12\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:53:17', 6);
INSERT INTO `sys_oper_log` VALUES (415, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"自助版块\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reservation\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:53:23', 8);
INSERT INTO `sys_oper_log` VALUES (416, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"个人自助\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reservation\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:53:59', 7);
INSERT INTO `sys_oper_log` VALUES (417, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"个人自助\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"个人自助\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reservation\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:54:25', 12);
INSERT INTO `sys_oper_log` VALUES (418, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"自助预约\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"routeName\":\"reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'自助预约\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:55:27', 5);
INSERT INTO `sys_oper_log` VALUES (419, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"自助预约\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'自助预约\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:55:32', 4);
INSERT INTO `sys_oper_log` VALUES (420, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:56:31', 3);
INSERT INTO `sys_oper_log` VALUES (421, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createBy\":\"admin\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:56:39', 8);
INSERT INTO `sys_oper_log` VALUES (422, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"manage:\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:57:26', 7);
INSERT INTO `sys_oper_log` VALUES (423, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"manage:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:57:33', 6);
INSERT INTO `sys_oper_log` VALUES (424, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:58:53', 3);
INSERT INTO `sys_oper_log` VALUES (425, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:58:57', 5);
INSERT INTO `sys_oper_log` VALUES (426, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:58:59', 3);
INSERT INTO `sys_oper_log` VALUES (427, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:59:01', 3);
INSERT INTO `sys_oper_log` VALUES (428, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 20:59:02', 3);
INSERT INTO `sys_oper_log` VALUES (429, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservatio\",\"perms\":\"reservation:list\",\"routeName\":\"Reservatio\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 20:59:13', 9);
INSERT INTO `sys_oper_log` VALUES (430, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 21:01:13', 3);
INSERT INTO `sys_oper_log` VALUES (431, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 21:01:15', 4);
INSERT INTO `sys_oper_log` VALUES (432, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 21:02:28', 5);
INSERT INTO `sys_oper_log` VALUES (433, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'预约业务\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-11-09 21:02:44', 5);
INSERT INTO `sys_oper_log` VALUES (434, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"个人自助\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"个人自助\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"biz_manage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:04:38', 8);
INSERT INTO `sys_oper_log` VALUES (435, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"预约业务\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:04:52', 6);
INSERT INTO `sys_oper_log` VALUES (436, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2053,2043,2037,2038,2039,2040,2041,2042,2044,2049,2050,2051,2052,2060,2061],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:05:27', 35);
INSERT INTO `sys_oper_log` VALUES (437, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:16:19', 23);
INSERT INTO `sys_oper_log` VALUES (438, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/servicehall/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"servicehall\",\"perms\":\"servicehall:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:17:15', 11);
INSERT INTO `sys_oper_log` VALUES (439, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:18:08', 16);
INSERT INTO `sys_oper_log` VALUES (440, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务预约\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:18:30', 6);
INSERT INTO `sys_oper_log` VALUES (441, '菜单管理', 1, 'com.ClientBank.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/servicehall/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"servicehall\",\"routeName\":\"ServiceHall\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:19:25', 10);
INSERT INTO `sys_oper_log` VALUES (442, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/servicehall/index\",\"createTime\":\"2026-11-09 21:19:25\",\"icon\":\"业务\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2062,\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"servicehall\",\"perms\":\"\",\"routeName\":\"ServiceHall\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:20:29', 12);
INSERT INTO `sys_oper_log` VALUES (443, '角色管理', 2, 'com.ClientBank.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-10-21 23:13:37\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2019,2020,2021,2022,2053,2043,2037,2038,2039,2040,2041,2042,2044,2049,2050,2051,2052,2060,2061,2062],\"params\":{},\"remark\":\"银行的普通用户角色\",\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-09 21:21:30', 44);
INSERT INTO `sys_oper_log` VALUES (444, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"自助服务\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"个人自助\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"biz_manage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:26:12', 38);
INSERT INTO `sys_oper_log` VALUES (445, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/servicehall/index\",\"createTime\":\"2026-11-09 21:19:25\",\"icon\":\"业务\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2062,\"menuName\":\"业务大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"servicehall\",\"perms\":\"\",\"routeName\":\"ServiceHall\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:29:24', 13);
INSERT INTO `sys_oper_log` VALUES (446, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务预约\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"reservation:list\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:31:59', 14);
INSERT INTO `sys_oper_log` VALUES (447, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/servicehall/index\",\"createTime\":\"2026-11-09 21:19:25\",\"icon\":\"业务\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2062,\"menuName\":\"自助大厅\",\"menuType\":\"C\",\"orderNum\":0,\"params\":{},\"parentId\":2060,\"path\":\"servicehall\",\"perms\":\"\",\"routeName\":\"ServiceHall\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:32:28', 12);
INSERT INTO `sys_oper_log` VALUES (448, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"我的记录\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"func\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:42:03', 10);
INSERT INTO `sys_oper_log` VALUES (449, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/transferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"对外转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2060,\"path\":\"transferFunc\",\"perms\":\"manage:transferFunc:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:42:19', 12);
INSERT INTO `sys_oper_log` VALUES (450, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/loan/index\",\"createTime\":\"2026-10-31 11:56:22\",\"icon\":\"还钱\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"借贷与还款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2060,\"path\":\"loan\",\"perms\":\"manage:loan\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:42:35', 16);
INSERT INTO `sys_oper_log` VALUES (451, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-10-22 17:32:10\",\"icon\":\"系统功能\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2043,\"menuName\":\"我的记录\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"func\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:42:46', 11);
INSERT INTO `sys_oper_log` VALUES (452, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-11-09 20:52:53\",\"icon\":\"自助服务\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"个人自助\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"biz_manage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:42:49', 11);
INSERT INTO `sys_oper_log` VALUES (453, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务预约\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"manage:reservation\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:43:27', 11);
INSERT INTO `sys_oper_log` VALUES (454, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/reservation/index\",\"createTime\":\"2026-11-09 20:56:39\",\"icon\":\"自助ATM终端\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2061,\"menuName\":\"业务预约\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2060,\"path\":\"reservation\",\"perms\":\"manage:reservation\",\"routeName\":\"Reservation\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:43:50', 9);
INSERT INTO `sys_oper_log` VALUES (455, '菜单管理', 3, 'com.ClientBank.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2021', '127.0.0.1', '内网IP', '2021 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-11-10 18:44:16', 8);
INSERT INTO `sys_oper_log` VALUES (456, '菜单管理', 2, 'com.ClientBank.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"manage/transferFunc/index\",\"createTime\":\"2026-10-22 17:39:52\",\"icon\":\"转账\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2044,\"menuName\":\"小额转账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2060,\"path\":\"transferFunc\",\"perms\":\"manage:transferFunc:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 18:46:43', 9);
INSERT INTO `sys_oper_log` VALUES (457, '个人信息修改', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/manage/customerExt/profile', '127.0.0.1', '内网IP', '{\"age\":30,\"avatar\":\"http://localhost:8080/profile/upload/2026/11/10/111_20261110192344A001.png\",\"email\":\"new@example.com\",\"idCardNumber\":\"420106199001011234\",\"nickName\":\"新昵称\",\"phonenumber\":\"13800138000\",\"realName\":\"张三\",\"residenceAddress\":\"湖北省武汉市武昌区XX路\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 19:23:44', 41);
INSERT INTO `sys_oper_log` VALUES (458, '个人信息修改', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/manage/customerExt/profile', '127.0.0.1', '内网IP', '{\"age\":30,\"avatar\":\"http://localhost:8080/profile/upload/2026/11/10/111_20261110192344A001.png\",\"email\":\"new@example.com\",\"idCardNumber\":\"420106199001011244\",\"nickName\":\"张三\",\"phonenumber\":\"13800138000\",\"realName\":\"张三\",\"residenceAddress\":\"湖北省武汉市武昌区XX路\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 19:27:44', 13);
INSERT INTO `sys_oper_log` VALUES (459, '个人信息修改', 2, 'com.ClientBank.manage.controller.BankCustomerExtController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/manage/customerExt/profile', '127.0.0.1', '内网IP', '{\"age\":30,\"avatar\":\"http://localhost:8080/profile/upload/2026/11/10/111_20261110192344A001.png\",\"email\":\"new@example.com\",\"idCardNumber\":\"420106199001011244\",\"nickName\":\"高育良\",\"phonenumber\":\"13800138000\",\"realName\":\"高育良\",\"residenceAddress\":\"湖北省武汉市武昌区XX路\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 19:28:29', 11);
INSERT INTO `sys_oper_log` VALUES (460, '用户头像', 2, 'com.ClientBank.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'gaoyuliang', '银行客户部', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/11/10/6c8d4cdb5165453cbeee6ef85a81c9c1.png\",\"code\":200}', 0, NULL, '2026-11-10 20:20:28', 171);
INSERT INTO `sys_oper_log` VALUES (461, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"http://localhost:8080/profile/upload/2026/11/10/111_20261110192344A001.png\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:20:46\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":200,\"deptName\":\"银行客户部\",\"leader\":\"王爱灵\",\"orderNum\":0,\"params\":{\"@type\":\"java.util.HashMap\"},\"parentId\":100,\"status\":\"0\"},\"deptId\":200,\"email\":\"new123@example.com\",\"loginDate\":\"2026-11-10 19:23:24\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"高育良\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"13800138001\",\"remark\":\"本银行系统的第一位注册用户\",\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"permissions\":[\"manage:customerExt:list\",\"manage:TransferRecord:list\",\"manage:TransferRecord:export\",\"manage:loan:query\",\"manage:account:dashboard\",\"manage:loan\",\"manage:transferFunc:add\",\"manage:TransferRecord:remove\",\"manage:customerExt:add\",\"manage:TransferRecord:query\",\"manage:TransferRecord:edit\",\"manage:TransferRecord:add\",\"manage:customerExt:query\",\"manage:loan:update\",\"manage:reservation\",\"manage:customerExt:edit\",\"manage:loan:add\"],\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateTime\":\"2026-11-10 19:23:44\",\"userId\":100,\"userName\":\"gaoyuliang\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:20:32', 24);
INSERT INTO `sys_oper_log` VALUES (462, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:21:44', 264);
INSERT INTO `sys_oper_log` VALUES (463, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'gaoyuliang', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/avatar/2026/11/10/6c8d4cdb5165453cbeee6ef85a81c9c1.png\",\"createBy\":\"admin\",\"createTime\":\"2026-10-21 23:20:46\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":200,\"deptName\":\"银行客户部\",\"leader\":\"王爱灵\",\"orderNum\":0,\"params\":{\"@type\":\"java.util.HashMap\"},\"parentId\":100,\"status\":\"0\"},\"deptId\":200,\"email\":\"new123@example.com\",\"loginDate\":\"2026-11-10 19:23:24\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"高育良\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"13800138001\",\"remark\":\"本银行系统的第一位注册用户\",\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"permissions\":[\"manage:customerExt:list\",\"manage:TransferRecord:list\",\"manage:TransferRecord:export\",\"manage:loan:query\",\"manage:account:dashboard\",\"manage:loan\",\"manage:transferFunc:add\",\"manage:TransferRecord:remove\",\"manage:customerExt:add\",\"manage:TransferRecord:query\",\"manage:TransferRecord:edit\",\"manage:TransferRecord:add\",\"manage:customerExt:query\",\"manage:loan:update\",\"manage:reservation\",\"manage:customerExt:edit\",\"manage:loan:add\"],\"roleId\":100,\"roleKey\":\"customer\",\"roleName\":\"普通用户\",\"roleSort\":0,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateTime\":\"2026-11-10 19:23:44\",\"userId\":100,\"userName\":\"gaoyuliang\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:22:11', 14);
INSERT INTO `sys_oper_log` VALUES (464, '用户管理', 2, 'com.ClientBank.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":100} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:31:50', 80);
INSERT INTO `sys_oper_log` VALUES (465, '用户头像', 2, 'com.ClientBank.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'qitongwei', '银行客户部', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/11/10/43f0572d6b084fd796826a14cc155b3d.png\",\"code\":200}', 0, NULL, '2026-11-10 20:36:28', 19);
INSERT INTO `sys_oper_log` VALUES (466, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:51:06', 27);
INSERT INTO `sys_oper_log` VALUES (467, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', 0, NULL, '2026-11-10 20:51:06', 104);
INSERT INTO `sys_oper_log` VALUES (468, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"sex\":\"0\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:51:10', 9);
INSERT INTO `sys_oper_log` VALUES (469, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', 0, NULL, '2026-11-10 20:51:10', 96);
INSERT INTO `sys_oper_log` VALUES (470, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"sex\":\"0\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:51:15', 21);
INSERT INTO `sys_oper_log` VALUES (471, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:51:16', 288);
INSERT INTO `sys_oper_log` VALUES (472, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"sex\":\"1\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 20:51:20', 18);
INSERT INTO `sys_oper_log` VALUES (473, '用户头像', 2, 'com.ClientBank.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'qitongwei', '银行客户部', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/11/10/da5483d6a0ba4b0d8d1ec8b2bd008712.png\",\"code\":200}', 0, NULL, '2026-11-10 21:04:36', 29);
INSERT INTO `sys_oper_log` VALUES (474, '用户头像', 2, 'com.ClientBank.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'qitongwei', '银行客户部', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/11/10/49dbbf4effe94b07ab18fdf21e5bb155.png\",\"code\":200}', 0, NULL, '2026-11-10 21:04:41', 9);
INSERT INTO `sys_oper_log` VALUES (475, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 21:09:38', 43);
INSERT INTO `sys_oper_log` VALUES (476, '个人信息', 2, 'com.ClientBank.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'qitongwei', '银行客户部', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"26877777778@qq.com\",\"nickName\":\"祁同伟\",\"params\":{},\"phonenumber\":\"18333332223\",\"remark\":\"汉东书籍\",\"userId\":101,\"userName\":\"qitongwei\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-11-10 21:15:49', 31);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-10-21 22:32:12', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'teller', '柜员', 4, '0', 'admin', '2026-10-21 22:32:12', 'admin', '2026-10-21 23:18:40', '办理开户、实名、存取款');
INSERT INTO `sys_post` VALUES (5, 'customer', '银行系统的普通用户', 5, '0', 'admin', '2026-10-21 23:18:07', 'admin', '2026-10-21 23:18:50', '银行系统的普通用户');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-10-21 22:32:12', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '普通用户', 'customer', 0, '1', 1, 1, '0', '0', 'admin', '2026-10-21 23:13:37', 'admin', '2026-11-09 21:21:30', '银行的普通用户角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2019);
INSERT INTO `sys_role_menu` VALUES (100, 2020);
INSERT INTO `sys_role_menu` VALUES (100, 2021);
INSERT INTO `sys_role_menu` VALUES (100, 2022);
INSERT INTO `sys_role_menu` VALUES (100, 2037);
INSERT INTO `sys_role_menu` VALUES (100, 2038);
INSERT INTO `sys_role_menu` VALUES (100, 2039);
INSERT INTO `sys_role_menu` VALUES (100, 2040);
INSERT INTO `sys_role_menu` VALUES (100, 2041);
INSERT INTO `sys_role_menu` VALUES (100, 2042);
INSERT INTO `sys_role_menu` VALUES (100, 2043);
INSERT INTO `sys_role_menu` VALUES (100, 2044);
INSERT INTO `sys_role_menu` VALUES (100, 2049);
INSERT INTO `sys_role_menu` VALUES (100, 2050);
INSERT INTO `sys_role_menu` VALUES (100, 2051);
INSERT INTO `sys_role_menu` VALUES (100, 2052);
INSERT INTO `sys_role_menu` VALUES (100, 2053);
INSERT INTO `sys_role_menu` VALUES (100, 2060);
INSERT INTO `sys_role_menu` VALUES (100, 2061);
INSERT INTO `sys_role_menu` VALUES (100, 2062);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-11-10 20:35:27', '2026-10-21 22:32:12', 'admin', '2026-10-21 22:32:12', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-10-22 14:16:28', '2026-10-21 22:32:12', 'admin', '2026-10-21 22:32:12', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, 200, 'gaoyuliang', '高育良', '00', 'new123@example.com', '13800138001', '0', '/profile/avatar/2026/11/10/6c8d4cdb5165453cbeee6ef85a81c9c1.png', '$2a$10$zLjAUodMBhHkC.kY7H2a/e91/k7Jnocos62Kpk42gBYHb13MRiOru', '0', '0', '127.0.0.1', '2026-11-10 19:23:24', '2026-11-10 20:31:50', 'admin', '2026-10-21 23:20:46', '', '2026-11-10 20:31:50', '本银行系统的第一位注册用户');
INSERT INTO `sys_user` VALUES (101, 200, 'qitongwei', '祁同伟', '00', '26877777778@qq.com', '18333332223', '1', '/profile/avatar/2026/11/10/49dbbf4effe94b07ab18fdf21e5bb155.png', '$2a$10$xtGua0YzyCMoHdD62Uzwu.fjxu/FHKb68/0i8UNO5rOuNchEVeOJW', '0', '0', '127.0.0.1', '2026-11-10 20:35:33', '2026-11-10 20:51:16', 'admin', '2026-10-22 15:57:56', '', '2026-11-10 21:15:49', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (100, 5);
INSERT INTO `sys_user_post` VALUES (101, 5);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 100);
INSERT INTO `sys_user_role` VALUES (101, 100);

-- ----------------------------
-- Table structure for transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `transfer_record`;
CREATE TABLE `transfer_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `transfer_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '转账业务单号',
  `from_account_id` bigint NOT NULL COMMENT '转出账户ID',
  `to_account_id` bigint NOT NULL COMMENT '转入账户ID',
  `from_user_id` bigint NOT NULL COMMENT '转出用户ID',
  `to_user_id` bigint NOT NULL COMMENT '转入用户ID',
  `amount` decimal(20, 2) NOT NULL COMMENT '转账金额',
  `fee` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '手续费',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0待处理 1成功 2失败 3已取消',
  `fail_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '失败原因',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `free_time` datetime NULL DEFAULT NULL COMMENT '账户转账解冻时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '转账时的留言',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `transfer_no`(`transfer_no` ASC) USING BTREE,
  INDEX `idx_from_user`(`from_user_id` ASC) USING BTREE,
  INDEX `idx_to_user`(`to_user_id` ASC) USING BTREE,
  INDEX `idx_transfer_no`(`transfer_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户转账记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of transfer_record
-- ----------------------------
INSERT INTO `transfer_record` VALUES (17, 'TR9552544546', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:05:09', '2026-10-29 13:30:00', '2026-10-27 23:05:09', '测试转账');
INSERT INTO `transfer_record` VALUES (18, 'TR1799106757', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:11:22', '2026-10-26 23:43:32', '2026-10-26 23:11:21', '测试转账');
INSERT INTO `transfer_record` VALUES (19, 'TR2018216554', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:19:44', '2026-10-26 23:43:32', '2026-10-26 23:19:43', '测试转账');
INSERT INTO `transfer_record` VALUES (20, 'TR8740851447', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:25:09', '2026-10-26 23:43:32', '2026-10-26 23:00:09', '测试转账');
INSERT INTO `transfer_record` VALUES (21, 'TR9538034800', 622202199801250005, 622202196001011234, 101, 100, 150.00, 0.15, 1, NULL, '2026-10-26 23:26:32', '2026-10-26 23:26:32', NULL, '测试转账');
INSERT INTO `transfer_record` VALUES (22, 'TR4077128281', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:44:06', '2026-10-26 23:44:51', '2026-10-26 23:00:05', '测试转账');
INSERT INTO `transfer_record` VALUES (23, 'TR5359360194', 622202199801250005, 622202196001011234, 101, 100, 15000.00, 15.00, 1, NULL, '2026-10-26 23:45:21', '2026-10-26 23:45:43', '2026-10-26 23:15:20', '测试转账');
INSERT INTO `transfer_record` VALUES (24, 'TR2438845793', 622202196001011234, 622202199801250005, 100, 101, 1000.00, 1.00, 1, NULL, '2026-10-27 13:39:46', '2026-10-27 13:39:46', NULL, '32143423');
INSERT INTO `transfer_record` VALUES (25, 'TR1058154026', 622202196001011234, 622202199801250005, 100, 101, 100.00, 0.10, 1, NULL, '2026-10-27 13:41:35', '2026-10-27 13:41:35', NULL, '1213214');
INSERT INTO `transfer_record` VALUES (26, 'TR6389900328', 622202196001011234, 622202199801250005, 100, 101, 1000.00, 1.00, 1, NULL, '2026-10-27 13:42:47', '2026-10-27 13:42:47', NULL, '13123');
INSERT INTO `transfer_record` VALUES (27, 'TR9297020861', 622202196001011234, 622202199801250005, 100, 101, 1000.00, 1.00, 1, NULL, '2026-10-27 13:47:17', '2026-10-27 13:47:17', NULL, '6346345');
INSERT INTO `transfer_record` VALUES (28, 'TR9756873266', 622202197508230001, 622202199801250005, 100, 101, 1.00, 0.00, 1, NULL, '2026-11-03 13:05:27', '2026-11-03 13:05:27', NULL, '测试转账');
INSERT INTO `transfer_record` VALUES (29, 'TR0443267185', 622202197508230001, 622202198205120002, 100, 100, 100.00, 0.10, 1, NULL, '2026-11-03 13:05:57', '2026-11-03 13:05:57', NULL, '贪污款');

SET FOREIGN_KEY_CHECKS = 1;
