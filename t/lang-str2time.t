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

# --- EPOCH parameter: Date::Language should match Date::Parse ---

{
    # Use a fixed reference time: July 1 2024 00:00:00 UTC
    my $ref = 1719792000;

    # "25 Dec" relative to July 2024 → Dec 2023 (most recent past)
    my $dp = str2time("25 Dec", undef, $ref);
    my $dl = $lang->str2time("25 Dec", undef, $ref);

    ok(defined $dp, "Date::Parse parses '25 Dec' with EPOCH ref");
    ok(defined $dl, "Date::Language parses '25 Dec' with EPOCH ref");

    if (defined $dp && defined $dl) {
        my @dp_t = gmtime($dp);
        my @dl_t = gmtime($dl);
        is($dl_t[5] + 1900, $dp_t[5] + 1900,
            "EPOCH param: '25 Dec' ref=Jul-2024 → year matches Date::Parse ("
            . ($dp_t[5] + 1900) . ")");
        is($dl_t[5] + 1900, 2023,
            "EPOCH param: '25 Dec' ref=Jul-2024 → year 2023 (most recent past)");
    }

    # "15 Mar" relative to July 2024 → Mar 2024 (already past this year)
    my $dp2 = str2time("15 Mar", undef, $ref);
    my $dl2 = $lang->str2time("15 Mar", undef, $ref);

    ok(defined $dp2, "Date::Parse parses '15 Mar' with EPOCH ref");
    ok(defined $dl2, "Date::Language parses '15 Mar' with EPOCH ref");

    if (defined $dp2 && defined $dl2) {
        my @dp_t = gmtime($dp2);
        my @dl_t = gmtime($dl2);
        is($dl_t[5] + 1900, $dp_t[5] + 1900,
            "EPOCH param: '15 Mar' ref=Jul-2024 → year matches Date::Parse ("
            . ($dp_t[5] + 1900) . ")");
        is($dl_t[5] + 1900, 2024,
            "EPOCH param: '15 Mar' ref=Jul-2024 → year 2024 (past this year)");
    }
}

done_testing;
