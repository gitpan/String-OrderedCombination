package String::OrderedCombination;

use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
ocombination
);
our $VERSION = '0.04';

bootstrap String::OrderedCombination $VERSION;

1;
__END__

=head1 NAME

String::OrderedCombination - An algorithm to calculate all the strings resulting from an ordered combination of k characters from n characters available.

=head1 SYNOPSIS

 use String::OrderedCombination qw(ocombination);

 my @array=ocombination("foo",2);

 print "$_ " foreach (@array);

 #prints of fo of fo oo oo 


 my @array=ocombination("bar",3);

 print "$_ " foreach (@array);

 #prints abr arb rab rba bra bar 


=head1 DESCRIPTION

From a set of n elements, given an integer k, the algorithm calculates 
k! * n!/(k!(n-k)!) elements that are all the ordered combinations of k elements 
from the set of n elements. I.e. the permutation x combination cross product 
for any given k < n.

The combination function needs a string (every character is an element of the set 
of n=length(string) elements) and an integer value that is k.

The function returns a list of values.

If the function returns an empty list, an error has occured and you can retrive its 
description from $String::OrderedCombination::err .


=head1 Thanks

Thanks to Allen Day <F<allenday atsign ucla dotsign edu>> to point me about the 
ordered type of combination this module performs.


=head1 AUTHORS

The C algorithm and code is by Andrea Gasparri, the XS glue is by Dree Mistrut with a help 
from dada <F<dada atsign perl dotsign it>>.

Copyright 2004,2005 Andrea Gasparri <F<andrea atsign slack dotsign z00 dotsign it>> and 
Dree Mistrut <F<dree atsign friul dotsign it>>.

Mantainer of the code is Davide Bergamini, <F<davidebe75 atsign yahoo dotsign it>> under the authorization
of Dree Mistrut <F<dree atsign friul dotsign it>>.

This package is free software and is provided "as is" without express
or implied warranty.  You can redistribute it and/or modify it under 
the same terms as Perl itself.

=cut
