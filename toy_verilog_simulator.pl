#!/usr/bin/perl -w

# Toy verilog simulator
# written by eelster
# supports:
# - nothing


BEGIN {
    # unshift(@INC,"some_path_i_need") if -e 'some_path_i_need';
}

use Getopt::Long;
use Regexp::Grammars;
use Module::Pluggable require => 1, search_path => "toysim_plugins";
use Data::Dumper;

my $scriptname  = $0;
$scriptname =~ s|.*/||;
my $HELP =  <<ENDHELP

  name:
    $scriptname

  synopsis:
    $scriptname [-debug] [options]

  description:
    Toy Verilog Simulator

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

my $basic_verilog_parser = qr{
   <File>
   <rule: File>          <Module>
   <rule: Module>        module <Modulename> \( <Params> (, <Params>)* \)\; <VariableList> <TimedSection> endmodule
   <rule: Modulename>    <Literal>
   <rule: Params>        <Literal>
   <rule: VariableList>  (<Varible>)*
   <rule: Variable>      (input|output|reg) (\[\d+:\d+\])* <Literal> ;
   <rule: TimedSection>  always \@ begin .* end
   <rule: Literal>       [a-zA-Z0-9_]
   <token: ws>           (?: \s+ | //[^\n]* )*
}xms;

my $verilog_program = "";
while (<>) {
    my $line = $_;
    chomp $line;
    $line =~ s|//.*||;
    $verilog_program .= $line;
}

if ($verilog_program =~ $basic_verilog_parser) {
    print "sucessfully parsed\n";
    Dumper(%/);
}


foreach my $p (@plugs) {
    $p->post_body($relevant_info)
        if $p->can('post_body');
}
