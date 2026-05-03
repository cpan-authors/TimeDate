use strict;
use warnings;
use Test::More tests => 18;
use Date::Parse qw(strptime str2time);

# DD-MM-YYYY (European date format) — the first field exceeds 12,
# so it cannot be a month.  Before the fix, day and year were swapped.

my @r;

# 31-12-2023 → 31 Dec 2023
@r = strptime("31-12-2023");
is($r[3], 31, "31-12-2023: day = 31");
is($r[4], 11, "31-12-2023: month = 11 (December, 0-based)");
is($r[5], 123, "31-12-2023: year = 123 (2023 - 1900)");

# 25-07-2020 → 25 Jul 2020
@r = strptime("25-07-2020");
is($r[3], 25, "25-07-2020: day = 25");
is($r[4], 6,  "25-07-2020: month = 6 (July, 0-based)");
is($r[5], 120, "25-07-2020: year = 120 (2020 - 1900)");

# str2time must return a defined value (not undef)
ok(defined str2time("31-12-2023"), "str2time('31-12-2023') is defined");

# DD-MM-YY (2-digit year, European format)
@r = strptime("31-12-96");
is($r[3], 31, "31-12-96: day = 31");
is($r[4], 11, "31-12-96: month = 11 (December, 0-based)");

# YYYY-MM-DD (mainframe format) must still work
@r = strptime("1995-01-24");
is($r[3], 24, "1995-01-24: day = 24");
is($r[4], 0,  "1995-01-24: month = 0 (January, 0-based)");
is($r[5], 95, "1995-01-24: year = 95 (1995 - 1900)");

# 13-01-2025 → 13 Jan 2025
# Regression: first field = 13 produces $month = 12 (0-indexed),
# which is > 11 but was NOT > 12 in the old check, so the swap
# from MM-DD to DD-MM never triggered.
@r = strptime("13-01-2025");
is($r[3], 13, "13-01-2025: day = 13 (not treated as month)");
is($r[4], 0,  "13-01-2025: month = 0 (January, 0-based)");
is($r[5], 125, "13-01-2025: year = 125 (2025 - 1900)");
ok(defined str2time("13-01-2025"), "str2time('13-01-2025') is defined");

# 14-02-2025 → 14 Feb 2025 (also affected by off-by-one)
@r = strptime("14-02-2025");
is($r[3], 14, "14-02-2025: day = 14");
is($r[4], 1,  "14-02-2025: month = 1 (February, 0-based)");
