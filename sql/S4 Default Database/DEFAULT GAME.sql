-- Valentina Studio --
-- MySQL dump --
-- ---------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- ---------------------------------------------------------


-- CREATE TABLE "license_rewards" --------------------------
CREATE TABLE `license_rewards` ( 
	`Id` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`ShopItemInfoId` Int( 11 ) NOT NULL,
	`ShopPriceId` Int( 11 ) NOT NULL,
	`Color` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "player_characters" ------------------------
CREATE TABLE `player_characters` ( 
	`Id` Int( 11 ) NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`Slot` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Gender` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`BasicHair` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`BasicFace` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`BasicShirt` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`BasicPants` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Weapon1Id` Int( 11 ) NULL,
	`Weapon2Id` Int( 11 ) NULL,
	`Weapon3Id` Int( 11 ) NULL,
	`SkillId` Int( 11 ) NULL,
	`HairId` Int( 11 ) NULL,
	`FaceId` Int( 11 ) NULL,
	`ShirtId` Int( 11 ) NULL,
	`PantsId` Int( 11 ) NULL,
	`GlovesId` Int( 11 ) NULL,
	`ShoesId` Int( 11 ) NULL,
	`AccessoryId` Int( 11 ) NULL,
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "player_deny" ------------------------------
CREATE TABLE `player_deny` ( 
	`Id` Int( 11 ) NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`DenyPlayerId` Int( 11 ) NOT NULL,
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "player_items" -----------------------------
CREATE TABLE `player_items` ( 
	`Id` Int( 11 ) NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`ShopItemInfoId` Int( 11 ) NOT NULL,
	`ShopPriceId` Int( 11 ) NOT NULL,
	`Effect` Int( 11 ) NOT NULL DEFAULT '0',
	`Color` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`PurchaseDate` BigInt( 20 ) NOT NULL DEFAULT '0',
	`Durability` Int( 11 ) NOT NULL DEFAULT '0',
	`Count` Int( 11 ) NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "player_licenses" --------------------------
CREATE TABLE `player_licenses` ( 
	`Id` Int( 11 ) NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`License` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`FirstCompletedDate` BigInt( 20 ) NOT NULL DEFAULT '0',
	`CompletedCount` Int( 11 ) NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "player_mails" -----------------------------
CREATE TABLE `player_mails` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`SenderPlayerId` Int( 11 ) NOT NULL,
	`SentDate` BigInt( 20 ) NOT NULL DEFAULT '0',
	`Title` VarChar( 100 ) NOT NULL,
	`Message` VarChar( 500 ) NOT NULL,
	`IsMailNew` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`IsMailDeleted` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 10;
-- ---------------------------------------------------------


-- CREATE TABLE "player_settings" --------------------------
CREATE TABLE `player_settings` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`PlayerId` Int( 11 ) NOT NULL,
	`Setting` VarChar( 512 ) NOT NULL,
	`Value` VarChar( 512 ) NOT NULL,
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 18045;
-- ---------------------------------------------------------


-- CREATE TABLE "players" ----------------------------------
CREATE TABLE `players` ( 
	`Id` Int( 11 ) NOT NULL,
	`TutorialState` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Level` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`TotalExperience` Int( 11 ) NOT NULL DEFAULT '63703100',
	`PEN` Int( 11 ) NOT NULL DEFAULT '0',
	`AP` Int( 11 ) NOT NULL DEFAULT '0',
	`Coins1` Int( 11 ) NOT NULL DEFAULT '0',
	`Coins2` Int( 11 ) NOT NULL DEFAULT '0',
	`CurrentCharacterSlot` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
COLLATE = utf8_bin
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_effect_groups" -----------------------
CREATE TABLE `shop_effect_groups` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`Name` VarChar( 20 ) NOT NULL,
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 27;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_effects" -----------------------------
CREATE TABLE `shop_effects` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`EffectGroupId` Int( 11 ) NOT NULL,
	`Effect` BigInt( 20 ) NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 26;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_iteminfos" ---------------------------
CREATE TABLE `shop_iteminfos` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`ShopItemId` Int( 11 ) UNSIGNED NOT NULL,
	`PriceGroupId` Int( 11 ) NOT NULL,
	`EffectGroupId` Int( 11 ) NOT NULL,
	`DiscountPercentage` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`IsEnabled` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 770;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_items" -------------------------------
CREATE TABLE `shop_items` ( 
	`Id` Int( 10 ) UNSIGNED NOT NULL,
	`RequiredGender` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`RequiredLicense` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Colors` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`UniqueColors` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`RequiredLevel` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`LevelLimit` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`RequiredMasterLevel` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`IsOneTimeUse` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`IsDestroyable` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_price_groups" ------------------------
CREATE TABLE `shop_price_groups` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`Name` VarChar( 20 ) NULL,
	`PriceType` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 3;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_prices" ------------------------------
CREATE TABLE `shop_prices` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`PriceGroupId` Int( 11 ) NOT NULL,
	`PeriodType` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Period` Int( 11 ) NOT NULL DEFAULT '0',
	`Price` Int( 11 ) NOT NULL DEFAULT '0',
	`IsRefundable` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Durability` Int( 11 ) NOT NULL DEFAULT '0',
	`IsEnabled` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 3;
-- ---------------------------------------------------------


-- CREATE TABLE "shop_version" -----------------------------
CREATE TABLE `shop_version` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`Version` VarChar( 40 ) NOT NULL,
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 2;
-- ---------------------------------------------------------


-- CREATE TABLE "start_items" ------------------------------
CREATE TABLE `start_items` ( 
	`Id` Int( 11 ) AUTO_INCREMENT NOT NULL,
	`ShopItemInfoId` Int( 11 ) NOT NULL,
	`ShopPriceId` Int( 11 ) NOT NULL,
	`ShopEffectId` Int( 11 ) NOT NULL,
	`Color` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	`Count` Int( 11 ) NOT NULL DEFAULT '0',
	`RequiredSecurityLevel` TinyInt( 3 ) UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY ( `Id` ) )
ENGINE = InnoDB
AUTO_INCREMENT = 1;
-- ---------------------------------------------------------


-- Dump data of "license_rewards" --------------------------
-- ---------------------------------------------------------


-- Dump data of "player_characters" ------------------------
-- ---------------------------------------------------------


-- Dump data of "player_deny" ------------------------------
-- ---------------------------------------------------------


-- Dump data of "player_items" -----------------------------
-- ---------------------------------------------------------


-- Dump data of "player_licenses" --------------------------
-- ---------------------------------------------------------


-- Dump data of "player_mails" -----------------------------
-- ---------------------------------------------------------


-- Dump data of "player_settings" --------------------------
-- ---------------------------------------------------------


-- Dump data of "players" ----------------------------------
-- ---------------------------------------------------------


-- Dump data of "shop_effect_groups" -----------------------
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '1', 'None' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '2', 'HP+30' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '3', 'HP+15' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '4', 'SP+40' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '5', 'HP+20 & SP+20' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '6', 'SP+3' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '7', 'Defense+7' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '8', 'hp+3' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '9', 'Attack+7' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '10', 'Head Defense+7' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '11', 'Head Defense+3' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '12', 'Defense+4' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '13', 'Attack+3' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '14', 'Attack+6' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '15', 'Melee Defense+2' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '16', 'Melee Defense+4' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '17', 'Melee Defense+5' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '18', 'Melee Defense+6' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '19', 'Melee Defense+7' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '20', 'Shooting Defense+2' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '21', 'Shooting Defense+4' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '22', 'Shooting Defense+5' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '23', 'Shooting Defense+6' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '24', 'Shooting Defense+7' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '25', 'Defense+8' );
INSERT INTO `shop_effect_groups`(`Id`,`Name`) VALUES ( '26', 'Defense+9' );
-- ---------------------------------------------------------


-- Dump data of "shop_effects" -----------------------------
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '1', '2', '1030' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '2', '3', '1015' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '3', '4', '2040' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '4', '5', '4001' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '5', '6', '2003' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '6', '7', '19907' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '7', '8', '1003' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '8', '9', '29907' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '9', '10', '19807' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '10', '11', '19803' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '11', '12', '19904' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '12', '13', '29903' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '13', '14', '29906' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '14', '15', '10002' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '15', '16', '10004' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '16', '17', '10005' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '17', '18', '10006' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '18', '19', '10007' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '19', '20', '11002' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '20', '21', '11004' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '21', '22', '11005' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '22', '23', '11006' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '23', '24', '11007' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '24', '25', '19908' );
INSERT INTO `shop_effects`(`Id`,`EffectGroupId`,`Effect`) VALUES ( '25', '26', '19909' );
-- ---------------------------------------------------------


-- Dump data of "shop_iteminfos" ---------------------------
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '1', '1001002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '2', '1001001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '3', '1000035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '4', '1000034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '5', '1000033', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '6', '1000032', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '7', '1000031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '8', '1000030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '9', '1000028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '10', '1000027', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '11', '1000026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '12', '1000025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '13', '1000024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '14', '1000023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '15', '1000022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '16', '1000021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '17', '1000020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '18', '1000019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '19', '1000018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '20', '1000017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '21', '1000016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '22', '1000015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '23', '1000014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '24', '1000013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '25', '1000012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '26', '1000011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '27', '1000010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '28', '1000009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '29', '1000008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '30', '1000007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '31', '1000006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '32', '1000005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '33', '1000004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '34', '1000003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '35', '1000002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '36', '1000001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '37', '1000000', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '38', '1011002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '39', '1011001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '40', '1010035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '41', '1010034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '42', '1010033', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '43', '1010032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '44', '1010031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '45', '1010028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '46', '1010026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '47', '1010025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '48', '1010024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '49', '1010023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '50', '1010022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '51', '1010020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '52', '1010019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '53', '1010018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '54', '1010017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '55', '1010016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '56', '1010015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '57', '1010014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '58', '1010013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '59', '1010012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '60', '1010011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '61', '1010010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '62', '1010009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '63', '1010008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '64', '1010007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '65', '1010006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '66', '1010005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '67', '1010004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '68', '1010003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '69', '1010002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '70', '1010001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '71', '1021018', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '72', '1021017', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '73', '1021016', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '74', '1021015', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '75', '1021011', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '76', '1021010', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '77', '1021009', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '78', '1021008', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '79', '1021007', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '80', '1021006', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '81', '1021005', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '82', '1021004', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '83', '1021003', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '84', '1021002', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '85', '1021001', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '86', '1020077', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '87', '1020076', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '88', '1020075', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '89', '1020074', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '90', '1020073', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '91', '1020072', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '92', '1020071', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '93', '1020070', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '94', '1020069', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '95', '1020068', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '96', '1020067', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '97', '1020066', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '98', '1020065', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '99', '1020064', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '100', '1020063', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '101', '1020062', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '102', '1020061', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '103', '1020059', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '104', '1020058', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '105', '1020056', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '106', '1020055', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '107', '1020054', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '108', '1020053', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '109', '1020052', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '110', '1020051', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '111', '1020050', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '112', '1020049', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '113', '1020048', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '114', '1020047', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '115', '1020046', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '116', '1020045', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '117', '1020044', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '118', '1020043', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '119', '1020042', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '120', '1020041', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '121', '1020040', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '122', '1020039', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '123', '1020038', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '124', '1020037', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '125', '1020036', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '126', '1020035', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '127', '1020034', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '128', '1020033', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '129', '1020032', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '130', '1020031', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '131', '1020030', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '132', '1020029', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '133', '1020028', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '134', '1020027', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '135', '1020026', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '136', '1020025', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '137', '1020024', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '138', '1020022', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '139', '1020021', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '140', '1020020', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '141', '1020019', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '142', '1020018', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '143', '1020017', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '144', '1020016', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '145', '1020015', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '146', '1020014', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '147', '1020013', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '148', '1020012', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '149', '1020011', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '150', '1020010', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '151', '1020009', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '152', '1020008', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '153', '1020007', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '154', '1020006', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '155', '1020005', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '156', '1020004', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '157', '1020003', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '158', '1020002', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '159', '1020001', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '160', '1020000', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '161', '1031018', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '162', '1031017', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '163', '1031016', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '164', '1031015', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '165', '1031011', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '166', '1031010', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '167', '1031009', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '168', '1031008', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '169', '1031007', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '170', '1031006', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '171', '1031005', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '172', '1031004', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '173', '1031003', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '174', '1031002', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '175', '1031001', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '176', '1030074', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '177', '1030073', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '178', '1030072', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '179', '1030071', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '180', '1030070', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '181', '1030069', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '182', '1030068', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '183', '1030067', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '184', '1030066', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '185', '1030065', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '186', '1030064', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '187', '1030063', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '188', '1030062', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '189', '1030061', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '190', '1030060', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '191', '1030059', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '192', '1030057', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '193', '1030056', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '194', '1030054', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '195', '1030053', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '196', '1030052', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '197', '1030051', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '198', '1030050', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '199', '1030049', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '200', '1030048', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '201', '1030047', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '202', '1030046', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '203', '1030045', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '204', '1030044', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '205', '1030043', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '206', '1030042', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '207', '1030041', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '208', '1030040', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '209', '1030039', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '210', '1030038', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '211', '1030037', '2', '7', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '212', '1030036', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '213', '1030035', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '214', '1030034', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '215', '1030033', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '216', '1030032', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '217', '1030031', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '218', '1030030', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '219', '1030029', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '220', '1030028', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '221', '1030027', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '222', '1030026', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '223', '1030025', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '224', '1030024', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '225', '1030023', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '226', '1030022', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '227', '1030021', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '228', '1030020', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '229', '1030019', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '230', '1030018', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '231', '1030017', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '232', '1030016', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '233', '1030015', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '234', '1030014', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '235', '1030013', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '236', '1030012', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '237', '1030011', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '238', '1030010', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '239', '1030009', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '240', '1030008', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '241', '1030007', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '242', '1030006', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '243', '1030005', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '244', '1030004', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '245', '1030003', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '246', '1030002', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '247', '1030001', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '248', '1030000', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '249', '1041018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '250', '1041017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '251', '1041016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '252', '1041015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '253', '1041011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '254', '1041010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '255', '1041009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '256', '1041008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '257', '1041007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '258', '1041006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '259', '1041003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '260', '1041002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '261', '1041001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '262', '1040066', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '263', '1040065', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '264', '1040064', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '265', '1040063', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '266', '1040062', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '267', '1040061', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '268', '1040060', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '269', '1040059', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '270', '1040058', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '271', '1040057', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '272', '1040056', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '273', '1040055', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '274', '1040053', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '275', '1040052', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '276', '1040050', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '277', '1040049', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '278', '1040048', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '279', '1040047', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '280', '1040046', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '281', '1040045', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '282', '1040044', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '283', '1040043', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '284', '1040042', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '285', '1040041', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '286', '1040040', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '287', '1040039', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '288', '1040038', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '289', '1040037', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '290', '1040036', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '291', '1040035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '292', '1040034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '293', '1040033', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '294', '1040032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '295', '1040031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '296', '1040030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '297', '1040029', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '298', '1040028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '299', '1040027', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '300', '1040026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '301', '1040025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '302', '1040024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '303', '1040023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '304', '1040022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '305', '1040021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '306', '1040020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '307', '1040019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '308', '1040018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '309', '1040017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '310', '1040016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '311', '1040015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '312', '1040014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '313', '1040013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '314', '1040012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '315', '1040011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '316', '1040010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '317', '1040009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '318', '1040008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '319', '1040007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '320', '1040006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '321', '1040005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '322', '1040004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '323', '1040003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '324', '1040002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '325', '1040001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '326', '1051018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '327', '1051017', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '328', '1051016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '329', '1051015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '330', '1051011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '331', '1051010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '332', '1051009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '333', '1051008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '334', '1051007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '335', '1051006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '336', '1051003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '337', '1051002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '338', '1051001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '339', '1050067', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '340', '1050066', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '341', '1050065', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '342', '1050064', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '343', '1050063', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '344', '1050062', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '345', '1050061', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '346', '1050060', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '347', '1050059', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '348', '1050058', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '349', '1050057', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '350', '1050056', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '351', '1050055', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '352', '1050054', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '353', '1050052', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '354', '1050051', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '355', '1050049', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '356', '1050048', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '357', '1050047', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '358', '1050046', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '359', '1050045', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '360', '1050044', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '361', '1050043', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '362', '1050042', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '363', '1050041', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '364', '1050040', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '365', '1050039', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '366', '1050038', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '367', '1050037', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '368', '1050036', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '369', '1050035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '370', '1050034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '371', '1050033', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '372', '1050032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '373', '1050031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '374', '1050030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '375', '1050029', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '376', '1050028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '377', '1050027', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '378', '1050026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '379', '1050025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '380', '1050024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '381', '1050023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '382', '1050022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '383', '1050021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '384', '1050020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '385', '1050019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '386', '1050018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '387', '1050017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '388', '1050016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '389', '1050015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '390', '1050014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '391', '1050013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '392', '1050012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '393', '1050011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '394', '1050010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '395', '1050009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '396', '1050008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '397', '1050007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '398', '1050006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '399', '1050005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '400', '1050004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '401', '1050003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '402', '1050001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '403', '1050002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '404', '1060088', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '405', '1060087', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '406', '1060086', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '407', '1061017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '408', '1061016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '409', '1061015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '410', '1060085', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '411', '1060084', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '412', '1061014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '413', '1061013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '414', '1061012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '415', '1061011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '416', '1061010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '417', '1061009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '418', '1060083', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '419', '1060082', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '420', '1061008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '421', '1061005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '422', '1061004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '423', '1060081', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '424', '1060080', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '425', '1060079', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '426', '1060078', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '427', '1060077', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '428', '1061003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '431', '1060072', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '432', '1060071', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '433', '1060070', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '434', '1060069', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '435', '1060068', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '436', '1060067', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '439', '1060064', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '444', '1060059', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '445', '1060058', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '450', '1060053', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '452', '1060051', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '453', '1060050', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '454', '1060049', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '455', '1060048', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '456', '1060047', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '457', '1060046', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '462', '1060041', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '464', '1060039', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '465', '1060032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '466', '1060031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '467', '1060030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '468', '1060029', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '469', '1060028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '470', '1060027', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '471', '1060026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '472', '1060025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '473', '1060024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '474', '1060023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '475', '1060022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '476', '1060021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '477', '1060020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '478', '1060019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '479', '1060018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '480', '1060017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '481', '1060016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '482', '1060015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '483', '1060014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '484', '1060013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '485', '1060012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '486', '1060011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '488', '1060009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '494', '1060003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '497', '1060000', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '498', '1060038', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '499', '1060037', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '500', '1060036', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '501', '1060035', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '502', '1060034', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '503', '1060033', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '505', '2000001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '506', '2000002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '507', '2000003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '508', '2000004', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '509', '2000005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '510', '2000007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '511', '2000008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '512', '2000009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '514', '2010001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '515', '2010002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '516', '2010004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '517', '2010006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '518', '2010007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '519', '2010008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '522', '2010011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '524', '2010013', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '526', '2010016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '527', '2010017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '529', '2010019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '530', '2010020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '531', '2020001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '532', '2020002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '533', '2020003', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '534', '2020004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '535', '2030001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '536', '2030002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '538', '2030004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '539', '2030005', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '540', '2030006', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '541', '2040001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '542', '2040002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '543', '2040003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '546', '2050001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '549', '2060001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '550', '2060002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '551', '2060003', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '553', '3000000', '1', '3', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '554', '3000001', '1', '2', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '555', '3000002', '1', '4', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '557', '3010001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '558', '3020001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '559', '3030001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '560', '3040001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '561', '3050001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '562', '3060001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '563', '3070001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '564', '3080001', '1', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '565', '2000012', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '566', '2000500', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '567', '2000501', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '568', '2000502', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '569', '2000010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '570', '1022000', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '571', '1031020', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '572', '1031021', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '573', '1060090', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '574', '1060091', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '575', '1041020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '576', '1051020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '577', '1001003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '578', '1060092', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '579', '1011007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '580', '1011006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '582', '1011004', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '583', '1011003', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '584', '1022001', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '585', '1022002', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '586', '1022003', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '587', '1022004', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '588', '1022005', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '589', '1022006', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '590', '1022007', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '591', '1022008', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '592', '1022009', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '593', '1022010', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '594', '1031022', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '595', '1031023', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '596', '1031024', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '597', '1031025', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '598', '1031026', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '599', '1031027', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '600', '1031028', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '601', '1031029', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '602', '1031030', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '603', '1031031', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '604', '1041021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '605', '1041022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '606', '1041023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '607', '1041024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '608', '1041025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '609', '1041026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '610', '1041027', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '611', '1041028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '612', '1041029', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '613', '1041030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '615', '1001005', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '616', '1001006', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '617', '1001007', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '618', '1051021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '619', '1051022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '620', '1051023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '621', '1051024', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '622', '1051025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '623', '1051026', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '624', '1051027', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '625', '1051028', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '626', '1051029', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '627', '1051030', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '628', '2000503', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '629', '2000504', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '630', '1022011', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '631', '1022012', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '632', '1051031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '633', '1051032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '635', '1001009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '636', '1041031', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '637', '1041032', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '638', '1031032', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '639', '1031033', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '640', '2000505', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '641', '2010601', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '642', '2010602', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '643', '2010603', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '644', '2020605', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '645', '2010606', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '646', '1001010', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '647', '1001011', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '648', '1001012', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '649', '1001013', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '650', '1001014', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '651', '1001015', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '652', '1060093', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '653', '1001016', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '654', '1011008', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '655', '1022013', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '656', '1031034', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '657', '1051033', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '658', '1041033', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '659', '1060094', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '660', '1001017', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '661', '1011009', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '662', '1022014', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '663', '1031035', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '664', '1051034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '665', '1041034', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '666', '1022016', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '667', '1031037', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '668', '1051036', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '669', '1041036', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '670', '1022015', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '671', '1031036', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '672', '1051035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '673', '1041035', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '674', '1022017', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '675', '1031038', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '676', '1051037', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '677', '1041037', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '678', '1022018', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '679', '1031039', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '680', '1051038', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '681', '1041038', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '682', '1060095', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '683', '2000506', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '684', '2000507', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '685', '1060002', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '686', '1060001', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '687', '2000508', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '688', '1060096', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '689', '1031041', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '690', '1022019', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '691', '1031040', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '692', '1041039', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '693', '1051039', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '695', '1001018', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '696', '1001019', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '697', '1001020', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '698', '1060098', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '699', '1060099', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '700', '1060100', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '701', '1022020', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '702', '1022021', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '704', '1031042', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '705', '1031043', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '706', '1051040', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '707', '1051041', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '708', '1041040', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '709', '1041041', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '710', '2000511', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '711', '2000510', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '712', '2010607', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '713', '2000608', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '714', '2000609', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '715', '2000512', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '716', '2000513', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '717', '2000610', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '718', '2000611', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '719', '2010015', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '720', '2010018', '2', '1', '0', '0' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '721', '2000612', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '722', '1041042', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '723', '1001021', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '724', '1001022', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '725', '1031044', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '726', '1022022', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '727', '1022023', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '728', '1022024', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '729', '1051042', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '730', '1051043', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '731', '1051044', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '732', '1031045', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '733', '1041043', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '734', '1041044', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '735', '1022025', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '736', '1031046', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '737', '1022026', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '738', '1031047', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '739', '1022027', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '740', '1041045', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '741', '1051045', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '742', '1051046', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '743', '1041046', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '744', '1022028', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '745', '1031048', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '746', '1031049', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '747', '1041047', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '748', '1031050', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '749', '1041048', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '750', '1041049', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '751', '1041050', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '752', '1041051', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '753', '1060101', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '754', '1001023', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '757', '1022029', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '758', '1051047', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '759', '1022030', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '760', '1022031', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '761', '1022032', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '762', '1031052', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '763', '1051048', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '764', '1051049', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '765', '1022033', '2', '7', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '766', '1001025', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '767', '2000613', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '768', '2010614', '2', '1', '0', '1' );
INSERT INTO `shop_iteminfos`(`Id`,`ShopItemId`,`PriceGroupId`,`EffectGroupId`,`DiscountPercentage`,`IsEnabled`) VALUES ( '769', '2000614', '2', '1', '0', '1' );
-- ---------------------------------------------------------


-- Dump data of "shop_items" -------------------------------
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000000', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000001', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000002', '2', '0', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000003', '2', '0', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000004', '2', '0', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000005', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000006', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000007', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000008', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000009', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000010', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000011', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000012', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000013', '1', '0', '8', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000014', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000015', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000016', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000017', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000018', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000019', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000020', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000021', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000022', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000023', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000024', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000025', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000026', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000027', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000028', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000030', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000031', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000032', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000033', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000034', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1000035', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001001', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001002', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001003', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001005', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001006', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001007', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001009', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001010', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001011', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001012', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001013', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001014', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001015', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001016', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001017', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001018', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001019', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001020', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001021', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001022', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001023', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1001025', '1', '0', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010001', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010002', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010003', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010004', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010005', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010006', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010007', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010008', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010009', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010010', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010011', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010012', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010013', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010014', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010015', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010016', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010017', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010018', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010019', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010020', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010022', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010023', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010024', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010025', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010026', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010028', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010031', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010032', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010033', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010034', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1010035', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011001', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011002', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011004', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011006', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011007', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011008', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1011009', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020000', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020001', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020002', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020003', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020004', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020005', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020006', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020007', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020008', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020009', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020010', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020011', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020012', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020013', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020014', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020015', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020016', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020018', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020019', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020020', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020021', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020022', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020024', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020025', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020026', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020027', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020028', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020029', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020030', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020031', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020032', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020033', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020034', '1', '0', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020035', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020036', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020037', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020038', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020039', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020040', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020041', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020042', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020043', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020044', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020045', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020046', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020047', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020048', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020049', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020050', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020051', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020052', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020053', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020054', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020055', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020056', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020058', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020059', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020061', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020062', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020063', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020064', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020065', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020066', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020067', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020068', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020069', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020070', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020071', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020072', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020073', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020074', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020075', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020076', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1020077', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021001', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021002', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021004', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021005', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021006', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021007', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021008', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021009', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021010', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021011', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021015', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021017', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1021018', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022000', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022001', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022002', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022003', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022004', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022005', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022006', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022007', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022008', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022009', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022010', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022011', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022012', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022013', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022014', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022015', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022017', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022018', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022019', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022020', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022021', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022022', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022023', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022024', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022025', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022026', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022027', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022028', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022029', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022030', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022031', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022032', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1022033', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030000', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030001', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030002', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030003', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030004', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030005', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030006', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030007', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030008', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030009', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030010', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030011', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030012', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030013', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030014', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030015', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030016', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030017', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030018', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030019', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030020', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030021', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030022', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030023', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030024', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030025', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030026', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030027', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030028', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030029', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030030', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030031', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030032', '1', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030033', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030034', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030035', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030036', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030037', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030038', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030039', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030040', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030041', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030042', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030043', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030044', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030045', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030046', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030047', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030048', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030049', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030050', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030051', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030052', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030053', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030054', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030056', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030057', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030059', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030060', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030061', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030062', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030063', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030064', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030065', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030066', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030067', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030068', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030069', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030070', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030071', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030072', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030073', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1030074', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031001', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031002', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031004', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031005', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031006', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031007', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031008', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031009', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031010', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031011', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031015', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031017', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031018', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031020', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031021', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031022', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031023', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031024', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031025', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031026', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031027', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031028', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031029', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031030', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031031', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031032', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031033', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031034', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031035', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031036', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031037', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031038', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031039', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031040', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031041', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031042', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031043', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031044', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031045', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031046', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031047', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031048', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031049', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031050', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1031052', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040001', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040002', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040003', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040004', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040005', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040006', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040007', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040008', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040009', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040010', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040011', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040012', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040013', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040014', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040015', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040016', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040018', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040019', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040020', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040021', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040022', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040023', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040024', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040025', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040026', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040027', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040028', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040029', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040030', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040031', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040032', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040033', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040034', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040035', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040036', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040037', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040038', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040039', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040040', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040041', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040042', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040043', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040044', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040045', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040046', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040047', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040048', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040049', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040050', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040052', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040053', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040055', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040056', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040057', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040058', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040059', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040060', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040061', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040062', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040063', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040064', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040065', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1040066', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041001', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041002', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041006', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041007', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041008', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041009', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041010', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041011', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041015', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041018', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041020', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041021', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041022', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041023', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041024', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041025', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041026', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041027', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041028', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041029', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041030', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041031', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041032', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041033', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041034', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041035', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041036', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041037', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041038', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041039', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041040', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041041', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041042', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041043', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041044', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041045', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041046', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041047', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041048', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041049', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041050', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1041051', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050001', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050002', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050003', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050004', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050005', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050006', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050007', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050008', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050009', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050010', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050011', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050012', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050013', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050014', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050015', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050016', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050018', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050019', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050020', '2', '0', '6', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050021', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050022', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050023', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050024', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050025', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050026', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050027', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050028', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050029', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050030', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050031', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050032', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050033', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050034', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050035', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050036', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050037', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050038', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050039', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050040', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050041', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050042', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050043', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050044', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050045', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050046', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050047', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050048', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050049', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050051', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050052', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050054', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050055', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050056', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050057', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050058', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050059', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050060', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050061', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050062', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050063', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050064', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050065', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050066', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1050067', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051001', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051002', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051006', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051007', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051008', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051009', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051010', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051011', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051015', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051018', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051020', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051021', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051022', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051023', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051024', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051025', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051026', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051027', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051028', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051029', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051030', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051031', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051032', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051033', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051034', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051035', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051036', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051037', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051038', '1', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051039', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051040', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051041', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051042', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051043', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051044', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051045', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051046', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051047', '2', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051048', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1051049', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060000', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060001', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060002', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060003', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060009', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060011', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060012', '0', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060013', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060014', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060015', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060016', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060018', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060019', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060020', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060021', '2', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060022', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060023', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060024', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060025', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060026', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060027', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060028', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060029', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060030', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060031', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060032', '1', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060033', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060034', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060035', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060036', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060037', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060038', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060039', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060041', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060046', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060047', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060048', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060049', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060050', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060051', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060053', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060058', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060059', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060064', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060067', '1', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060068', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060069', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060070', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060071', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060072', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060077', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060078', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060079', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060080', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060081', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060082', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060083', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060084', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060085', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060086', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060087', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060088', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060090', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060091', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060092', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060093', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060094', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060095', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060096', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060098', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060099', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060100', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1060101', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061003', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061004', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061005', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061008', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061009', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061010', '2', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061011', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061012', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061013', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061014', '1', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061015', '2', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061016', '1', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '1061017', '2', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000001', '0', '1', '7', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000002', '0', '2', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000003', '0', '26', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000004', '0', '26', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000005', '0', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000007', '0', '1', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000008', '0', '1', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000009', '0', '2', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000010', '0', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000012', '0', '2', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000500', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000501', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000502', '0', '26', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000503', '0', '1', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000504', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000505', '0', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000506', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000507', '0', '26', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000508', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000510', '0', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000511', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000512', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000513', '0', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000608', '0', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000609', '0', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000610', '0', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000611', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000612', '0', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000613', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2000614', '0', '26', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010001', '0', '3', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010002', '0', '4', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010004', '0', '25', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010006', '0', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010007', '0', '0', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010008', '0', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010011', '0', '25', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010013', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010015', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010016', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010017', '0', '3', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010018', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010019', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010020', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010601', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010602', '0', '0', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010603', '0', '0', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010606', '0', '4', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010607', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2010614', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2020001', '0', '5', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2020002', '0', '27', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2020003', '0', '27', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2020004', '0', '5', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2020605', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2030001', '0', '6', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2030002', '0', '7', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2030004', '0', '7', '2', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2030005', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2030006', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2040001', '0', '8', '4', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2040002', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2040003', '0', '28', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2040004', '0', '0', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2050001', '0', '10', '5', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2060001', '0', '11', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2060002', '0', '12', '3', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '2060003', '0', '11', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3000000', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3000001', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3000002', '0', '0', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3010001', '0', '13', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3020001', '0', '14', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3030001', '0', '15', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3040001', '0', '16', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3050001', '0', '17', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3060001', '0', '18', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3070001', '0', '19', '0', '0', '0', '0', '0', '0', '1' );
INSERT INTO `shop_items`(`Id`,`RequiredGender`,`RequiredLicense`,`Colors`,`UniqueColors`,`RequiredLevel`,`LevelLimit`,`RequiredMasterLevel`,`IsOneTimeUse`,`IsDestroyable`) VALUES ( '3080001', '0', '20', '0', '0', '0', '0', '0', '0', '1' );
-- ---------------------------------------------------------


-- Dump data of "shop_price_groups" ------------------------
INSERT INTO `shop_price_groups`(`Id`,`Name`,`PriceType`) VALUES ( '1', 'PEN', '1' );
INSERT INTO `shop_price_groups`(`Id`,`Name`,`PriceType`) VALUES ( '2', 'PREM', '3' );
-- ---------------------------------------------------------


-- Dump data of "shop_prices" ------------------------------
INSERT INTO `shop_prices`(`Id`,`PriceGroupId`,`PeriodType`,`Period`,`Price`,`IsRefundable`,`Durability`,`IsEnabled`) VALUES ( '1', '1', '1', '0', '1', '1', '1000000', '1' );
INSERT INTO `shop_prices`(`Id`,`PriceGroupId`,`PeriodType`,`Period`,`Price`,`IsRefundable`,`Durability`,`IsEnabled`) VALUES ( '2', '2', '1', '0', '1', '1', '1000000', '1' );
-- ---------------------------------------------------------


-- Dump data of "shop_version" -----------------------------
INSERT INTO `shop_version`(`Id`,`Version`) VALUES ( '1', '201708291221' );
-- ---------------------------------------------------------


-- Dump data of "start_items" ------------------------------
-- ---------------------------------------------------------


-- CREATE INDEX "ShopItemInfoId" ---------------------------
CREATE INDEX `ShopItemInfoId` USING BTREE ON `license_rewards`( `ShopItemInfoId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopPriceId" ------------------------------
CREATE INDEX `ShopPriceId` USING BTREE ON `license_rewards`( `ShopPriceId` );
-- ---------------------------------------------------------


-- CREATE INDEX "AccessoryId" ------------------------------
CREATE INDEX `AccessoryId` USING BTREE ON `player_characters`( `AccessoryId` );
-- ---------------------------------------------------------


-- CREATE INDEX "FaceId" -----------------------------------
CREATE INDEX `FaceId` USING BTREE ON `player_characters`( `FaceId` );
-- ---------------------------------------------------------


-- CREATE INDEX "GlovesId" ---------------------------------
CREATE INDEX `GlovesId` USING BTREE ON `player_characters`( `GlovesId` );
-- ---------------------------------------------------------


-- CREATE INDEX "HairId" -----------------------------------
CREATE INDEX `HairId` USING BTREE ON `player_characters`( `HairId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PantsId" ----------------------------------
CREATE INDEX `PantsId` USING BTREE ON `player_characters`( `PantsId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_characters`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShirtId" ----------------------------------
CREATE INDEX `ShirtId` USING BTREE ON `player_characters`( `ShirtId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShoesId" ----------------------------------
CREATE INDEX `ShoesId` USING BTREE ON `player_characters`( `ShoesId` );
-- ---------------------------------------------------------


-- CREATE INDEX "SkillId" ----------------------------------
CREATE INDEX `SkillId` USING BTREE ON `player_characters`( `SkillId` );
-- ---------------------------------------------------------


-- CREATE INDEX "Weapon1Id" --------------------------------
CREATE INDEX `Weapon1Id` USING BTREE ON `player_characters`( `Weapon1Id` );
-- ---------------------------------------------------------


-- CREATE INDEX "Weapon2Id" --------------------------------
CREATE INDEX `Weapon2Id` USING BTREE ON `player_characters`( `Weapon2Id` );
-- ---------------------------------------------------------


-- CREATE INDEX "Weapon3Id" --------------------------------
CREATE INDEX `Weapon3Id` USING BTREE ON `player_characters`( `Weapon3Id` );
-- ---------------------------------------------------------


-- CREATE INDEX "DenyPlayerId" -----------------------------
CREATE INDEX `DenyPlayerId` USING BTREE ON `player_deny`( `DenyPlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_deny`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_items`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopItemInfoId" ---------------------------
CREATE INDEX `ShopItemInfoId` USING BTREE ON `player_items`( `ShopItemInfoId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopPriceId" ------------------------------
CREATE INDEX `ShopPriceId` USING BTREE ON `player_items`( `ShopPriceId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_licenses`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_mails`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "SenderPlayerId" ---------------------------
CREATE INDEX `SenderPlayerId` USING BTREE ON `player_mails`( `SenderPlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PlayerId" ---------------------------------
CREATE INDEX `PlayerId` USING BTREE ON `player_settings`( `PlayerId` );
-- ---------------------------------------------------------


-- CREATE INDEX "EffectGroupId" ----------------------------
CREATE INDEX `EffectGroupId` USING BTREE ON `shop_effects`( `EffectGroupId` );
-- ---------------------------------------------------------


-- CREATE INDEX "EffectGroupId" ----------------------------
CREATE INDEX `EffectGroupId` USING BTREE ON `shop_iteminfos`( `EffectGroupId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PriceGroupId" -----------------------------
CREATE INDEX `PriceGroupId` USING BTREE ON `shop_iteminfos`( `PriceGroupId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopItemId" -------------------------------
CREATE INDEX `ShopItemId` USING BTREE ON `shop_iteminfos`( `ShopItemId` );
-- ---------------------------------------------------------


-- CREATE INDEX "PriceGroupId" -----------------------------
CREATE INDEX `PriceGroupId` USING BTREE ON `shop_prices`( `PriceGroupId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopEffectId" -----------------------------
CREATE INDEX `ShopEffectId` USING BTREE ON `start_items`( `ShopEffectId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopItemInfoId" ---------------------------
CREATE INDEX `ShopItemInfoId` USING BTREE ON `start_items`( `ShopItemInfoId` );
-- ---------------------------------------------------------


-- CREATE INDEX "ShopPriceId" ------------------------------
CREATE INDEX `ShopPriceId` USING BTREE ON `start_items`( `ShopPriceId` );
-- ---------------------------------------------------------


-- CREATE LINK "license_rewards_ibfk_1" --------------------
ALTER TABLE `license_rewards`
	ADD CONSTRAINT `license_rewards_ibfk_1` FOREIGN KEY ( `ShopItemInfoId` )
	REFERENCES `shop_iteminfos`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "license_rewards_ibfk_2" --------------------
ALTER TABLE `license_rewards`
	ADD CONSTRAINT `license_rewards_ibfk_2` FOREIGN KEY ( `ShopPriceId` )
	REFERENCES `shop_prices`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_1" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_10" -----------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_10` FOREIGN KEY ( `GlovesId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_11" -----------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_11` FOREIGN KEY ( `ShoesId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_12" -----------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_12` FOREIGN KEY ( `AccessoryId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_2" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_2` FOREIGN KEY ( `Weapon1Id` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_3" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_3` FOREIGN KEY ( `Weapon2Id` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_4" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_4` FOREIGN KEY ( `Weapon3Id` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_5" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_5` FOREIGN KEY ( `SkillId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_6" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_6` FOREIGN KEY ( `HairId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_7" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_7` FOREIGN KEY ( `FaceId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_8" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_8` FOREIGN KEY ( `ShirtId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_characters_ibfk_9" ------------------
ALTER TABLE `player_characters`
	ADD CONSTRAINT `player_characters_ibfk_9` FOREIGN KEY ( `PantsId` )
	REFERENCES `player_items`( `Id` )
	ON DELETE Set NULL
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_deny_ibfk_1" ------------------------
ALTER TABLE `player_deny`
	ADD CONSTRAINT `player_deny_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_deny_ibfk_2" ------------------------
ALTER TABLE `player_deny`
	ADD CONSTRAINT `player_deny_ibfk_2` FOREIGN KEY ( `DenyPlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_items_ibfk_1" -----------------------
ALTER TABLE `player_items`
	ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_items_ibfk_2" -----------------------
ALTER TABLE `player_items`
	ADD CONSTRAINT `player_items_ibfk_2` FOREIGN KEY ( `ShopItemInfoId` )
	REFERENCES `shop_iteminfos`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_items_ibfk_3" -----------------------
ALTER TABLE `player_items`
	ADD CONSTRAINT `player_items_ibfk_3` FOREIGN KEY ( `ShopPriceId` )
	REFERENCES `shop_prices`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_licenses_ibfk_1" --------------------
ALTER TABLE `player_licenses`
	ADD CONSTRAINT `player_licenses_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_mails_ibfk_1" -----------------------
ALTER TABLE `player_mails`
	ADD CONSTRAINT `player_mails_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_mails_ibfk_2" -----------------------
ALTER TABLE `player_mails`
	ADD CONSTRAINT `player_mails_ibfk_2` FOREIGN KEY ( `SenderPlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "player_settings_ibfk_1" --------------------
ALTER TABLE `player_settings`
	ADD CONSTRAINT `player_settings_ibfk_1` FOREIGN KEY ( `PlayerId` )
	REFERENCES `players`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "shop_effects_ibfk_1" -----------------------
ALTER TABLE `shop_effects`
	ADD CONSTRAINT `shop_effects_ibfk_1` FOREIGN KEY ( `EffectGroupId` )
	REFERENCES `shop_effect_groups`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "shop_iteminfos_ibfk_2" ---------------------
ALTER TABLE `shop_iteminfos`
	ADD CONSTRAINT `shop_iteminfos_ibfk_2` FOREIGN KEY ( `PriceGroupId` )
	REFERENCES `shop_price_groups`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "shop_iteminfos_ibfk_3" ---------------------
ALTER TABLE `shop_iteminfos`
	ADD CONSTRAINT `shop_iteminfos_ibfk_3` FOREIGN KEY ( `EffectGroupId` )
	REFERENCES `shop_effect_groups`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "shop_iteminfos_ibfk_4" ---------------------
ALTER TABLE `shop_iteminfos`
	ADD CONSTRAINT `shop_iteminfos_ibfk_4` FOREIGN KEY ( `ShopItemId` )
	REFERENCES `shop_items`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "shop_prices_ibfk_1" ------------------------
ALTER TABLE `shop_prices`
	ADD CONSTRAINT `shop_prices_ibfk_1` FOREIGN KEY ( `PriceGroupId` )
	REFERENCES `shop_price_groups`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "start_items_ibfk_1" ------------------------
ALTER TABLE `start_items`
	ADD CONSTRAINT `start_items_ibfk_1` FOREIGN KEY ( `ShopItemInfoId` )
	REFERENCES `shop_iteminfos`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "start_items_ibfk_2" ------------------------
ALTER TABLE `start_items`
	ADD CONSTRAINT `start_items_ibfk_2` FOREIGN KEY ( `ShopPriceId` )
	REFERENCES `shop_prices`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


-- CREATE LINK "start_items_ibfk_3" ------------------------
ALTER TABLE `start_items`
	ADD CONSTRAINT `start_items_ibfk_3` FOREIGN KEY ( `ShopEffectId` )
	REFERENCES `shop_effects`( `Id` )
	ON DELETE Cascade
	ON UPDATE Restrict;
-- ---------------------------------------------------------


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- ---------------------------------------------------------


