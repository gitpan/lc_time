#! perl -w
use strict;
use utf8;
use Encode;

use Test::More;

use POSIX ();
require lc_time;

my %test = (
    en_US => {
        lang    => 'English',
        lc_time => 'en_US',
        win32   => 'English_United States',
        expect  => qr/^March Mar\.?$/,
    },
    nl_NL => {
        lang    => 'Dutch',
        lc_time => 'nl_NL',
        win32   => 'Dutch_Netherlands',
        expect  => qr/^maart mrt\.?$/,
    },
    de_DE => {
        lang    => 'German',
        lc_time => 'de_DE',
        win32   => 'German_Germany',
        expect  => qr/^März (?:März?|Mrz)\.?$/,
    },
    gd_GB => {
        lang    => 'Gaelic',
        lc_time => 'gd_GB',
        win32   => '',
        expect  => qr/^Am Màrt Màr\.?$/,
    },
    pt_PT => {
        lang    => 'Portuguese',
        lc_time => 'pt_PT',
        win32   => 'Portuguese_Portugal',
        expect  => qr/^Março Mar\.?$/,
    },
    ru_RU => {
        lang    => 'Russian',
        lc_time => 'ru_RU',
        win32   => 'Russian_Russia',
        expect  => qr/^[мМ]арта? [мМ]ар(?:та?)?$/i,
    },
    uk_UA => {
        lang    => 'Ukraenian',
        lc_time => 'uk_UA',
        win32   => 'Ukrainian_Ukraine',
        expect  => qr/^(?:[бБ]ерезня|[бБ]ерезень) [бБ]ер\.?$/,
    },
);

my @locale_avail;
chomp(@locale_avail = qx/locale -a/) if $^O ne 'MSWin32';

binmode(STDOUT, ':encoding(utf8)');

my $first_lc_time = POSIX::setlocale(lc_time::MY_LC_TIME());
note("Default LC_TIME: $first_lc_time");

for my $lc (keys %test) {
    SKIP: {
        my ($first_lc) = grep /^$test{$lc}{lc_time}/, @locale_avail;
        $first_lc = $test{$lc}{win32} if $^O eq 'MSWin32';
        if (!$first_lc) {
            skip("No locale for $test{$lc}{lang} ($test{$lc}{lc_time})", 1);
        }

        note("Testing with $lc == $first_lc");
        my $prog = << "        EOP";
use warnings;
use strict;
use lc_time '$first_lc';
strftime('%B %b', 0, 0, 0, 1, 2, 2013);
        EOP
        my $t = eval $prog;
BAIL_OUT "$@" if $@;

        like($t, $test{$lc}{expect}, encode('utf-8', "$test{$lc}{lang}: $t"));
    }
}

my $curr_lc_time = POSIX::setlocale(lc_time::MY_LC_TIME());
is($curr_lc_time, $first_lc_time, "LC_TIME reverted to $curr_lc_time");

done_testing();
