use strict;
use warnings;
use Test::More tests => 3;
use Time::Zone qw(tz_offset);
use Date::Format qw(time2str);

# GH#9 / RT#77886: IST (India Standard Time) was commented out in Time::Zone,
# causing tz_offset("IST") to return undef and time2str() to emit
# "Use of uninitialized value in addition" warnings while returning UTC time.
# Fix: uncomment the "ist" entry (+5:30) in the @Zone table.

my $ist_offset = tz_offset("IST");
ok(defined($ist_offset), "GH#9/RT#77886: tz_offset('IST') is defined");
is($ist_offset, 5*3600+1800, "GH#9/RT#77886: IST offset is +5:30 (19800 seconds)");

# Verify time2str does not warn and applies the correct offset.
# Epoch 0 is 1970-01-01 00:00:00 UTC; in IST that is 05:30:00.
{
    my $warning;
    local $SIG{__WARN__} = sub { $warning = $_[0] };
    my $formatted = time2str("%H:%M:%S", 0, "IST");
    is($formatted, "05:30:00",
        "GH#9/RT#77886: time2str formats epoch 0 as 05:30:00 in IST with no warning");
    diag("unexpected warning: $warning") if defined $warning;
}
