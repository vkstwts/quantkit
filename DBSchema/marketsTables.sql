 /*
Copyright (c) <2010> <Nick Torenvliet>

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
*/

CREATE TABLE `markets`.`names` (
  `dateAdded` date  NOT NULL,
  `market` char(8)  NOT NULL,
  `symbol` char(11)  NOT NULL,
  `name` char(100)  NOT NULL,
  PRIMARY KEY (`market`, `symbol`)
)
ENGINE = MyISAM
COMMENT = 'symbol names';

CREATE TABLE `markets`.`splits` (
  `date` date  NOT NULL,
  `market` char(8)  NOT NULL,
  `symbol` char(11)  NOT NULL,
  `ratio` char(6)  NOT NULL,
  PRIMARY KEY (`date`, `market`, `symbol`)
)
ENGINE = MyISAM;

CREATE TABLE `markets`.`endOfDayData` (
  `date` date  NOT NULL,
  `market` char(8)  NOT NULL,
  `symbol` char(11)  NOT NULL,
  `open` decimal(10,4)  NOT NULL,
  `high` decimal(10,4)  NOT NULL,
  `low` decimal(10,4)  NOT NULL,
  `close` decimal(10,4)  NOT NULL,
  `volume` integer  NOT NULL,
  PRIMARY KEY (`date`, `market`, `symbol`)
)
ENGINE = MyISAM;

CREATE TABLE `markets`.`technicals` (
  `date` date  NOT NULL,
  `market` char(8)  NOT NULL,
  `symbol` char(11)  NOT NULL,
  `previous` decimal(10,4)  NOT NULL,
  `change` decimal(10,4)  NOT NULL,
  `volumeChange` integer  NOT NULL,
  `weekHigh` decimal(10,4)  NOT NULL,
  `weekLow` decimal(10,4)  NOT NULL,
  `weekChange` decimal(10,4)  NOT NULL,
  `avgWeekChange` decimal(10,4)  NOT NULL,
  `avgWeekVolume` integer  NOT NULL,
  `monthHigh` decimal(10,4)  NOT NULL,
  `monthLow` decimal(10,4)  NOT NULL,
  `monthChange` decimal(10,4)  NOT NULL,
  `avgMonthChange` decimal(10,4)  NOT NULL,
  `avgMonthVolume` integer  NOT NULL,
  `yearHigh` decimal(10,4)  NOT NULL,
  `yearLow` decimal(10,4)  NOT NULL,
  `yearChange` decimal(10,4)  NOT NULL,
  `avgYearChange` decimal(10,4)  NOT NULL,
  `avgYearVolume` integer  NOT NULL,
  `MA5` decimal(10,4)  NOT NULL,
  `MA20` decimal(10,4)  NOT NULL,
  `MA50` Decimal(10,4)  NOT NULL,
  `MA100` decimal(10,4)  NOT NULL,
  `MA200` decimal(10,4)  NOT NULL,
  `RSI14` decimal(10,4)  NOT NULL,
  `STO9` decimal(10,4)  NOT NULL,
  `WPR14` decimal(10,4)  NOT NULL,
  `MTM14` decimal(10,4)  NOT NULL,
  `ROC14` Decimal(10,4)  NOT NULL,
  `PTC` integer  NOT NULL,
  PRIMARY KEY (`date`, `market`, `symbol`)
)
ENGINE = MyISAM;

