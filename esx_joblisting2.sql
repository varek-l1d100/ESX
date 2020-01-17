-- !! Backup & check your database before using !!

----------------------
-- Version NO TABLE --
----------------------
USE `essentialmode`;

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

------------------------------------------
-- Alternativ WITH TABLE WITHOUT COLUMN --
------------------------------------------

ALTER TABLE jobs ADD whitelisted tinyint(1) NOT NULL DEFAULT '0',
