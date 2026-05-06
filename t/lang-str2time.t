use strict;
use warnings;
use Test::More;
use Date::Language;
use Date::Parse;

my $lang = Date::Language->new('English');

# --- Year inference: same month, future day ---
# Date::Language should match Date::Parse behavior:
# when month == current month and day > current day, infer previous year.

{
    my @lt = localtime(time);
    my $cur_month = $lt[4];  # 0-indexed
    my $cur_day   = $lt[3];
    my $cur_year  = $lt[5] + 1900;

    my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    my $mon_str = $months[$cur_month];

    # Pick a day in the future within the same month
    if ($cur_day < 28) {
        my $future_day = $cur_day + 3;
        my $date_str = "$future_day $mon_str";

        my $dp_result = str2time($date_str);
        my $dl_result = $lang->str2time($date_str);

        ok(defined $dp_result, "Date::Parse parses '$date_str'");
        ok(defined $dl_result, "Date::Language parses '$date_str'");

        if (defined $dp_result && defined $dl_result) {
            my @dp_lt = localtime($dp_result);
            my @dl_lt = localtime($dl_result);

            is($dl_lt[5], $dp_lt[5],
                "year inference: same-month future day '$date_str' matches Date::Parse (year " .
                ($dp_lt[5] + 1900) . ")");
        }
    }

    # Pick a day in the past within the same month
    if ($cur_day > 3) {
        my $past_day = $cur_day - 2;
        my $date_str = "$past_day $mon_str";

        my $dp_result = str2time($date_str);
        my $dl_result = $lang->str2time($date_str);

        ok(defined $dp_result, "Date::Parse parses '$date_str'");
        ok(defined $dl_result, "Date::Language parses '$date_str'");

        if (defined $dp_result && defined $dl_result) {
            my @dp_lt = localtime($dp_result);
            my @dl_lt = localtime($dl_result);

            is($dl_lt[5], $dp_lt[5],
                "year inference: same-month past day '$date_str' matches Date::Parse (year " .
                ($dp_lt[5] + 1900) . ")");
        }
    }
}

# --- Invalid date handling: should return undef, not die ---

{
    my $result;
    my $ok = eval { $result = $lang->str2time("32 Jun 2024 07:29:35"); 1; };
    ok($ok, "invalid day 32: does not die");
    is($result, undef, "invalid day 32: returns undef");
}

{
    my $result;
    my $ok = eval { $result = $lang->str2time("15 Jun 2024 25:00:00"); 1; };
    ok($ok, "invalid hour 25: does not die");
    is($result, undef, "invalid hour 25: returns undef");
}

{
    my $result;
    my $ok = eval { $result = $lang->str2time("15 Jun 2024 12:61:00"); 1; };
    ok($ok, "invalid minute 61: does not die");
    is($result, undef, "invalid minute 61: returns undef");
}

# --- Valid dates: basic sanity ---

{
    my $result = $lang->str2time("Wed, 16 Jun 94 07:29:35 CST");
    ok(defined $result, "classic RFC822 date parses");
    my @t = gmtime($result);
    is($t[4], 5, "month is June (5)");
    is($t[3], 16, "day is 16");
}

# --- Non-English language round-trip ---

{
    my $de = Date::Language->new('German');
    my $t = time;
    my $str = $de->ctime($t);
    my $parsed = $de->str2time($str);
    is($parsed, $t, "German round-trip ctime/str2time");
}

# --- Two-digit year normalization: must match Date::Parse ---
# Without explicit normalization, Date::Language relies on Time::Local's
# sliding window which diverges from Date::Parse's fixed POSIX threshold.

{
    for my $y (69, 70, 75, 95, 99) {
        my $date = "1 Jun $y GMT";
        my $dp = str2time($date);
        my $dl = $lang->str2time($date);
        ok(defined $dp, "Date::Parse parses '1 Jun $y GMT'");
        ok(defined $dl, "Date::Language parses '1 Jun $y GMT'");
        if (defined $dp && defined $dl) {
            my $dp_year = (gmtime($dp))[5] + 1900;
            my $dl_year = (gmtime($dl))[5] + 1900;
            is($dl_year, $dp_year,
                "two-digit year $y: Language ($dl_year) matches Parse ($dp_year)");
        }
    }

    # Also test years in the 2000s range
    for my $y (0, 1, 26, 50, 68) {
        my $date = "15 Mar $y GMT";
        my $dp = str2time($date);
        my $dl = $lang->str2time($date);
        ok(defined $dp, "Date::Parse parses '15 Mar $y GMT'");
        ok(defined $dl, "Date::Language parses '15 Mar $y GMT'");
        if (defined $dp && defined $dl) {
            my $dp_year = (gmtime($dp))[5] + 1900;
            my $dl_year = (gmtime($dl))[5] + 1900;
            is($dl_year, $dp_year,
                "two-digit year $y: Language ($dl_year) matches Parse ($dp_year)");
        }
    }
}

# --- Four-digit year with century: must survive round-trip ---

{
    my $date = "15 Mar 2024 10:30:00 GMT";
    my $dp = str2time($date);
    my $dl = $lang->str2time($date);
    ok(defined $dp && defined $dl, "4-digit year parses in both");
    is($dl, $dp, "4-digit year: Language matches Parse exactly");
}

# --- Fractional seconds preserved ---

{
    my $date = "2024-01-15T12:34:56.789 GMT";
    my $result = $lang->str2time($date);
    ok(defined $result, "fractional seconds date parses");
    my $frac = $result - int($result);
    ok($frac > 0.78 && $frac < 0.80,
        "fractional seconds preserved (got $frac, expected ~0.789)");
}

done_testing;
