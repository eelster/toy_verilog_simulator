#!/usr/bin/perl -w

# Script description
# copyright

BEGIN {
    unshift(@INC,"some_path_i_need") if -e 'some_path_i_need';
}

use Getopt::Long;
use Module::Pluggable require => 1, search_path => "my_script_plugins";

my $scriptname  = $0;
$scriptname =~ s|.*/||;
my $HELP =  <<ENDHELP

  name:
    $scriptname

  synopsis:
    $scriptname [-debug] [options]

  description:
    A script to ... 

  options:
    -debug           enable debug
    -help            print out this help message

ENDHELP
;


my $debug = 0;
GetOptions("debug"   => \$debug,
           "help"      => sub {print $HELP; exit(1)},
    );

my @plugs = plugins();

foreach my $p (@plugs) {
    $p->pre_body($relevant_info)
        if $p->can('pre_body');
}

# do something

foreach my $p (@plugs) {
    $p->post_body($relevant_info)
        if $p->can('post_body');
}
