use strict;
use Test;
BEGIN { plan tests => 1 };

use String::OrderedCombination qw(ocombination);

ok(1); 
my @array=ocombination("foo",2);

my $string;

foreach (@array) { $string.= $_ }
if ($string eq 'offooffooooo') {ok(1)} else {ok(0)}

@array=ocombination("bar",3);

$string='';
foreach (@array) { $string.= $_ }

if ($string eq 'abrarbrabrbabrabar') {ok(1)} else {ok(0)}

@array=ocombination("",1);
if ((!@array) and $String::OrderedCombination::err eq 'length(string) must be an integer greater than 0') {ok(1)} else {ok(0)}

@array=ocombination("bar",0);
if ((!@array) and $String::OrderedCombination::err eq 'k must be an integer greater than 0') {ok(1)} else {ok(0)}

@array=ocombination("bar",-1);
if ((!@array) and $String::OrderedCombination::err eq 'k must be an integer greater than 0') {ok(1)} else {ok(0)}

@array=ocombination("bar",4);
if ((!@array) and $String::OrderedCombination::err eq 'k must be less than or equal to length(string)') {ok(1)} else {ok(0)}


