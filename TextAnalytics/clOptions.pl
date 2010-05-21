#
# Globals
#

sub init()
    {
        use Getopt::Long;
        my $opt_string = 'hp=su=s:';
	GetOptions( "u=s" => \$userName, "p=s" => \$passWord,"h"  ) or usage();
        usage() if $opt_h;
	usage() unless($userName);
	usage() unless($passWord);
    }

sub usage()
    {
    print STDERR << "EOF";

    This program does...

    usage: $0 [-hu:p:] [-f file]

     -h        : this (help) message
     -u        : www.eoddata.com username - required
     -p        : www.eoddata.com password - required

    example: $0 -u myUserName@thismail.com -p myPassWord
EOF
exit;
}
init();







