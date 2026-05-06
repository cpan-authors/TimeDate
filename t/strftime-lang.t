use strict;
use warnings;
use Test::More;
use Date::Language;

# Test that strftime produces language-specific output via both
# object method calls and class method calls.
#
# Bug: strftime() used 'bless []' without specifying the package,
# so class method calls like Date::Language::German->strftime(...)
# always produced English output instead of German.

# Use a fixed time: Wednesday 2025-01-15 10:30:00
#   wday=3 (Wednesday), month=0 (January)
my @time = (0, 30, 10, 15, 0, 125, 3, 14, 0);

# --- Object method (the common path) ---

my $de = Date::Language->new('German');
my $fmt_obj = $de->strftime("%A %B", \@time);
like($fmt_obj, qr/Mittwoch/i, "strftime object method: German weekday name");
like($fmt_obj, qr/Januar/i,   "strftime object method: German month name");

my $fr = Date::Language->new('French');
$fmt_obj = $fr->strftime("%A %B", \@time);
like($fmt_obj, qr/mercredi/i, "strftime object method: French weekday name");
like($fmt_obj, qr/janvier/i,  "strftime object method: French month name");

# --- Class method (the buggy path before fix) ---

require Date::Language::German;
my $fmt_cls = Date::Language::German->strftime("%A %B", \@time);
like($fmt_cls, qr/Mittwoch/i, "strftime class method: German weekday name");
like($fmt_cls, qr/Januar/i,   "strftime class method: German month name");

require Date::Language::French;
$fmt_cls = Date::Language::French->strftime("%A %B", \@time);
like($fmt_cls, qr/mercredi/i, "strftime class method: French weekday name");
like($fmt_cls, qr/janvier/i,  "strftime class method: French month name");

# --- Verify time2str also works (already correct, but let's confirm) ---

my $epoch = 1736935800;  # 2025-01-15 10:30:00 UTC
my $t2s = Date::Language::German->time2str("%A %B", $epoch, "UTC");
like($t2s, qr/Mittwoch/i, "time2str class method: German weekday name");
like($t2s, qr/Januar/i,   "time2str class method: German month name");

done_testing;
