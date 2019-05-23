#!/usr/bin/perl -w
use FindBin qw($Bin);
use Cwd qw(getcwd);
use File::Path qw(make_path);
use File::Find qw(finddepth);
use File::Copy qw(copy);


if ($#ARGV < 1) {
    help();
    die "\n";
}

$lang = "";
if ($ARGV[0] eq "c") {
    $lang = "c";
}

if ($ARGV[1] eq "add") {
    # Add to template list
    if ($#ARGV < 2) {
        help();
        die "\n";
    }
    $dir = getcwd;
    $dir .= "/$ARGV[2]" if (not $ARGV[2] eq ".");
    $dest = "$Bin/template/";
    $fold = substr $dir, rindex($dir, "/") + 1;
    print "Set destination folder (default is $fold) : ";
    $in = substr <STDIN>, 0, -1;
    if (not $in eq "") {
        $fold = $in;
    }
    $dest .= $fold;
    $name = $fold;
    print "Set template name (default is $name) : ";
    $in = substr <STDIN>, 0, -1;
    if (not $in eq "") {
        $name = $in;
    }
    
    print "Copying $dir directory to $dest\n";
    system "cp -r $dir $dest";
    if (-d "$dest/build") {
        system "rm -rf $dest/build";
    }

    print "create .template in $dest\n";
    open TEMP, ">$dest/.template";
    print TEMP "name=$name\n";
    close TEMP;
    
    print "Add $fold to .list-$lang\n";
    open LIST, ">>$Bin/template/.list-$lang";
    print LIST "$fold\n";
    close LIST;

    print "Modify $fold/CMakeLists.txt\n";
    open CMLI, "<$dir/CMakeLists.txt";
    open CMLO, ">$dest/CMakeLists.txt";
    while ($line = <CMLI>) {
        if ($line =~ m"CMAKE_C_STANDARD") {
            $line = "set ( CMAKE_C_STANDARD <std> )\n";
        } elsif ($line =~ m"set\s\(\sPROJECT_NAME") {
            $line = "set ( PROJECT_NAME <proj_name> )\n";
        } elsif ($line =~ m"add_executable" || $line =~ m"add_library") {
            $line =~ s"\(\s+\w+\s+"( <proj_name> ";
        } 

        print CMLO "$line";
    }
    close CMLO;
    close CMLI;

} elsif ($ARGV[1] eq "remove") {
    # Remove template
    ($n, $tlist) = print_tlist();
    print "Select template index to remove (0 - $n) : ";
    $key = getindex(0, $n);
    open LIST, ">$Bin/template/.list-$lang";
    for (my $i = 0; $i <= $#$tlist; $i++) {
        print LIST "$$tlist[$i]\n" if ($i != $key);
    }
    close LIST;
    system "rm -rf $Bin/template/$$tlist[$key]";
} elsif ($ARGV[1] eq "modify") {
    # Modify template
    ($n, $tlist) = print_tlist();
    print "Select template index to modify info (0 - $n) : ";
    $key = getindex(0, $n);
    @list = get_tinfo($$tlist[$key]);
    while (1) {
        print "\n";
        print "Template info\n";
        print "-----------------------------------------------\n";
        print "(0)Name = $list[0]\n";
        print "-----------------------------------------------\n";
        print "(-1) Save changes and exit\n";
        print "(-2) Exit without saving\n";
        print "Select index to modify : ";
        $index = getindex(-2, 0);
        if ($index == -2) {
            die "Exit without saving...\n";
        } elsif ($index == -1) {
            open TEMP, ">$Bin/template/$$tlist[$key]/.template";
            print TEMP "name=$list[0]\n";
            close TEMP;
            die "All changes saved.\n";
        } else {
            print "Write modified text : ";
            $list[$index] = substr <STDIN>, 0, -1;
        }
    }
} elsif ($ARGV[1] eq "list") {
    # Show list
    print_tlist();
} elsif ($ARGV[1] eq "help") {
    help();
}

sub get_tinfo {
    open TEMP, "<$Bin/template/$_[0]/.template";
    $name = substr(<TEMP>, 5, -1);
    close TEMP;
    return $name;
}

sub print_tlist {
    our @templist = ();
    print "\n";
    print "Current templates list\n";
    print "-----------------------------------------------\n";
    $j = 0;
    open LIST, "<$Bin/template/.list-$lang";
    while ($line = <LIST>) {
        $line =~ s/\n//g;
        push @templist, $line;
        ($name) = get_tinfo($line);
        print "$j: " . $name . " ($line)\n";
        $j++;
    }
    close LIST;
    print "-----------------------------------------------\n\n";
    return $j - 1, \@templist;
}

sub getindex {
    $flag = 1;
    $key = substr <STDIN>, 0, -1;
    if ($key =~ /^-?\d+$/) {
        $key = $key * 1;
        if ($key <= $_[1] && $key >= $_[0]) {
            $flag = 0;
        }
    }
    while ($flag) {
        print "Please answer in degree ($_[0] - $_[1]): ";
        $key = substr <STDIN>, 0, -1;
        if ($key =~ /^-?\d+$/) {
            $key = $key * 1;
            if ($key <= $_[1] && $key >=$_[0]) {
                last;
            }
        }
    }
    return $key;
}

sub help {
    print "\n";
    print "Usage 1 : tdev-[lang] template add inputdir\n";
    print "Usage 2 : tdev-[lang] template [command]\n";
    print "\n";
    print "Possible commands\n";
    print "-----------------------------------------------\n";
    print "add              add directory to templates\n";
    print "remove           remove template\n";
    print "modify           modify template information\n";
    print "list             show templates list\n";
    print "help             help\n";
    print "-----------------------------------------------\n";
}

