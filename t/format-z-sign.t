use strict;
use warnings;
use Test::More tests => 6;
use Date::Format qw(time2str);

# Regression: format_z lost the sign for negative sub-hour timezone offsets
# because int(-1800/3600) truncates to 0, and sprintf("%+03d",...) renders
# 0 as "+00" instead of "-00".

my $epoch = 946684800; # 2000-01-01 00:00:00 UTC

# Negative sub-hour offsets (the bug)
is(time2str("%z", $epoch, "-0030"), "-0030", "%z preserves sign for -0030");
is(time2str("%z", $epoch, "-0015"), "-0015", "%z preserves sign for -0015");
is(time2str("%z", $epoch, "-0045"), "-0045", "%z preserves sign for -0045");

# Positive sub-hour offsets (control)
is(time2str("%z", $epoch, "+0030"), "+0030", "%z correct for +0030");
is(time2str("%z", $epoch, "+0545"), "+0545", "%z correct for +0545 (Nepal)");

# Zero offset
is(time2str("%z", $epoch, "+0000"), "+0000", "%z correct for UTC");
