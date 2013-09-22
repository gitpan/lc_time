#! perl -w
use v5.10.1;
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
    ABSTRACT_FROM => 'lib/lc_time.pm',
    NAME          => 'lc_time',
    VERSION_FROM  => 'lib/lc_time.pm',

    PREREQ_PM => {
        'Encode' => 0,
        'POSIX'  => 0,
        'parent' => 0,
    },

    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 6.56,
    },

    BUILD_REQUIRES => {
        'Test::More'       => 0.96,
        'Test::NoWarnings' => 0,
    },
);
