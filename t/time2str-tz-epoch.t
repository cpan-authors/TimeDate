use strict;
use warnings;
use Test::More;
use Date::Format qw(time2str);
use Time::Local qw(timegm);

# Regression: time2str stored tz-adjusted epoch in $me->[9] instead of
# the real epoch.  This caused format_G (GPS week) to give wrong results
# when a non-UTC timezone was specified and the epoch was near a GPS week
# boundary.  format_z was also affected (DST lookup used wrong time).

my $gps_epoch = 315964800;  # midnight UTC, Jan 6, 1980

# GPS week 1 starts exactly 604800s after GPS epoch
my $week1_start = $gps_epoch + 604800;  # midnight UTC, Jan 13, 1980

# Without timezone: both should agree on the week boundary
is(time2str("%G", $week1_start, "UTC"), "1",
    "week 1 start with UTC");

# With EST (-5h): the real epoch hasn't changed, so GPS week must be the same.
# Before the fix, $me->[9] was epoch+offset, making format_G compute
# int((epoch-18000 - gps_epoch) / 604800) = 0 instead of 1.
is(time2str("%G", $week1_start, "EST"), "1",
    "week 1 start with EST — GPS week must match UTC");

# Edge case: one second before week 1
is(time2str("%G", $week1_start - 1, "EST"), "0",
    "one second before week 1, EST — still week 0");

# A date well within a week should be unaffected by timezone
my $mid_week = $gps_epoch + 604800 * 100 + 43200;  # week 100, noon UTC
is(time2str("%G", $mid_week, "UTC"), "100", "mid-week UTC");
is(time2str("%G", $mid_week, "EST"), "100", "mid-week EST");
is(time2str("%G", $mid_week, "JST"), "100", "mid-week JST (+9)");

# format_s (%s) should always return the real epoch regardless of timezone
is(time2str("%s", $week1_start, "UTC"), "$week1_start",
    "%s with UTC returns real epoch");
is(time2str("%s", $week1_start, "EST"), "$week1_start",
    "%s with EST returns real epoch (not adjusted)");

done_testing;
