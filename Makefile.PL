use 5.008001;
use strict;
use warnings;

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Mega::Cli',
    LICENSE           => 'perl_5',
    AUTHOR            => 'Pavel Andryushin',
    VERSION_FROM      => 'lib/Mega/Cli.pm', 
    PREREQ_PM         => {
        'File::Spec'        => 3.48_01,
        'Lock::Socket'      => 0.0.6,
        'File::Basename'    => 2.85,
    },
    META_MERGE   => {
          requires  => { perl => '5.008008' },
          resources => {
                license     => 'http://dev.perl.org/licenses/',
                repository  => 'https://github.com/vrag86/perl-mega-cli.git',
                bugtracker  => 'https://github.com/vrag86/perl-mega-cli.git/issues'
              },
        },
    AUTHOR            => 'vrag <vrag867@gmail.com>',
    LICENSE           => 'perl',
);
