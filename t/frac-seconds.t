use strict;
use warnings;
use Test::More tests => 8;
use Date::Parse qw(strptime str2time);

# Fractional seconds must be preserved for all date formats, not just ISO 8601.
# Prior to this fix, the time-of-day regex consumed the ".frac" portion but
# didn't capture it, so non-ISO dates silently lost sub-second precision.

# ISO 8601 format (already worked)
{
    my @t = strptime("2024-01-15T10:30:45.5");
    is($t[0], 45.5, "ISO 8601: fractional seconds preserved in strptime");

    my $epoch = str2time("2024-01-15T10:30:45.5", "UTC");
    ok(abs($epoch - int($epoch) - 0.5) < 0.001,
       "ISO 8601: fractional seconds preserved in str2time");
}

# Non-ISO format with month name (the bug)
{
    my @t = strptime("15 Jan 2024 10:30:45.5");
    is($t[0], 45.5, "day-month-year: fractional seconds preserved in strptime");

    my $epoch_iso = str2time("2024-01-15T10:30:45.5", "UTC");
    my $epoch_dmy = str2time("15 Jan 2024 10:30:45.5 UTC");
    is($epoch_dmy, $epoch_iso,
       "day-month-year: str2time matches ISO result with fractional seconds");
}

# RFC 2822-style date (common in email headers)
{
    my @t = strptime("Wed, 15 Jan 2024 10:30:45.123 +0000");
    is($t[0], 45.123, "RFC 2822-style: fractional seconds preserved");
}

# Fractional seconds with timezone abbreviation
{
    my @t = strptime("15 Jan 2024 10:30:45.99 GMT");
    is($t[0], 45.99, "with timezone abbr: fractional seconds preserved");
}

# Fractional seconds with AM/PM
{
    my @t = strptime("15 Jan 2024 10:30:45.5 am");
    is($t[0], 45.5, "with AM suffix: fractional seconds preserved");
}

# No fractional part — ensure nothing regresses
{
    my @t = strptime("15 Jan 2024 10:30:45");
    is($t[0], 45, "integer seconds still work correctly");
}
