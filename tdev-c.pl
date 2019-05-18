#!/usr/bin/perl -w
use FindBin qw($Bin);

if ( $#ARGV < 0) {
    display_help();
    die;
}


$arg = "";

# Create Project
if ( $ARGV[0] eq "create" ) {
    for (my $i = 1; $i <= $#ARGV; $i++) {
        $arg .= " $ARGV[$i]";
    }
    system "perl $Bin/module/PrGen/pgc.pl$arg";
} elsif ( $ARGV[0] eq "open" ) {

} elsif ( $ARGV[0] eq "build" ) {
    system "./build.sh";
} elsif ( $ARGV[0] eq "update" ) {

}



# Help function
sub display_help {
    print "";
    print "Usage: termide-c [command] [arg0] [arg1] ....\n";
    print "Possible commands\n";
    print "---------------------------------------------\n";
    print "create                   Create new project\n";
    print "open                     Open project\n";
}
