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
use File::Path;
use DBI;

sub init(){
		#get your options here
     	use Getopt::Long;
        my $opt_string = 'hu=sp=sd=sv=sq=s:';
		GetOptions( "u=s" => \$userName, "p=s" => \$passWord,"d=s" => \$dbName,"v=s" => \$mySQLUserName,"q=s" => \$mySQLPassWord,"h"  ) or usage();
        usage() if $opt_h;
        usage() unless($dbName);
        usage() unless($mySQLPassWord);
		usage() unless($userName);
		usage() unless($passWord);
}

sub usage(){
    print STDERR << "EOF";
    
    $0 logs into ftp.eoddata.com and downloads daily information.
    Market and fundamental indicator data are inserted into db tables as specified
    and split, names and technical indicators stay in text file format.  
    All text files are archived. 

     -h        : this (help) message
     -u        : www.eoddata.com username - required 
     -p        : www.eoddata.com password - required
     -d        : local MySQL database name - required
     -v        : local MySQL database user name - required
     -q        : local MySQL database password - required

    example: $0 -u myEODDataUserName -p myEODDataPassWord -d myLocalMySQLDataBase -v myLocalMySQLDBUserName -p myLocalMySQLDBPassWord 
EOF
	exit;
}

sub getEODData(){
	do ".config";
	chdir("$BASEDIR");
	chdir("Data");
	system("wget -r -v -nc --ftp-user=$userName --ftp-password=$passWord ftp://ftp.eoddata.com/");
	mkdir("ftp.eoddata.com/Archive");
	mkdir("ftp.eoddata.com/Archive/$date");
	unlink("ftp.eoddata.com/terms.txt");
	unlink("ftp.eoddata.com/readme.txt");
	rmtree("ftp.eoddata.com/Software");
}

sub insertFundamentalsData(){
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");
	chdir("Fundamentals");
		
	unlink("terms.txt");
	unlink("readme.txt");
	@files = <*>;
 	foreach $file (@files) {
 		 if($file =~ /.txt/){
 			@marketString = split("\\.",$file);
 			open(FH,$file);	
 			my $i = 0;
			foreach $line (<FH>) {
				if($i!=0){
					@dataString = split(/\t/,$line);
		       		my $sth = $dbh->prepare("INSERT INTO fundamentals (date,market,symbol,name,sector,industry,PE,EPS,divYield,shares,DPS,PEG,PTS,PTB) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute($date,@marketString[0],@dataString[0],@dataString[1],@dataString[2],@dataString[3],@dataString[4],@dataString[5],@dataString[6],@dataString[7],@dataString[8],@dataString[9],@dataString[10],@dataString[11]);
				}
				$i++; 
			}
 			close(FH);
 		}	
	}
	$dbh->disconnect;

	#move the directory into the archives and drop back into EODData	
	chdir("..");
	mkdir("Archive/$date");
	mkdir("Archive/$date/Fundamentals");
	move("Fundamentals","Archive/$date/Fundamentals");
	chdir("..");	
}

sub insertTechnicalsData(){
	print "here\n";
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");
	chdir("Technical");
	unlink("terms.txt");
	unlink("readme.txt");
	@files = <*>;
 	foreach $file (@files) {
 		 if($file =~ /.txt/){
 			@marketString = split("\\.",$file);
 			open(FH,$file);	
 			my $i = 0;
			foreach $line (<FH>) {
				if($i!=0){
					@dataString = split(/\t/,$line);
		       		my $sth = $dbh->prepare("INSERT INTO technicals (date,market,symbol,previous,delta,volumeChange,weekHigh,weekLow,weekChange,avgWeekChange,avgWeekVolume,monthHigh,monthLow,monthChange,avgMonthChange,avgMonthVolume,yearHigh,yearLow,yearChange,avgYearChange,avgYearVolume,MA5,MA20,MA50,MA100,MA200,RSI14,STO9,WPR14,MTM14,ROC14,PTC) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute($date,@marketString[0],@dataString[0],@dataString[1],@dataString[2],@dataString[3],@dataString[4],@dataString[5],@dataString[6],@dataString[7],@dataString[8],@dataString[9],@dataString[10],@dataString[11],@dataString[12],@dataString[13],@dataString[14],@dataString[15],@dataString[16],@dataString[17],@dataString[18],@dataString[19],@dataString[20],@dataString[21],@dataString[22],@dataString[23],@dataString[24],@dataString[25],@dataString[26],@dataString[27],@dataString[28],@dataString[29]);
				}
				$i++;	 
			}
 			close(FH);
 		}	
	}
	$dbh->disconnect;
	
	#move the directory into the archives and drop back into EODData
	chdir("..");
	mkdir("Archive/$date");
	mkdir("Archive/$date/Technical");
	move("Technical","Archive/$date/Technical");
	chdir("..");		
}

sub insertSplitsData(){
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");
	chdir("Splits");
	unlink("terms.txt");
	unlink("readme.txt");
	@files = <*>;
 	foreach $file (@files) {
 		 if($file =~ /.txt/){
 			@marketString = split("\\.",$file);
 			open(FH,$file);	
			my $i = 0;
			foreach $line (<FH>) {
				if($i!=0){
					@dataString = split(/\t/,$line);
		       		my $sth = $dbh->prepare("INSERT INTO splits (date,market,symbol,ratio) values (?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute(@dataString[1],@marketString[0],@dataString[0],@dataString[2]);
				} 
				$i++;
			}
 			close(FH);
 		}	
	}
	$dbh->disconnect;

	#move the directory into the archives and drop back into EODData
	chdir("..");
	mkdir("Archive/$date");
	mkdir("Archive/$date/Splits");
	move("Splits","Archive/$date/Splits");
	chdir("..");	
}

sub insertNamesData(){
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");
	chdir("Names");
	unlink("terms.txt");
	unlink("readme.txt");
	@files = <*>;
 	foreach $file (@files) {
 		 if($file =~ /.txt/){
 			@marketString = split("\\.",$file);
 			open(FH,$file);	
 			my $i = 0;
			foreach $line (<FH>) {
				if($i!=0){
					@dataString = split(/\t/,$line);
		       		my $sth = $dbh->prepare("INSERT INTO names (market,symbol,name,date) values (?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute(@marketString[0],@dataString[0],@dataString[1],$date); 
				} 
				$i++;
			}
 			close(FH);
 		}	
	}
	$dbh->disconnect;

	#move the directory into the archives and drop back into EODData
	chdir("..");
	mkdir("Archive/$date");
	mkdir("Archive/$date/Names");
	move("Names","Archive/$date/Names");
	chdir("..");	
}

sub insertEODData(){
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");	
	@files = <*>;
 	foreach (@files) {
 		if($_ =~ /.txt/){
 			@marketString = split(/_/,$_);
 			open(FH,$_);	
 			my $i = 0;
			foreach $line (<FH>) {
				if($i!=0){
					@dataString = split(/,/,$line);
		       		my $sth = $dbh->prepare("INSERT INTO endOfDayData (date,market,symbol,open,high,low,close,volume) values (?,?,?,?,?,?,?,?)")
						or die "Couldn't prepare statement: " . $dbh->errstr;
					$sth->execute(@dataString[1],@marketString[0],@dataString[0],@dataString[2],@dataString[3],@dataString[4],@dataString[5],@dataString[6]);
				}
				$i++; 
	   		}
   			close(FH);
   			move("$_","./History/$_");
 		}
 	}
 	$dbh->disconnect;
}

#parse parameters
init();

#Provide us a global date just in case we are working near midnight.
($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
local $date = sprintf '%02d%02d%02d', $Year +1900, $Month +1 , $Day;

#get data from ftp.eoddata.com
getEODData;

#insert end of day market data
insertEODData;

#insert fundamental indicators data
insertFundamentalsData;

#insert technical indicators data
insertTechnicalsData;

#insert splits data
insertSplitsData;

#insert names data
insertNamesData;


