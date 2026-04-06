use strict;
use warnings;
use Test::More;
use Date::Language;

my $time = time;

my @lang = qw(
    Afar Amharic Arabic Austrian Brazilian Bulgarian
    Chinese Chinese_GB Czech Danish Dutch English
    Finnish French Gedeo German Greek Hungarian
    Icelandic Italian Norwegian Occitan Oromo
    Portuguese Romanian Russian Russian_cp1251
    Russian_koi8r Sidama Somali Spanish Swedish
    Tigrinya TigrinyaEritrean TigrinyaEthiopian Turkish
);

for my $lang (@lang) {
    my $l = Date::Language->new($lang);
    my $str = $l->ctime($time);
    my $parsed = $l->str2time($str);
    is($parsed, $time, "$lang: round-trip ctime/str2time");
}

done_testing;
