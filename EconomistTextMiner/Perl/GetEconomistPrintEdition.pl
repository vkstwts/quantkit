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

#INSTRUCTIONS: In the data directory create directories with naming convention "YYYYMMDD" for each print edition you wish to download. 

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
	my $dirDate = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
	
	@directoryStructure = <*>;
	foreach (@directoryStructure){
		my $urlExtension = "index.cfm?d=$_";
		my $dirDate = "$_";
		chdir("$_");
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies http://www.economist.com/printedition/$urlExtension");
			
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

		#grep the particular urls you are looking for into urls.txt
		system("grep story_id articles.txt >> urls.txt");
		
		#download articles as pointed to by urls.txt
		system("wget -v -nc --no-check-certificate --load-cookies ../../../Resources/cookies.txt --save-cookies ../../../Resources/cookies.txt --keep-session-cookies -i urls.txt");
		
		#extract each article's main body/content and put it in a file named with the date of the print edition currently being worked on. 
		system("chmod +x ../../../Bash/snipDiv.sh");
		@files = <*>;
	 		foreach $file (@files) {
	 			if($file =~ /story_id/){
	 				print "Processing $file\n";
	 				system("sed -i -e 's/class=\"ec-article-content\"/class=\"ec-article-content\" id=\"minertag\"/g' $file");
		    		system("../../../Bash/snipDiv.sh div#minertag $file >> $dirDate.txt");
	 			}
		}
		#hop back up the directory tree and start again. 
		chdir("..");
	}
}
init();
getPrintEdition();




