use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'String::OrderedCombination',
    'VERSION_FROM'	=> 'OrderedCombination.pm',
    'PREREQ_PM'         => { Test },
    ($] >= 5.005 ? () : (
       ABSTRACT_FROM 	=> 'OrderedCombination.pm', 
       AUTHOR     	=> 'Dree Mistrut <dree@friul.it>' 
    )),
);
