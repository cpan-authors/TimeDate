use strict;
use warnings;
use Test::More;
use Date::Parse;

# strptime should reject hours > 12 when AM/PM is specified.
# Previously, "13:30 PM" produced hh=25 (13+12) instead of being rejected.

my @invalid = (
    "13:00 PM",
    "13:30 PM",
    "14:00 AM",
    "23:59 PM",
    "99:00 AM",
    "Jan 1 2024 13:00 PM",
    "Jan 1 2024 15:30 AM",
);

for my $input (@invalid) {
    my @parsed = strptime($input);
    ok(!defined $parsed[2], "strptime rejects '$input' (hour > 12 with AM/PM)")
        or diag("  got hh=$parsed[2], expected undef");

    my $epoch = str2time($input);
    ok(!defined $epoch, "str2time rejects '$input'");
}

# Valid AM/PM usage must still work
my @valid = (
    [ "1:30 PM",              13 ],
    [ "1:30 AM",               1 ],
    [ "12:00 PM",             12 ],
    [ "12:00 AM",              0 ],
    [ "12:59 PM",             12 ],
    [ "12:59 AM",              0 ],
    [ "Jan 1 2024 3:00 PM",   15 ],
    [ "Jan 1 2024 3:00 AM",    3 ],
);

for my $case (@valid) {
    my ($input, $expected_hh) = @$case;
    my @parsed = strptime($input);
    is($parsed[2], $expected_hh, "strptime('$input') => hh=$expected_hh");
}

# 24-hour times without AM/PM must still work
my @twentyfour = (
    [ "13:00",   13 ],
    [ "23:59",   23 ],
    [ "0:00",     0 ],
    [ "12:00",   12 ],
);

for my $case (@twentyfour) {
    my ($input, $expected_hh) = @$case;
    my @parsed = strptime($input);
    is($parsed[2], $expected_hh, "strptime('$input') => hh=$expected_hh (24h format)");
}

done_testing;
