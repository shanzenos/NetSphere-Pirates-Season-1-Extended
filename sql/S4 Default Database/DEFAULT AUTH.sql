-- Valentina Studio --
-- MySQL dump --
-- ---------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- ---------------------------------------------------------


-- CREATE TABLE "accounts" ---------------------------------
CREATE TABLE `accounts` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`Username` VarChar( 40 ) COLLATE utf8_general_ci NOT NULL,
	`Nickname` VarChar( 40 ) COLLATE utf8_general_ci NULL,
	`Password` VarChar( 40 ) COLLATE utf8_general_ci NULL,
	`Salt` VarChar( 40 ) COLLATE utf8_general_ci NULL,
	`SecurityLevel` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ),
	CONSTRAINT `Nickname` UNIQUE( `Nickname` ),
	CONSTRAINT `Username` UNIQUE( `Username` ) )
COLLATE = utf8_bin
ENGINE = InnoDB
AUTO_INCREMENT = 5830;
-- ---------------------------------------------------------


-- CREATE TABLE "bans" -------------------------------------
CREATE TABLE `bans` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`AccountId` Int( 11 ) NOT NULL,
	`Date` BigInt( 20 ) NOT NULL DEFAULT '0',
	`Duration` BigInt( 20 ) NULL,
	`Reason` VarChar( 255 ) COLLATE utf8_general_ci NULL,
	PRIMARY KEY ( `Id` ) )
COLLATE = utf8_bin
ENGINE = InnoDB
AUTO_INCREMENT = 1;
-- ---------------------------------------------------------


-- CREATE TABLE "login_history" ----------------------------
CREATE TABLE `login_history` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`AccountId` Int( 11 ) NOT NULL,
	`Date` BigInt( 20 ) NOT NULL DEFAULT '0',
	`IP` VarChar( 15 ) NULL,
	PRIMARY KEY ( `Id` ) )
COLLATE = utf8_bin
ENGINE = InnoDB
AUTO_INCREMENT = 39914;
-- ---------------------------------------------------------


-- CREATE TABLE "nickname_history" -------------------------
CREATE TABLE `nickname_history` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`AccountId` Int( 11 ) NOT NULL,
	`Nickname` VarChar( 40 ) COLLATE utf8_general_ci NOT NULL,
	`ExpireDate` BigInt( 20 ) NULL,
	PRIMARY KEY ( `Id` ) )
COLLATE = utf8_bin
ENGINE = InnoDB
AUTO_INCREMENT = 1;
-- ---------------------------------------------------------


-- Dump data of "accounts" ---------------------------------
-- ---------------------------------------------------------


-- Dump data of "bans" -------------------------------------
-- ---------------------------------------------------------


-- Dump data of "login_history" ----------------------------
-- ---------------------------------------------------------


-- Dump data of "nickname_history" -------------------------
-- ---------------------------------------------------------


-- CREATE INDEX "AccountId" --------------------------------
CREATE INDEX `AccountId` USING BTREE ON `bans`( `AccountId` );
-- ---------------------------------------------------------


-- CREATE INDEX "AccountId" --------------------------------
CREATE INDEX `AccountId` USING BTREE ON `login_history`( `AccountId` );
-- ---------------------------------------------------------


-- CREATE INDEX "AccountId" --------------------------------
CREATE INDEX `AccountId` USING BTREE ON `nickname_history`( `AccountId` );
-- ---------------------------------------------------------


-- CREATE LINK "bans_ibfk_1" -------------------------------
ALTER TABLE `bans`
	ADD CONSTRAINT `bans_ibfk_1` FOREIGN KEY ( `AccountId` )
	REFERENCES `accounts`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "login_history_ibfk_1" ----------------------
ALTER TABLE `login_history`
	ADD CONSTRAINT `login_history_ibfk_1` FOREIGN KEY ( `AccountId` )
	REFERENCES `accounts`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "nickname_history_ibfk_1" -------------------
ALTER TABLE `nickname_history`
	ADD CONSTRAINT `nickname_history_ibfk_1` FOREIGN KEY ( `AccountId` )
	REFERENCES `accounts`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- ---------------------------------------------------------


