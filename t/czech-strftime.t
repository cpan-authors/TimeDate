use strict;
use warnings;
use Test::More;
use Date::Language;

# Regression test: Czech strftime() was calling SUPER::time2str()
# instead of SUPER::strftime(), producing garbage dates because
# time2str() interprets its second argument as epoch seconds,
# not as a localtime() array reference.

my $cz = Date::Language->new('Czech');

# Tue Sep  7 13:02:42 1999 GMT
my @tm = (42, 2, 13, 7, 8, 99, 2, 249, 0);

# strftime takes (format, time_ref) — same as time2str but with arrayref
my $result = $cz->strftime('%d. %B %Y', \@tm);

# Must match time2str output for the same date
my $epoch = 936709362; # same timestamp
my $expected = $cz->time2str('%d. %B %Y', $epoch, 'GMT');

is($result, $expected, 'Czech strftime produces same result as time2str');

# Verify the date components are sane
like($result, qr/^ ?7\. .+ 1999$/, 'Czech strftime: day 7, year 1999');

# Also test the %o format (Czech day ordinal)
is($cz->strftime('%o', \@tm), '7.', 'Czech strftime: %o produces day with dot');

# Test that time2str still works (both methods should apply the B→Q substitution)
like($cz->time2str('%d. %B %Y', $epoch, 'GMT'), qr/1999/, 'Czech time2str still works');
like($cz->strftime('%d. %B %Y', \@tm), qr/1999/, 'Czech strftime returns correct year');

done_testing;
