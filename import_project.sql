CREATE DATABASE IF NOT EXISTS `enger` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `enger`;

DROP TABLE IF EXISTS `t_enger1`;
CREATE TABLE `t_enger1` (
  `record_time` VARCHAR(10),
  `avg_pack_voltage` DOUBLE,
  `avg_charge_current` DOUBLE
);

DROP TABLE IF EXISTS `t_enger2`;
CREATE TABLE `t_enger2` (
  `mmcv` VARCHAR(20),
  `max_pack_voltage` DOUBLE,
  `min_pack_voltage` DOUBLE
);

DROP TABLE IF EXISTS `t_enger3`;
CREATE TABLE `t_enger3` (
  `recordTime` VARCHAR(10),
  `maxTemperature` DOUBLE,
  `minTemperature` DOUBLE
);

DROP TABLE IF EXISTS `t_enger4`;
CREATE TABLE `t_enger4` (
  `recordTime` VARCHAR(10),
  `energy` DOUBLE,
  `capacity` DOUBLE
);

DROP TABLE IF EXISTS `t_enger5`;
CREATE TABLE `t_enger5` (
  `recordTime` VARCHAR(10),
  `avgchargeCurrent` DOUBLE,
  `maxchargeCurrent` DOUBLE
);

DROP TABLE IF EXISTS `t_enger6`;
CREATE TABLE `t_enger6` (
  `recordTime` VARCHAR(10),
  `packVoltage` DOUBLE,
  `chargeCurrent` DOUBLE
);

DROP TABLE IF EXISTS `t_enger7`;
CREATE TABLE `t_enger7` (
  `batteryStatus` VARCHAR(30),
  `avgMaxTemperature` DOUBLE,
  `avgMinTemperature` DOUBLE
);

DROP TABLE IF EXISTS `t_session_summary`;
CREATE TABLE `t_session_summary` (
  `source_file` VARCHAR(50),
  `raw_source_file` VARCHAR(50),
  `session_count` INT,
  `total_kwh` DOUBLE,
  `total_fees` DOUBLE,
  `avg_charge_hours` DOUBLE,
  `station_count` INT,
  `user_count` INT,
  `raw_min_year` INT,
  `fixed_min_year` INT
);

DROP TABLE IF EXISTS `t_weekday_sessions`;
CREATE TABLE `t_weekday_sessions` (
  `weekday` VARCHAR(10),
  `session_count` INT
);

DROP TABLE IF EXISTS `t_platform_sessions`;
CREATE TABLE `t_platform_sessions` (
  `platform` VARCHAR(20),
  `session_count` INT
);

INSERT INTO `t_enger1` (`record_time`, `avg_pack_voltage`, `avg_charge_current`) VALUES ('00', 327.8875, -73.725012);
INSERT INTO `t_enger1` (`record_time`, `avg_pack_voltage`, `avg_charge_current`) VALUES ('11', 326.72776, -22.5);
INSERT INTO `t_enger1` (`record_time`, `avg_pack_voltage`, `avg_charge_current`) VALUES ('12', 330.948667, -22.5);
INSERT INTO `t_enger1` (`record_time`, `avg_pack_voltage`, `avg_charge_current`) VALUES ('13', 340.078, -22.5);
INSERT INTO `t_enger1` (`record_time`, `avg_pack_voltage`, `avg_charge_current`) VALUES ('14', 352.792954, -22.5);

INSERT INTO `t_enger2` (`mmcv`, `max_pack_voltage`, `min_pack_voltage`) VALUES ('00', 3.67, 3.62);
INSERT INTO `t_enger2` (`mmcv`, `max_pack_voltage`, `min_pack_voltage`) VALUES ('11', 3.658, 3.584);
INSERT INTO `t_enger2` (`mmcv`, `max_pack_voltage`, `min_pack_voltage`) VALUES ('12', 3.718, 3.646);
INSERT INTO `t_enger2` (`mmcv`, `max_pack_voltage`, `min_pack_voltage`) VALUES ('13', 3.862, 3.7);
INSERT INTO `t_enger2` (`mmcv`, `max_pack_voltage`, `min_pack_voltage`) VALUES ('14', 3.993, 3.834);

INSERT INTO `t_enger3` (`recordTime`, `maxTemperature`, `minTemperature`) VALUES ('00', 36.0, 34.0);
INSERT INTO `t_enger3` (`recordTime`, `maxTemperature`, `minTemperature`) VALUES ('11', 33.0, 31.0);
INSERT INTO `t_enger3` (`recordTime`, `maxTemperature`, `minTemperature`) VALUES ('12', 36.0, 32.0);
INSERT INTO `t_enger3` (`recordTime`, `maxTemperature`, `minTemperature`) VALUES ('13', 37.0, 34.0);
INSERT INTO `t_enger3` (`recordTime`, `maxTemperature`, `minTemperature`) VALUES ('14', 37.0, 35.0);

INSERT INTO `t_enger4` (`recordTime`, `energy`, `capacity`) VALUES ('00', 9.15875, 27.5375);
INSERT INTO `t_enger4` (`recordTime`, `energy`, `capacity`) VALUES ('11', 9.654511, 29.031893);
INSERT INTO `t_enger4` (`recordTime`, `energy`, `capacity`) VALUES ('12', 16.239067, 48.825533);
INSERT INTO `t_enger4` (`recordTime`, `energy`, `capacity`) VALUES ('13', 24.064178, 72.347088);
INSERT INTO `t_enger4` (`recordTime`, `energy`, `capacity`) VALUES ('14', 31.070976, 93.410568);

INSERT INTO `t_enger5` (`recordTime`, `avgchargeCurrent`, `maxchargeCurrent`) VALUES ('00', -73.725012, -73.70001);
INSERT INTO `t_enger5` (`recordTime`, `avgchargeCurrent`, `maxchargeCurrent`) VALUES ('11', -22.5, -22.5);
INSERT INTO `t_enger5` (`recordTime`, `avgchargeCurrent`, `maxchargeCurrent`) VALUES ('12', -22.5, -22.5);
INSERT INTO `t_enger5` (`recordTime`, `avgchargeCurrent`, `maxchargeCurrent`) VALUES ('13', -22.5, -22.5);
INSERT INTO `t_enger5` (`recordTime`, `avgchargeCurrent`, `maxchargeCurrent`) VALUES ('14', -22.5, -22.5);

INSERT INTO `t_enger6` (`recordTime`, `packVoltage`, `chargeCurrent`) VALUES ('00', 327.8875, -73.725012);
INSERT INTO `t_enger6` (`recordTime`, `packVoltage`, `chargeCurrent`) VALUES ('11', 326.72776, -22.5);
INSERT INTO `t_enger6` (`recordTime`, `packVoltage`, `chargeCurrent`) VALUES ('12', 330.948667, -22.5);
INSERT INTO `t_enger6` (`recordTime`, `packVoltage`, `chargeCurrent`) VALUES ('13', 340.078, -22.5);
INSERT INTO `t_enger6` (`recordTime`, `packVoltage`, `chargeCurrent`) VALUES ('14', 352.792954, -22.5);

INSERT INTO `t_enger7` (`batteryStatus`, `avgMaxTemperature`, `avgMinTemperature`) VALUES ('00', 36.0, 34.375);
INSERT INTO `t_enger7` (`batteryStatus`, `avgMaxTemperature`, `avgMinTemperature`) VALUES ('11', 32.955836, 31.214511);
INSERT INTO `t_enger7` (`batteryStatus`, `avgMaxTemperature`, `avgMinTemperature`) VALUES ('12', 34.535556, 32.637778);
INSERT INTO `t_enger7` (`batteryStatus`, `avgMaxTemperature`, `avgMinTemperature`) VALUES ('13', 36.497778, 34.297778);
INSERT INTO `t_enger7` (`batteryStatus`, `avgMaxTemperature`, `avgMinTemperature`) VALUES ('14', 37.0, 35.0);

INSERT INTO `t_session_summary` (`source_file`, `raw_source_file`, `session_count`, `total_kwh`, `total_fees`, `avg_charge_hours`, `station_count`, `user_count`, `raw_min_year`, `fixed_min_year`) VALUES ('nvv2t_md.csv', 'nvv2t.csv', 3395.0, 19723.69, 401.52, 2.841, 105.0, 85.0, 14.0, 2014.0);

INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Mon', 616.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Tues', 0.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Wed', 713.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Thurs', 0.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Fri', 610.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Sat', 62.0);
INSERT INTO `t_weekday_sessions` (`weekday`, `session_count`) VALUES ('Sun', 24.0);

INSERT INTO `t_platform_sessions` (`platform`, `session_count`) VALUES ('ios', 2234.0);
INSERT INTO `t_platform_sessions` (`platform`, `session_count`) VALUES ('android', 1155.0);
INSERT INTO `t_platform_sessions` (`platform`, `session_count`) VALUES ('web', 6.0);
