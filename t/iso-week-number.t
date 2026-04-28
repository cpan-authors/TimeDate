use strict;
use warnings;
use Test::More;
use Date::Format qw(time2str);
use Time::Local qw(timegm);

# %V — ISO 8601 week number (01-53)
# Week 1 is the week containing the year's first Thursday.
# Weeks start on Monday.

my @cases = (
    # [epoch_utc, expected_week, description]

    # 2024: Jan 1 is Monday → Week 1 starts Jan 1
    [timegm(0,0,0, 1,0,124), "01", "2024-01-01 (Mon) is week 01"],
    [timegm(0,0,0, 7,0,124), "01", "2024-01-07 (Sun) is still week 01"],
    [timegm(0,0,0, 8,0,124), "02", "2024-01-08 (Mon) is week 02"],

    # 2024-12-30 (Mon) is ISO week 1 of 2025
    [timegm(0,0,0,30,11,124), "01", "2024-12-30 (Mon) is week 01 of next year"],
    [timegm(0,0,0,31,11,124), "01", "2024-12-31 (Tue) is week 01 of next year"],

    # 2023: Jan 1 is Sunday → belongs to week 52 of 2022
    [timegm(0,0,0, 1,0,123), "52", "2023-01-01 (Sun) is week 52 of prev year"],
    [timegm(0,0,0, 2,0,123), "01", "2023-01-02 (Mon) is week 01"],

    # 2015: Jan 1 is Thursday → Week 1 starts Dec 29, 2014
    [timegm(0,0,0, 1,0,115), "01", "2015-01-01 (Thu) is week 01"],
    [timegm(0,0,0,31,11,115), "53", "2015-12-31 (Thu) is week 53"],

    # 2016: Jan 1 is Friday → belongs to week 53 of 2015
    [timegm(0,0,0, 1,0,116), "53", "2016-01-01 (Fri) is week 53 of 2015"],
    [timegm(0,0,0, 4,0,116), "01", "2016-01-04 (Mon) is week 01"],

    # 2026: Jan 1 is Thursday → Week 1
    [timegm(0,0,0, 1,0,126), "01", "2026-01-01 (Thu) is week 01"],
    [timegm(0,0,0,28,3,126), "18", "2026-04-28 (Tue) is week 18"],

    # Mid-year sanity
    [timegm(0,0,0, 1,6,124), "27", "2024-07-01 (Mon) is week 27"],

    # Year with 53 weeks: 2004 (Jan 1 is Thursday, leap year)
    [timegm(0,0,0,27,11,104), "53", "2004-12-27 (Mon) is week 53"],
    [timegm(0,0,0, 2,0,105),  "53", "2005-01-02 (Sun) is week 53 of 2004"],
    [timegm(0,0,0, 3,0,105),  "01", "2005-01-03 (Mon) is week 01 of 2005"],
);

for my $case (@cases) {
    my ($epoch, $expected, $desc) = @$case;
    is(time2str("%V", $epoch, "UTC"), $expected, $desc);
}

# Verify %V always returns two-digit zero-padded string
like(time2str("%V", timegm(0,0,0,3,0,126), "UTC"), qr/^\d{2}$/,
    "%V is always two digits");

done_testing;
