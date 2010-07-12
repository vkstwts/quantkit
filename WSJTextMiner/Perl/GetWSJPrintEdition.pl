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

sub init()
    {
     	use Getopt::Long;
        my $opt_string = 'hs=ie=i';
		GetOptions( "s=i" => \$startRetrieveDay, "e=i" => \$endRetrieveDay,"h"  ) or usage();
        usage() if $opt_h;
		usage() unless($startRetrieveDay >= 0);
		usage() unless($endRetrieveDay >=0 );
		if ($startRetrieveDay > $endRetrieveDay){
			print "$startRetrieveDay \n";
			print "$endRetrieveDay \n";
			usage();
		}
    }

sub usage()
    {
    print STDERR << "EOF";

    This script downloads daily print editions of the Wall Street Journal.
    It requires an account with WSJ.  Install the firefox add-on "Cookie Exporter."
    Login to your WSJ account and export your cookies to the directory you are running
    this script in.  The start and end retrieve day parameters tell the script from how many 
    days ago, and then again how many days before that you would like to download the 
    print edition for.  Both parameters are required.

     -h        : this (help) message
     -s        : number of days back to start the download at - required
     -e        : number of days back to end the downloard at - required
     
     The -s parameter must be less than or equal to -e.
    
    example: $0 -s 2 -e 3 -- this will download the print edition from two and three days
    ago(if they exist e.g. no Sunday edition).
EOF
exit;
}

sub getPrintEdition(){
	do ".config";
	
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	my $date = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
	my $myTime = time();
	
	chdir("$BASEDIR");
	mkdir("Data");
	chdir("Data");
	mkdir("Data");
	mkdir("Archive");
	chdir("Data");
	for ($days = $startRetrieveDay; $days <= $endRetrieveDay; $days++){
		
		#get some date accounting out of the way
		print " $days   $startRetrieveDay $endRetrieveDay \n";	
		$backTime = $myTime - ( $days * 24 * 60 * 60 );
		($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime($backTime);
		my $dirDate = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
		mkdir($dirDate);
		chdir($dirDate);

		#new WSJ directory/page naming scheme... much nicer than the old naming system. 
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us/opinion");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us/newyork");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us/marketplace");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us/moneyandinvesting");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/us/personaljournal");


		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/europe");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/europe/opinion");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/europe/moneyandinvesting");

		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/asia");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/asia/opinion");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://online.wsj.com/itp/$dirDate/asia/moneyandinvesting");

		#Extract all hrefs from downloaded main pages to articles.txt
		open (MYFILE, '>>articles.txt');
		@files = <*>;
		foreach (@files) {
			open (FH,$_);
			read (FH,$stuff,-s $_);
			@links = $stuff =~ /href\s*=\s*"?([^"\s>]+)/gis;	
			print (join("\n",@links),"\n");
			for $link (@links) {
				if ($ltab{$link}) {
					#print "DUPLICATE at $link\n";
	    		} else {
		    		$ltab{$link} = 1;
	        		#print "NEW LINK at $link\n";#
		    		print MYFILE "$link\n";
				}
			}
			close(FH);
		}	
		close(MYFILE);

		#grep the particular urls you are looking for into urls.txt and massage for use with wget
		system("grep article/SB articles.txt >> urls.txt");
		system(qq(sed -i 's/http:\\/\\/online.wsj.com//g' urls.txt));
		system(qq(sed -i 's/http:\\/\\/professional.wsj.com//g' urls.txt));
		system(qq(sed -i 's/\\/article\\//http:\\/\\/online.wsj.com\\/article\\//g' urls.txt));

		#download articles as pointed to by urls.txt
		system("wget -v -nc --no-check-certificate --restrict-file-names=windows --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies -i urls.txt");
		
		#extract each article's main body/content and put it in a file named with the date of the print edition currently being worked on. 
		system("chmod +x ../../../Bash/snipDiv.sh");
		@files = <*>;
	 		foreach $file (@files) {
	 			print "Processing $file\n";

	 			if($file =~ /SB/){
	 				#new WSJ naming scheme has an ampersand in it which causes snipDiv.sh to bail... copy files to the innocuously named temp.html before processing. 
	 				system("rm temp.html");
	 				system("cp '$file' temp.html");	 				
		    		system("../../../Bash/snipDiv.sh div#article_story_body temp.html >> $dirDate.txt");
	 			}
		}
		#hop back up the directory tree and start again. 
		chdir("..");
	}
}
init();
getPrintEdition();

#07-07 10:16:16 ERROR 403: Forbidden.
#
#--2010-07-07 10:16:16--  http://online.wsj.com/article/SB40001424052748704862404575350820533772584.html?mod=ITP_pageone_0
#Connecting to online.wsj.com|205.203.132.1|:80... connected.
#HTTP request sent, awaiting response... 302 Found
#Location: http://professional.wsj.com/article/SB40001424052748704862404575350820533772584.html?mod=ITP_pageone_0&mg=reno-wsj [following]
#--2010-07-07 10:16:16--  http://professional.wsj.com/article/SB40001424052748704862404575350820533772584.html?mod=ITP_pageone_0&mg=reno-wsj
#Connecting to professional.wsj.com|205.203.132.104|:80... connected.
#HTTP request sent, awaiting response... 403 Forbidden
#2010-07-07 10:16:17 ERROR 403: Forbidden.
#
#--2010-07-07 10:16:17--  http://online.wsj.com/article/SB10001424052748704103904575336661401293070.html?mod=ITP_TEST
#Connecting to online.wsj.com|205.203.132.1|:80... connected.
#HTTP request sent, awaiting response... 302 Found
#Location: http://professional.wsj.com/article/SB10001424052748704103904575336661401293070.html?mod=ITP_TEST&mg=reno-wsj [following]
#--2010-07-07 10:16:17--  http://professional.wsj.com/article/SB10001424052748704103904575336661401293070.html?mod=ITP_TEST&mg=reno-wsj
#Connecting to professional.wsj.com|205.203.132.104|:80... connected.
#
#

