use strict;
use warnings;
use Test::More;
use Date::Format qw(time2str strftime);
use Time::Local qw(timegm);

# strftime() was missing $me->[9] (epoch timestamp), causing format codes
# that depend on it (%G, %s) to produce wrong results.

my $t = timegm(0, 0, 12, 28, 3, 124);  # 2024-04-28 12:00:00 UTC
my @gmt = gmtime($t);

# %G (GPS week) - was returning -522 instead of 2312
is(time2str("%G", $t, "UTC"), "2312",
    "time2str %G gives correct GPS week");
is(strftime("%G", @gmt, "UTC"), "2312",
    "strftime %G with timezone gives correct GPS week");

# %s (epoch seconds) - strftime with localtime should match time2str
my @lt = localtime($t);
is(time2str("%s", $t), strftime("%s", @lt),
    "strftime %s (localtime, no tz) matches time2str %s");

# GPS epoch boundary via strftime
my $gps_epoch = 315964800;
my @gps_gmt = gmtime($gps_epoch);
is(strftime("%G", @gps_gmt, "UTC"), "0",
    "strftime %G at GPS epoch is week 0");

my @week1_gmt = gmtime($gps_epoch + 7 * 86400);
is(strftime("%G", @week1_gmt, "UTC"), "1",
    "strftime %G one week after GPS epoch is week 1");

# Verify strftime and time2str agree on %G for several dates
for my $pair (
    [timegm(0, 0, 0, 6, 0, 80),  "0",    "GPS epoch"],
    [timegm(0, 0, 0, 13, 0, 80), "1",    "start of week 1"],
    [936709362,                    "1026", "Sep 7, 1999"],
) {
    my ($epoch, $expected, $label) = @$pair;
    my @g = gmtime($epoch);
    is(strftime("%G", @g, "UTC"), $expected,
        "strftime %G: $label");
    is(time2str("%G", $epoch, "UTC"), $expected,
        "time2str %G: $label (cross-check)");
}

done_testing;
