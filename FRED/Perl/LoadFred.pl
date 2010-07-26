# Copyright (c) <2010> <Nick A Torenvliet>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

#!/usr/bin/perl
use File::Copy;
use File::Spec;
use File::Path;
use DBI;

sub init(){
		#get your options here
     	use Getopt::Long;
        my $opt_string = 'hd=sv=sq=s:';
		GetOptions( "d=s" => \$dbName,"v=s" => \$mySQLUserName,"q=s" => \$mySQLPassWord,"h"  ) or usage();
        usage() if $opt_h;
        usage() unless($dbName);
        usafe() unless($mySQLUserName);
        usage() unless($mySQLPassWord);
}

sub usage(){
    print STDERR << "EOF";
    
    $0 logs into ftp.eoddata.com and downloads daily information.
    Market and fundamental indicator data are inserted into db tables as specified
    and split, names and technical indicators stay in text file format.  
    All text files are archived. 

     -h        : this (help) message
     -d        : local MySQL database name - required
     -v        : local MySQL database user name - required
     -q        : local MySQL database password - required

    example: $0 -d myLocalMySQLDataBase -v myLocalMySQLDBUserName -p myLocalMySQLDBPassWord 
EOF
	exit;
}

sub buildFredDatabase(){
	do ".config";
	my $dbh = DBI->connect('DBI:mysql:FRED:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	
	$sql = "create table if not exists fredKey (seriesName char(20) not null, seriesTitle char(250), seriesUnits char(50), seriesFrequency char(5), seriesSeasonalAdjustment char(5), seriesLastUpdated date not null, primary key(seriesName,seriesLastUpdated))";
	$dbh->do($sql); 
	
	open(FH0,$FREDKEYFILE);

	foreach $line (<FH0>){
		@fileLineSplit = split(/;/,$line);
		@seriesNameSplit = split(/\\/,@fileLineSplit[0]);
		@tableName =  split(/\./,@seriesNameSplit[$#seriesNameSplit]);
		#print("@fileLineSplit[0] @seriesNameSplit[$#seriesNameSplit] @tableName[0]\n");
   		my $sth = $dbh->prepare("INSERT INTO fredKey (seriesName, seriesTitle,seriesUnits,seriesFrequency,seriesSeasonalAdjustment,seriesLastUpdated) values (?,?,?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute(@tableName[0],@fileLineSplit[1],@fileLineSplit[2],@fileLineSplit[3],@fileLineSplit[4],@fileLineSplit[5]);
		$dataFile = @fileLineSplit[0];	
		$dataFile =~ s/\\/\//g;
		$dataFile = "$FREDDATA\/$dataFile";
		
		print("Processing $dataFile\n");
		$sql = "create table if not exists @tableName[0] (date DATE not null, datum decimal(10,4) not null, primary key(date,datum))";
		$dbh->do($sql); 

		open(FH1,$dataFile);
		foreach $dataLine (<FH1>){
			@fileLineSplit = split(/,/,$dataLine);
			#print("@tableName[0] @fileLineSplit[0] @fileLineSplit[1]");
			#$sql = "insert into @tableName[0] (date, datum) values (@fileLineSplit[0],@fileLineSplit[1])";
			#$dbh->do($sql); 
			my $sth = $dbh->prepare("INSERT INTO @tableName[0] (date,datum) values (?,?)")
				or die "Couldn't prepare statement: " . $dbh->errstr;
			$sth->execute(@fileLineSplit[0],chomp(@fileLineSplit[1]));
		}		
	}
	$dbh->disconnect;
	
}

init();
buildFredDatabase();


