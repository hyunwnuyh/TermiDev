#!/usr/bin/perl -w
use FindBin qw($Bin);
use Cwd qw(getcwd);

if ( $#ARGV < 0) {
    display_help();
    die "\n";
}


$arg = "";

if ( $ARGV[0] eq "create" ) {

    # Create Project
    for (my $i = 1; $i <= $#ARGV; $i++) {
        $arg .= " $ARGV[$i]";
    }
    system "perl $Bin/module/PrGen/pgc.pl$arg";
} elsif ( $ARGV[0] eq "open" ) {

    # Open Project
    # TODO
} elsif ( $ARGV[0] eq "build" ) {

    # Build Project
    if (-f "build.sh") {
        system "./build.sh";
    } else {
        print "Error: No build script in path (".getcwd.")\n";
    }
} elsif ( $ARGV[0] eq "config" ) {

    # tdev-c Settings
} elsif ( $ARGV[0] eq "pconfig" ) {

    # Project Settings
} elsif ( $ARGV[0] eq "update" ) {
    
    # Update TermiDev
    chdir $Bin;
    system "./update.sh";
} elsif ( $ARGV[0] eq "template" ) {

    # Template manager
    for (my $i = 1; $i <= $#ARGV; $i++) {
        $arg .= " $ARGV[$i]";
    }
    system "perl $Bin/module/PrGen/pgtmgr.pl c $arg";
} else {

    # Display Help
    display_help();
    die "\n";
}



# Help function
sub display_help {
    print "\n";
    print "Usage: tdev-c [command] [arg0] [arg1] ....\n";
    print "Possible commands\n";
    print "---------------------------------------------\n";
    print "create                   Create new project\n";
    print "open                     Open project\n";
    print "build                    Build project\n";
    print "settings                 Configure TermiDev-C\n";
    print "psettings                Configure Project settings\n";
    print "update                   Update TermiDev-C\n";
}
