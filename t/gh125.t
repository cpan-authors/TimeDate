use strict;
use warnings;
use Test::More tests => 8;
use Date::Parse qw(str2time strptime);

# GH#125: Date::Parse 2.34_02+ incorrectly accepts invalid dates like
# 'September 34, 1984'.  The GH#2 fix changed the month+number regex so
# that any number > 31 following a month name is treated as a year.  When
# a four-digit year also appears in the string (e.g. ", 1984"), the
# out-of-range number (34) was captured as a two-digit year (34 -> 2034),
# the real year (1984) was left unconsumed but ignored because $year was
# already set, and $day was filled from the current date — producing a
# spurious valid timestamp instead of undef.

# Days > 31 following a month name, with an explicit four-digit year,
# must be rejected.
is(str2time('September 34, 1984'), undef,
    "GH#125: 'September 34, 1984' must return undef (day 34 is invalid)");

is(str2time('September 32, 1984'), undef,
    "GH#125: 'September 32, 1984' must return undef (day 32 is invalid)");

# September only has 30 days; day 31 must also be rejected.
is(str2time('September 31, 1984'), undef,
    "GH#125: 'September 31, 1984' must return undef (September has 30 days)");

# Sanity: valid dates near the boundary must still parse correctly.
ok(defined str2time('September 30, 1984'),
    "GH#125: 'September 30, 1984' must parse successfully");

ok(defined str2time('September 29, 1984'),
    "GH#125: 'September 29, 1984' must parse successfully");

# GH#2 / RT#53267 regression: 'Month YYYY' (year only, no day) must still
# work — this was the original motivation for the > 31 heuristic.
{
    my ($ss, $mm, $hh, $day, $month, $year, $zone) = strptime('December 2009');
    is($month, 11,  "GH#125/RT#53267: 'December 2009' still gives month=11");
    ok(!defined($day), "GH#125/RT#53267: 'December 2009' still gives day=undef");
    is($year,  109, "GH#125/RT#53267: 'December 2009' still gives year=109 (2009-1900)");
}
