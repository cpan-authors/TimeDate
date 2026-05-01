use strict;
use warnings;
use Test::More;
use Date::Parse;
use POSIX qw(strftime);
use Time::Local;

# ISO 8601 ordinal date format: YYYY-DDD
# DDD is the day-of-year (001-366)

# Helper: compute expected epoch for a given ordinal date
sub ordinal_epoch {
    my ($year, $doy) = @_;
    my $jan1 = timegm(0, 0, 0, 1, 0, $year);
    return $jan1 + ($doy - 1) * 86400;
}

# Basic ordinal dates
{
    # 2025-001 = January 1, 2025
    my $t = str2time("2025-001", "GMT");
    is($t, ordinal_epoch(2025, 1), "2025-001 = Jan 1 2025");

    # 2025-032 = February 1, 2025
    $t = str2time("2025-032", "GMT");
    is($t, ordinal_epoch(2025, 32), "2025-032 = Feb 1 2025");

    # 2025-123 = May 3, 2025
    $t = str2time("2025-123", "GMT");
    is($t, ordinal_epoch(2025, 123), "2025-123 = May 3 2025");
    is(strftime("%Y-%m-%d", gmtime($t)), "2025-05-03", "2025-123 formats as 2025-05-03");

    # 2025-365 = December 31, 2025 (non-leap year)
    $t = str2time("2025-365", "GMT");
    is($t, ordinal_epoch(2025, 365), "2025-365 = Dec 31 2025");
    is(strftime("%Y-%m-%d", gmtime($t)), "2025-12-31", "2025-365 formats as 2025-12-31");
}

# Leap year handling
{
    # 2024 is a leap year (366 days)
    my $t = str2time("2024-366", "GMT");
    is($t, ordinal_epoch(2024, 366), "2024-366 = Dec 31 2024 (leap year)");
    is(strftime("%Y-%m-%d", gmtime($t)), "2024-12-31", "2024-366 formats as 2024-12-31");

    # Day 60 in leap year = Feb 29
    $t = str2time("2024-060", "GMT");
    is(strftime("%Y-%m-%d", gmtime($t)), "2024-02-29", "2024-060 = Feb 29 (leap year)");

    # Day 60 in non-leap year = Mar 1
    $t = str2time("2025-060", "GMT");
    is(strftime("%Y-%m-%d", gmtime($t)), "2025-03-01", "2025-060 = Mar 1 (non-leap year)");

    # Day 366 in non-leap year = invalid
    $t = str2time("2025-366", "GMT");
    ok(!defined $t, "2025-366 rejected (non-leap year has only 365 days)");
}

# With time suffix
{
    my $t = str2time("2025-123T10:30:00", "GMT");
    is(strftime("%Y-%m-%d %H:%M:%S", gmtime($t)), "2025-05-03 10:30:00",
       "2025-123T10:30:00 parses date and time");

    $t = str2time("2025-123T10:30:00Z");
    is(strftime("%Y-%m-%d %H:%M:%S", gmtime($t)), "2025-05-03 10:30:00",
       "2025-123T10:30:00Z parses with Z timezone");

    # With fractional seconds
    my @parts = strptime("2025-123T10:30:45.123");
    is($parts[0], 45.123, "fractional seconds preserved");
    is($parts[1], 30, "minutes correct");
    is($parts[2], 10, "hours correct");
    is($parts[3], 3, "day correct (May 3)");
    is($parts[4], 4, "month correct (May = 4, 0-indexed)");
}

# Invalid ordinal dates
{
    my $t = str2time("2025-000", "GMT");
    ok(!defined $t, "2025-000 rejected (day 0 invalid)");

    $t = str2time("2025-367", "GMT");
    ok(!defined $t, "2025-367 rejected (day > 366)");
}

# strptime returns correct components
{
    my @t = strptime("2025-123");
    is($t[3], 3, "strptime day = 3 (May 3)");
    is($t[4], 4, "strptime month = 4 (May, 0-indexed)");
    is($t[5], 125, "strptime year = 125 (2025 - 1900)");
    is($t[7], 20, "strptime century = 20");
}

# Does not interfere with existing YYYY-MM-DD parsing
{
    my $t = str2time("2025-01-24", "GMT");
    is(strftime("%Y-%m-%d", gmtime($t)), "2025-01-24",
       "YYYY-MM-DD still works correctly");

    $t = str2time("2025-12-31", "GMT");
    is(strftime("%Y-%m-%d", gmtime($t)), "2025-12-31",
       "YYYY-MM-DD end of year still works");
}

done_testing;
