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
        my $opt_string = 'hp=su=s:';
		GetOptions( "u=s" => \$userName, "p=s" => \$passWord, "b=i" => \$daysBack,"h"  ) or usage();
        usage() if $opt_h;
		usage() unless($userName);
		usage() unless($passWord);
		usage() unless($daysBack);
    }

sub usage()
    {
    print STDERR << "EOF";

    This program does...

    usage: $0 [-hu:p:] [-f file]

     -h        : this (help) message
     -u        : wsj.com username - required - sub in "%40" for "@" sign for proper URL encoding 
     -p        : wsj.com password - required
     -b		   : number of days back to grab the printed edition for - require 

    example: $0 -u myUserName@thismail.com -p myPassWord -b 110
EOF
exit;
}
init();

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
my $date = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
mkdir($date);
chdir($date);

my $authLoginPage = "https://commerce.wsj.com/auth/submitlogin";
system("wget -v -nc --no-check-certificate --save-cookies ../cookies.txt --keep-session-cookies --post-data 'user=$userName&regSource=defloginsub3&tourSource=deflogintour3&lpe=DEFAULT&password=$passWord&savelogin=on' $authLoginPage");
system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0133.html");
system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0134.html");
system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0135.html");

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
		close(FH);
	}
}
close(MYFILE);
system("grep mod=today articles.txt > urls.txt");
system(qq(sed -i 's/\\/article\\//http:\\/\\/professional.wsj.com\\/article\\//g' urls.txt));
system("wget -v -nc --no-check-certificate --load-cookies cookies.txt --save-cookies cookies.txt --keep-session-cookies -i urls.txt");

@files = <*>;
foreach $file (@files) {
	print $file . "\n";
	if($file =~ /.html/){
		system("../PruneArticleDiv.sh div#article_story_body $file >> $date.txt")
	}
} 

for ($days =1; $days <= $daysBack; $days++){
	chdir("..");
	$backTime = time() - ( $days * 24 * 60 * 60 );
	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime($backTime);
	my $date = sprintf '%02d%02d%02d', $Year+1900,, $Month +1 , $Day;
	mkdir($date);
	chdir($date);
	open (MYFILE, '>>articles.txt');
	system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0333-$date.html");
	system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0334-$date.html");
	system("wget -v -nc --no-check-certificate --load-cookies ../cookies.txt --save-cookies ../cookies.txt --keep-session-cookies http://online.wsj.com/page/2_0335-$date.html");
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
	system("grep mod=today articles.txt > urls.txt");
	system(qq(sed -i 's/\\/article\\//http:\\/\\/professional.wsj.com\\/article\\//g' urls.txt));
	system("wget -v -nc --no-check-certificate --load-cookies cookies.txt --save-cookies cookies.txt --keep-session-cookies -i urls.txt");
	
	@files = <*>;
	foreach $file (@files) {
		print $file . "\n";
		if($file =~ /.html/){
			system("../PruneArticleDiv.sh div#article_story_body $file >> $date.txt")
		}
	} 
}

