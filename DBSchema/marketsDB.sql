-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (x86_64)
DROP TABLE IF EXISTS `changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changes` (
  `date` date NOT NULL,
  `exchange` char(8) NOT NULL,
  `oldSymbol` char(11) NOT NULL,
  `newSymbol` char(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `endOfDayData`
--

DROP TABLE IF EXISTS `endOfDayData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endOfDayData` (
  `date` date NOT NULL,
  `market` char(8) NOT NULL,
  `symbol` char(11) NOT NULL,
  `open` decimal(10,4) NOT NULL,
  `high` decimal(10,4) NOT NULL,
  `low` decimal(10,4) NOT NULL,
  `close` decimal(10,4) NOT NULL,
  `volume` int(11) NOT NULL,
  PRIMARY KEY (`date`,`market`,`symbol`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exchanges`
--

DROP TABLE IF EXISTS `exchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchanges` (
  `exchange` char(8) NOT NULL,
  `name` char(60) NOT NULL,
  PRIMARY KEY (`exchange`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `fundamentals`;

CREATE TABLE `fundamentals` (
  `date` date NOT NULL,
  `market` char(8) NOT NULL,
  `symbol` char(11) NOT NULL,
  `name` char(100) DEFAULT NULL,
  `sector` char(50) DEFAULT NULL,
  `industry` char(50) DEFAULT NULL,
  `PE` decimal(6,2) DEFAULT NULL,
  `EPS` decimal(6,3) DEFAULT NULL,
  `divYield` decimal(6,3) DEFAULT NULL,
  `shares` int(10) unsigned DEFAULT NULL,
  `DPS` decimal(7,3) DEFAULT NULL,
  `PEG` decimal(6,2) DEFAULT NULL,
  `PTS` decimal(6,2) DEFAULT NULL,
  `PTB` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`date`,`market`,`symbol`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `names`;

CREATE TABLE `names` (
  `market` char(8) NOT NULL,
  `symbol` char(11) NOT NULL,
  `name` char(100) DEFAULT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`market`,`symbol`,`date`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='symbol names';

DROP TABLE IF EXISTS `splits`;
CREATE TABLE `splits` (
  `date` date NOT NULL,
  `market` char(8) NOT NULL,
  `symbol` char(11) NOT NULL,
  `ratio` char(6) NOT NULL,
  PRIMARY KEY (`date`,`market`,`symbol`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `technicals`;

CREATE TABLE `technicals` (
  `date` date NOT NULL,
  `market` char(8) NOT NULL,
  `symbol` char(11) NOT NULL,
  `previous` decimal(10,4) DEFAULT NULL,
  `delta` decimal(10,4) DEFAULT NULL,
  `volumeChange` int(11) DEFAULT NULL,
  `weekHigh` decimal(10,4) DEFAULT NULL,
  `weekLow` decimal(10,4) DEFAULT NULL,
  `weekChange` decimal(10,4) DEFAULT NULL,
  `avgWeekChange` decimal(10,4) DEFAULT NULL,
  `avgWeekVolume` int(11) DEFAULT NULL,
  `monthHigh` decimal(10,4) DEFAULT NULL,
  `monthLow` decimal(10,4) DEFAULT NULL,
  `monthChange` decimal(10,4) DEFAULT NULL,
  `avgMonthChange` decimal(10,4) DEFAULT NULL,
  `avgMonthVolume` int(11) DEFAULT NULL,
  `yearHigh` decimal(10,4) DEFAULT NULL,
  `yearLow` decimal(10,4) DEFAULT NULL,
  `yearChange` decimal(10,4) DEFAULT NULL,
  `avgYearChange` decimal(10,4) DEFAULT NULL,
  `avgYearVolume` int(11) DEFAULT NULL,
  `MA5` decimal(10,4) DEFAULT NULL,
  `MA20` decimal(10,4) DEFAULT NULL,
  `MA50` decimal(10,4) DEFAULT NULL,
  `MA100` decimal(10,4) DEFAULT NULL,
  `MA200` decimal(10,4) DEFAULT NULL,
  `RSI14` decimal(10,4) DEFAULT NULL,
  `STO9` decimal(10,4) DEFAULT NULL,
  `WPR14` decimal(10,4) DEFAULT NULL,
  `MTM14` decimal(10,4) DEFAULT NULL,
  `ROC14` decimal(10,4) DEFAULT NULL,
  `PTC` int(11) DEFAULT NULL,
  PRIMARY KEY (`date`,`market`,`symbol`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- Dump completed on 2010-05-26 18:38:00
