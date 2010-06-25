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
use File::Copy;

sub init()
    {
#     	use Getopt::Long;
#        my $opt_string = 'hs=ie=i';
#		GetOptions( "s=i" => \$startRetrieveDay, "e=i" => \$endRetrieveDay,"h"  ) or usage();
#        usage() if $opt_h;
#		usage() unless($startRetrieveDay >= 0);
#		usage() unless($endRetrieveDay >=0 );
#		if ($startRetrieveDay > $endRetrieveDay){
#			print "$startRetrieveDay \n";
#			print "$endRetrieveDay \n";
#			usage();
#		}
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

sub getCorpus(){
	do ".config";
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
	my $date = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
	
	my $myTime = time();
	chdir($BASEDIR);
    mkdir("Corpus");
    chdir("Corpus");
    mkdir("Corpus");
    mkdir("Archive");
    chdir("../Data/Data");
	@files = <*>;
	foreach $file (@files) {
		if($file =~ /2010/){
			print "copying $file.txt to the Corpus and moving data dir $file to Archive\n";
	    	copy("$file/$file.txt","../../Corpus/Corpus/$file.txt");
	    	move("$file","../Archive/$file");
		}		
	}
}
init();
getCorpus();




