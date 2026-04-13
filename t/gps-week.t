use strict;
use warnings;
use Test::More;
use Date::Format qw(time2str);
use Time::Local qw(timegm);

# GPS epoch is midnight UTC, January 6, 1980
# Week 0: Jan 6-12, 1980
# Week 1: Jan 13-19, 1980

my $gps_epoch = timegm(0, 0, 0, 6, 0, 80);  # 315964800
is($gps_epoch, 315964800, "GPS epoch is midnight UTC Jan 6, 1980");

# Exactly at GPS epoch = week 0
is(time2str("%G", $gps_epoch, "UTC"), "0",
    "GPS epoch itself is week 0");

# One second before week 1 boundary
my $end_week0 = timegm(59, 59, 23, 12, 0, 80);
is(time2str("%G", $end_week0, "UTC"), "0",
    "23:59:59 Jan 12, 1980 is still week 0");

# Start of week 1
my $start_week1 = timegm(0, 0, 0, 13, 0, 80);
is(time2str("%G", $start_week1, "UTC"), "1",
    "midnight Jan 13, 1980 is week 1");

# Known reference: Sep 7, 1999 (from existing test data)
is(time2str("%G", 936709362, "UTC"), "1026",
    "Sep 7, 1999 13:02:42 UTC is GPS week 1026");

# Recent date sanity check
my $apr_2026 = timegm(0, 0, 0, 12, 3, 126);
is(time2str("%G", $apr_2026, "UTC"), "2414",
    "April 12, 2026 is GPS week 2414");

done_testing;
