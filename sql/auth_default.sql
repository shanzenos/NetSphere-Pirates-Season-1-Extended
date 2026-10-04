-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.23 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             12.21.0.7344
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table s4_dump_auth.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(40) CHARACTER SET utf8 NOT NULL,
  `Nickname` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `Password` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `Salt` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `SecurityLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `Nickname` (`Nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=5970 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table s4_dump_auth.accounts: ~186 rows (approximately)

-- Dumping structure for table s4_dump_auth.bans
DROP TABLE IF EXISTS `bans`;
CREATE TABLE IF NOT EXISTS `bans` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `Date` bigint(20) NOT NULL DEFAULT '0',
  `Duration` bigint(20) DEFAULT NULL,
  `Reason` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `AccountId` (`AccountId`) USING BTREE,
  CONSTRAINT `bans_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `accounts` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table s4_dump_auth.bans: ~0 rows (approximately)

-- Dumping structure for table s4_dump_auth.login_history
DROP TABLE IF EXISTS `login_history`;
CREATE TABLE IF NOT EXISTS `login_history` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `Date` bigint(20) NOT NULL DEFAULT '0',
  `IP` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `AccountId` (`AccountId`) USING BTREE,
  CONSTRAINT `login_history_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `accounts` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43167 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table s4_dump_auth.login_history: ~5,110 rows (approximately)

-- Dumping structure for table s4_dump_auth.nickname_history
DROP TABLE IF EXISTS `nickname_history`;
CREATE TABLE IF NOT EXISTS `nickname_history` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `Nickname` varchar(40) CHARACTER SET utf8 NOT NULL,
  `ExpireDate` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `AccountId` (`AccountId`) USING BTREE,
  CONSTRAINT `nickname_history_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `accounts` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table s4_dump_auth.nickname_history: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
