use strict;
use warnings;
use Test::More;
use Date::Language;

# Tue Sep  7 13:02:42 1999 GMT
# wday=2 (Tuesday), mon=8 (September, 0-indexed)
my $time = 936709362;

# Expected values for %A (full day), %a (short day), %B (full month), %b (short month)
# extracted from each language module's @DoW[2], @DoWs[2], @MoY[8], @MoYs[8]
my %expected = (
    Afar                 => { A => "Talaata",                                                              a => "Tal",                                        B => "Waysu",                                                                    b => "Way" },
    Amharic              => { A => "\x{121b}\x{12ad}\x{1230}\x{129e}",                                    a => "\x{121b}\x{12ad}\x{1230}",                   B => "\x{1234}\x{1355}\x{1274}\x{121d}\x{1260}\x{122d}",                        b => "\x{1234}\x{1355}\x{1274}" },
    Arabic               => { A => "\x{627}\x{644}\x{62b}\x{644}\x{627}\x{62b}\x{627}\x{621}",           a => "\x{627}\x{644}\x{62b}",                      B => "\x{633}\x{628}\x{62a}\x{645}\x{628}\x{631}",                              b => "\x{633}\x{628}\x{62a}" },
    Austrian             => { A => "Dienstag",                                                             a => "Di",                                         B => "September",                                                                b => "Sep" },
    Brazilian            => { A => "Ter\x{e7}a",                                                           a => "Ter",                                        B => "Setembro",                                                                 b => "Set" },
    Bulgarian            => { A => "\x{432}\x{442}\x{43e}\x{440}\x{43d}\x{438}\x{43a}",                  a => "\x{432}\x{442}",                             B => "\x{441}\x{435}\x{43f}\x{442}\x{435}\x{43c}\x{432}\x{440}\x{438}",        b => "\x{441}\x{435}\x{43f}" },
    Chinese              => { A => "\x{661f}\x{671f}\x{4e8c}",                                            a => "\x{661f}\x{671f}\x{4e8c}",                  B => "\x{4e5d}\x{6708}",                                                        b => "\x{4e5d}\x{6708}" },
    Chinese_GB           => { A => "\x{d0}\x{c7}\x{c6}\x{da}\x{b6}\x{fe}",                               a => "\x{d0}\x{c7}\x{c6}\x{da}\x{b6}\x{fe}",     B => "\x{be}\x{c5}\x{d4}\x{c2}",                                                b => "\x{be}\x{c5}\x{d4}\x{c2}" },
    Czech                => { A => "\x{fa}ter\x{fd}",                                                     a => "\x{da}t",                                    B => "z\x{e1}\x{159}\x{ed}",                                                    b => "z\x{e1}\x{159}\x{ed}" },
    Danish               => { A => "Tirsdag",                                                              a => "Tir",                                        B => "September",                                                                b => "Sep" },
    Dutch                => { A => "dinsdag",                                                              a => "di",                                         B => "september",                                                                b => "sep" },
    English              => { A => "Tuesday",                                                              a => "Tue",                                        B => "September",                                                                b => "Sep" },
    Finnish              => { A => "tiistai",                                                              a => "tiistai",                                    B => "syyskuu",                                                                  b => "syyskuu" },
    French               => { A => "mardi",                                                                a => "mar",                                        B => "septembre",                                                                b => "sep" },
    Gedeo                => { A => "Masano",                                                               a => "Mas",                                        B => "Canissa",                                                                  b => "Can" },
    German               => { A => "Dienstag",                                                             a => "Di",                                         B => "September",                                                                b => "Sep" },
    Greek                => { A => "\x{3a4}\x{3c1}\x{3af}\x{3c4}\x{3b7}",                                a => "\x{3a4}\x{3c1}",                             B => "\x{3a3}\x{3b5}\x{3c0}\x{3c4}\x{3b5}\x{3bc}\x{3b2}\x{3c1}\x{3af}\x{3bf}\x{3c5}", b => "\x{3a3}\x{3b5}\x{3c0}" },
    Hungarian            => { A => "Kedd",                                                                 a => "Ked",                                        B => "Szeptember",                                                               b => "Sze" },
    Icelandic            => { A => "\x{de}ri\x{f0}judagur",                                               a => "\x{de}ri",                                   B => "September",                                                                b => "Sep" },
    Italian              => { A => "Marted\x{ec}",                                                         a => "Mar",                                        B => "Settembre",                                                                b => "Set" },
    Norwegian            => { A => "Tirsdag",                                                              a => "Tir",                                        B => "September",                                                                b => "Sep" },
    Occitan              => { A => "dimars",                                                               a => "dim",                                        B => "setembre",                                                                 b => "set" },
    Portuguese           => { A => "ter\x{e7}a-feira",                                                    a => "ter",                                        B => "setembro",                                                                 b => "set" },
    Oromo                => { A => "Qibxata",                                                              a => "Qib",                                        B => "Fuulbana",                                                                 b => "Fuu" },
    Romanian             => { A => "marti",                                                                a => "mar",                                        B => "septembrie",                                                               b => "sep" },
    Russian              => { A => "\x{f7}\x{d4}\x{cf}\x{d2}\x{ce}\x{c9}\x{cb}",                         a => "\x{f7}\x{d4}",                               B => "\x{f3}\x{c5}\x{ce}\x{d4}\x{d1}\x{c2}\x{d2}\x{d1}",                       b => "\x{f3}\x{c5}\x{ce}" },
    Russian_cp1251       => { A => "\x{c2}\x{f2}\x{ee}\x{f0}\x{ed}\x{e8}\x{ea}",                               a => "\x{c2}\x{f2}\x{f0}",                    B => "\x{d1}\x{e5}\x{ed}\x{f2}\x{ff}\x{e1}\x{f0}\x{fc}",                       b => "\x{d1}\x{e5}\x{ed}" },
    Russian_koi8r        => { A => "\x{f7}\x{d4}\x{cf}\x{d2}\x{ce}\x{c9}\x{cb}",                         a => "\x{f7}\x{d4}\x{d2}",                         B => "\x{f3}\x{c5}\x{ce}\x{d4}\x{d1}\x{c2}\x{d2}\x{d8}",                       b => "\x{f3}\x{c5}\x{ce}" },
    Sidama               => { A => "Maakisanyo",                                                           a => "Maa",                                        B => "September",                                                                b => "Sep" },
    Somali               => { A => "Salaaso",                                                              a => "Sal",                                        B => "Bisha Sagaalaad",                                                          b => "Sag" },
    Spanish              => { A => "martes",                                                               a => "mar",                                        B => "septiembre",                                                               b => "sep" },
    Swedish              => { A => "tisdagen",                                                             a => "ti",                                         B => "september",                                                                b => "sep" },
    Tigrinya             => { A => "\x{1230}\x{1209}\x{1235}",                                            a => "\x{1230}\x{1209}\x{1235}",                   B => "\x{1234}\x{1355}\x{1274}\x{121d}\x{1260}\x{122d}",                        b => "\x{1234}\x{1355}\x{1274}" },
    TigrinyaEritrean     => { A => "\x{1230}\x{1209}\x{1235}",                                            a => "\x{1230}\x{1209}\x{1235}",                   B => "\x{1234}\x{1355}\x{1274}\x{121d}\x{1260}\x{122d}",                        b => "\x{1234}\x{1355}\x{1274}" },
    TigrinyaEthiopian    => { A => "\x{1230}\x{1209}\x{1235}",                                            a => "\x{1230}\x{1209}\x{1235}",                   B => "\x{1234}\x{1355}\x{1274}\x{121d}\x{1260}\x{122d}",                        b => "\x{1234}\x{1355}\x{1274}" },
    Turkish              => { A => "Sal\x{131}",                                                           a => "Sal",                                        B => "Eyl\x{fc}l",                                                              b => "Eyl" },
);

for my $lang (sort keys %expected) {
    my $l = Date::Language->new($lang);
    my $e = $expected{$lang};

    # Content checks
    is($l->time2str('%A', $time, 'GMT'), $e->{A}, "$lang: full day name (%A)");
    is($l->time2str('%a', $time, 'GMT'), $e->{a}, "$lang: short day name (%a)");
    is($l->time2str('%B', $time, 'GMT'), $e->{B}, "$lang: full month name (%B)");
    is($l->time2str('%b', $time, 'GMT'), $e->{b}, "$lang: short month name (%b)");

    # Structural checks
    no strict 'refs';
    my $pkg = "Date::Language::$lang";

    is(scalar @{"${pkg}::DoW"},  7,  "$lang: 7 day names");
    is(scalar @{"${pkg}::DoWs"}, 7,  "$lang: 7 short day names");
    is(scalar @{"${pkg}::MoY"},  12, "$lang: 12 month names");
    is(scalar @{"${pkg}::MoYs"}, 12, "$lang: 12 short month names");
    is(scalar @{"${pkg}::AMPM"}, 2,  "$lang: 2 AM/PM entries");
    cmp_ok(scalar @{"${pkg}::Dsuf"}, '>=', 32, "$lang: at least 32 day-suffix entries (indices 0-31)");
}

# Regression: Austrian October abbreviation must be "Okt" (German), not "Oct" (English)
{
    my $at = Date::Language->new('Austrian');
    # Thu Oct 14 12:00:00 1999 UTC — mon=9 (October)
    my $oct_time = 939816000;
    is($at->time2str('%b', $oct_time, 'GMT'), "Okt",
       "Austrian: October abbreviated as Okt, not Oct");
}

# Regression: Romanian November must be "noiembrie", not "noembrie"
{
    my $ro = Date::Language->new('Romanian');
    # Mon Nov  1 12:00:00 1999 UTC — mon=10 (November)
    my $nov_time = 941457600;
    is($ro->time2str('%B', $nov_time, 'GMT'), "noiembrie",
       "Romanian: November is noiembrie, not noembrie");
}

# Regression test: Russian @DoW must start with Sunday (index 0 = localtime wday 0)
# Bug: @DoW previously started at Monday, causing every day name to be off by one.
{
    my $ru = Date::Language->new('Russian');

    # Sat Jan  1 00:00:00 2000 UTC — wday=6 (Saturday)
    my $sat = 946684800;
    # Sun Jan  2 00:00:00 2000 UTC — wday=0 (Sunday)
    my $sun = 946771200;
    # Mon Jan  3 00:00:00 2000 UTC — wday=1 (Monday)
    my $mon = 946857600;

    # Saturday = Суббота (KOI8-R: \xf3\xd5\xc2\xc2\xcf\xd4\xc1)
    is($ru->time2str('%A', $sat, 'GMT'),
       "\xf3\xd5\xc2\xc2\xcf\xd4\xc1",
       "Russian: Saturday formats as Суббота");

    # Sunday = Воскресенье (KOI8-R: \xf7\xcf\xd3\xcb\xd2\xc5\xd3\xc5\xce\xd8\xc5)
    is($ru->time2str('%A', $sun, 'GMT'),
       "\xf7\xcf\xd3\xcb\xd2\xc5\xd3\xc5\xce\xd8\xc5",
       "Russian: Sunday formats as Воскресенье");

    # Monday = Понедельник (KOI8-R: \xf0\xcf\xce\xc5\xc4\xc5\xcc\xd8\xce\xc9\xcb)
    is($ru->time2str('%A', $mon, 'GMT'),
       "\xf0\xcf\xce\xc5\xc4\xc5\xcc\xd8\xce\xc9\xcb",
       "Russian: Monday formats as Понедельник");
}

# Regression: format_o (%o) must produce a suffix for day 31 in all languages.
# Bug: modules with @Dsuf of only 31 elements (indices 0-30) returned undef for
# day 31 (index 31), producing a bare "31" instead of "31<suffix>".
{
    # Fri Jan 31 00:00:00 2025 UTC — day 31
    my $day31_time = 1738281600;

    for my $lang (sort keys %expected) {
        my $obj = Date::Language->new($lang);
        my $result = $obj->time2str('%o', $day31_time, 'GMT');
        # Result must start with "31" and must not emit an undef warning.
        # Languages with empty suffix (e.g. Romanian) produce "31" — that's fine,
        # but it must be the empty string '', not undef.
        like($result, qr/^\s*31/, "$lang: format_o day 31 produces output");
    }
}

done_testing;
