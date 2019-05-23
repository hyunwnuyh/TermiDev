#!/usr/bin/perl -w
use FindBin qw($Bin);
use Cwd qw(getcwd);
use File::Path qw(make_path);
use File::Find qw(finddepth);
use File::Copy qw(copy);

# Argument check
if ($#ARGV < 0) {
    help();
    die;
}

$dir = getcwd;
$std = "c99";
$flag = 0;
@templates = ();

$i = 0;
for (; $i < $#ARGV + 1; $i++) {
    $c = substr $ARGV[$i], 0, 1;
    if ($c eq "-") {
        $opt = substr $ARGV[$i], 1;
        if ($opt eq "c11") {
            $std = "c11";
        } elsif ($opt eq "h") {
            help();
            die;
        }
    } else {
        $dir .= "/$ARGV[$i]";
        $flag = 1;
        last;
    }
}
if (! $flag) {
    help();
    die;
}

# Ask for overwriting existing directory
if (-d $dir) {
    print "Directory already exists($dir). Do you want to proceed? (y/n) :";
    $key = substr <STDIN>, 0, 1;
    die if ($key eq "n");

    while (not ($key eq "y")) {
        print "Please answer by y or n: ";
        $key = substr <STDIN>, 0, 1;
        die if ($key eq "n");
    }
} else {
    make_path $dir;
}

# Get project template from  list-c and print
print "\nCurrent templates list\n";
print "------------------------------\n";
open LIST, "<$Bin/template/.list-c";
$j = 0;
while ($line = <LIST>) {
    $line =~ s/\n//g;
    push @templates, $line;
    open TEMP, "<$Bin/template/$line/.template";
    print "$j: " . substr(<TEMP>, 5);
    close TEMP;
    $j++;
}
close LIST;
print "------------------------------\n";

$j--;
print "Select project template(0 - $j): ";
$key = substr <STDIN>, 0, -1;
if ($key =~ /^-?\d+$/) {
    $key = $key * 1;
    if ($key <= $j && $key >= 0) {
        $flag = 0;
    }
}
while ($flag) {
    print "Please answer in degree (0 - $j): ";
    $key = substr <STDIN>, 0, -1;
    if ($key =~ /^-?\d+$/) {
        $key = $key * 1;
        if ($key <= $j && $key >=0 ) {
            last;
        }
    }
}

# Copy template files 
File::Find::find(sub {
        $file = $File::Find::name;
        if (-e $file) {
            print "$file\n";
            if (-f $file) {
                if (!(substr($file, rindex($file, "/") + 1, 1) eq ".")) {
                    $str = substr $file, length("$Bin/template/$templates[$key]");
                    print "Copy $file to $dir$str\n";
                    copy($file, "$dir$str");
                }
            } elsif (-d $file) {
                $str = substr $file, length("$Bin/template/$templates[$key]");
                print "Create directory $dir$str\n";
                make_path("$dir$str");
            }
        }
    }, "$Bin/template/$templates[$key]" );

open CML, "<$Bin/template/$templates[$key]/CMakeLists.txt";
open OUT, ">$dir/CMakeLists.txt";
while ($line = <CML>) {
    $line =~ s/<proj_name>/$ARGV[$i]/g;
    if ($std eq "c99") {
        $line =~ s/<std>/99/g;
    } elsif($std eq "c11") {
        $line =~ s/<std>/11/g;
    }
    print OUT $line;
}
close CML;
close OUT;

# Create build script
open OUT, ">$dir/build.sh";
print OUT "#!/bin/bash\n";
print OUT "cmake -Bbuild -H.\n";
print OUT "cd build\n";
print OUT "make\n";
close OUT;
chmod 0777, "$dir/build.sh";

# Help function
sub help {
    print "\n";
    print "Usage : tdev-c create [-option -option ...] input\n";
    print "\n";
    print "Possible options\n";
    print "-------------------------------------\n";
    print "c99            C99 standard (default)\n";
    print "c11            C11 standard\n";
    print "h              help (ignore other opts)\n";
    print "\n";
}

