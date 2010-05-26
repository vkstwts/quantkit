# Copyright (c) <2010> <Nick Torenvliet>
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

    usage: $0 [-hu:p:] [-f file]

     -h        : this (help) message
     -u        : www.eoddata.com username - required - sub in "%40" for "@" sign for proper URL encoding 
     -p        : www.eoddata.com password - required
     -d        : local MySQL database name - required
     -v        : local MySQL database user name - required
     -q        : local MySQL database password - required

    example: $0 -u myEODUserName%40thismail.com -p myEODPassWord -d myLocalMySQLDataBase -v myLocalMySQLDBUserName -p myLocalMySQLDBPassWord 
EOF
	exit;
}

sub getEODData(){
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	my $date = sprintf '%02d%02d%02d', $Year +1900, $Month +1 , $Day;
	#chdir("~/SoothSayer/EODData/Data");
	system("wget -r -v -nc --ftp-user=n_torenvliet --ftp-password=1Mbrosi1 ftp://ftp.eoddata.com/");
	mkdir("ftp.eoddata.com/Archive");
	mkdir("ftp.eoddata.com/Archive/$date");
	mkdir("ftp.eoddata.com/Archive/$date/Fundamentals");
	mkdir("ftp.eoddata.com/Archive/$date/Nam es");
	mkdir("ftp.eoddata.com/Archive/$date/Splits");
	mkdir("ftp.eoddata.com/Archive/$date/Technical");
		
	#future- add fundamentals to fundamentals table
	move("ftp.eoddata.com/Fundamentals/*","ftp.eoddata.com/Archive/$date/Fundamentals");
	rmtree("./ftp.eoddata.com/Fundamentals");
	#future- add Names to names table
	move("ftp.eoddata.com/Names/*","ftp.eoddata.com/Archive/$date/Names");
	rmtree("ftp.eoddata.com/Names");
	
	#future- add splits to splits table and process splits on market data
	move("ftp.eoddata.com/Splits/*","ftp.eoddata.com/Archive/$date/Splits");
	rmtree("ftp.eoddata.com/Splits");
	
	#future- add Technical to technical table
	move("ftp.eoddata.com/Technical/*","ftp.eoddata.com/Archive/$date/Technical");
	rmtree("ftp.eoddata.com/Technical");
	
	unlink("ftp.eoddata.com/terms.txt");
	unlink("ftp.eoddata.com/readme.txt");
	rmtree("ftp.eoddata.com/Software");
}

sub insertEODData(){
	my $dbh = DBI->connect('DBI:mysql:markets:localhost',$mySQLUserName,$mySQLPassWord)
		or die "Couldn't connect to database: " . DBI->errstr;
	chdir("ftp.eoddata.com");	
	@files = <*>;
 	foreach (@files) {
 		print "Processing $_\n";
 		if($_ ne "Archive" && $_ ne "History"  ){
 			print "$_ \n";
 			@marketString = split(/_/,$_);
 			open(FH,$_);	
			foreach $line (<FH>) {
				@dataString = split(/,/,$line);
				$query = "INSERT INTO endOfDayData (date,market,symbol,open,high,low,close,volume) values ('@dataString[1]','@marketString[0]','@dataString[0]','@dataString[2]','@dataString[3]','@dataString[4]','@dataString[5]','@dataString[6]')";
       			my $sth = $dbh->prepare($query)
					or die "Couldn't prepare statement: " . $dbh->errstr;
				$sth->execute;
				#print "$sth->errstr\n";	
            	#	or die "Couldn't execute statement: " . $sth->errstr;		 
   			}
   			close(FH);
   			move("$_","./History/$_");
 		}
 	}
 	$dbh->disconnect; 
}
init();
getEODData;
insertEODData;

