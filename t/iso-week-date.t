use strict;
use warnings;
use Test::More;
use Date::Parse qw(str2time strptime);

# ISO 8601 week date: YYYY-Www-D (extended) and YYYYWwwD (basic)
# Week 1 is the week containing the first Thursday of the year.
# Day 1 = Monday, Day 7 = Sunday.

# --- Extended format: YYYY-Www-D ---
{
    # 2025-W17-1 = Monday April 21, 2025
    my $t = str2time("2025-W17-1T00:00:00Z");
    is($t, 1745193600, "2025-W17-1 = Mon Apr 21 2025");

    # 2025-W17-5 = Friday April 25, 2025
    my $t2 = str2time("2025-W17-5T00:00:00Z");
    is($t2, 1745193600 + 4*86400, "2025-W17-5 = Fri Apr 25 2025");

    # 2025-W17-7 = Sunday April 27, 2025
    my $t3 = str2time("2025-W17-7T00:00:00Z");
    is($t3, 1745193600 + 6*86400, "2025-W17-7 = Sun Apr 27 2025");
}

# --- Basic format: YYYYWwwD ---
{
    my $t = str2time("2025W171T00:00:00Z");
    is($t, 1745193600, "basic form 2025W171 = Mon Apr 21 2025");
}

# --- Week 1 boundary: may span year boundary ---
{
    # ISO week 1 of 2025 starts Mon Dec 30, 2024
    my $t = str2time("2025-W01-1T00:00:00Z");
    is($t, 1735516800, "2025-W01-1 = Mon Dec 30 2024 (cross-year)");

    # ISO week 1 of 2024 starts Mon Jan 1, 2024
    my $t2 = str2time("2024-W01-1T00:00:00Z");
    is($t2, 1704067200, "2024-W01-1 = Mon Jan 1 2024");
}

# --- Week 53: only some years have it ---
{
    # 2020 has 53 weeks (starts on Wednesday, is a leap year)
    # 2020-W53-4 = Thursday Dec 31, 2020
    my $t = str2time("2020-W53-4T00:00:00Z");
    is($t, 1609372800, "2020-W53-4 = Thu Dec 31 2020");

    # 2020-W53-5 = Friday Jan 1, 2021
    my $t2 = str2time("2020-W53-5T00:00:00Z");
    is($t2, 1609459200, "2020-W53-5 = Fri Jan 1 2021 (cross-year)");
}

# --- With time and timezone ---
{
    my $t = str2time("2025-W17-1T14:30:00Z");
    is($t, 1745193600 + 14*3600 + 30*60, "week date with time UTC");

    my $t2 = str2time("2025-W17-1T14:30:00+0530");
    is($t2, 1745193600 + 14*3600 + 30*60 - 5*3600 - 30*60,
        "week date with time +0530");
}

# --- With fractional seconds ---
{
    my $t = str2time("2025-W17-1T10:30:00.5Z");
    ok(defined $t, "week date with fractional seconds parses");
    cmp_ok(abs($t - (1745193600 + 10*3600 + 30*60 + 0.5)), '<', 0.01,
        "fractional seconds preserved in week date");
}

# --- strptime returns correct components ---
{
    my @r = strptime("2025-W17-1T10:30:45Z");
    is($r[0], 45,  "strptime: seconds");
    is($r[1], 30,  "strptime: minutes");
    is($r[2], 10,  "strptime: hours");
    is($r[3], 21,  "strptime: day = 21 (April 21)");
    is($r[4], 3,   "strptime: month = 3 (April, 0-indexed)");
    is($r[5], 125, "strptime: year = 125 (2025 - 1900)");
    is($r[6], 0,   "strptime: zone = 0 (UTC)");
    is($r[7], 20,  "strptime: century = 20");
}

# --- Validation: invalid week/day numbers ---
{
    ok(!defined str2time("2025-W00-1"), "week 0 is invalid");
    ok(!defined str2time("2025-W54-1"), "week 54 is invalid");
    ok(!defined str2time("2025-W17-0"), "day 0 is invalid");
    ok(!defined str2time("2025-W17-8"), "day 8 is invalid");
}

# --- Various years to verify algorithm correctness ---
{
    # 2023-W01-1 = Mon Jan 2, 2023
    my $t = str2time("2023-W01-1T00:00:00Z");
    my @gm = gmtime($t);
    is($gm[3], 2,  "2023-W01 day = 2");
    is($gm[4], 0,  "2023-W01 month = January");
    is($gm[5]+1900, 2023, "2023-W01 year = 2023");

    # 2000-W52-6 = Sat Dec 30, 2000
    my $t2 = str2time("2000-W52-6T00:00:00Z");
    my @gm2 = gmtime($t2);
    is($gm2[3], 30, "2000-W52-6 day = 30");
    is($gm2[4], 11, "2000-W52-6 month = December");
    is($gm2[5]+1900, 2000, "2000-W52-6 year = 2000");

    # 1999-W01-1 = Mon Jan 4, 1999
    my $t3 = str2time("1999-W01-1T00:00:00Z");
    my @gm3 = gmtime($t3);
    is($gm3[3], 4,  "1999-W01-1 day = 4");
    is($gm3[4], 0,  "1999-W01-1 month = January");
}

# --- Date-only (no time) uses defaults ---
{
    my $t = str2time("2025-W17-1");
    ok(defined $t, "week date without time parses");
    my @lt = localtime($t);
    is($lt[3], 21, "week date without time: day = 21");
    is($lt[4], 3,  "week date without time: month = April");
}

done_testing;
