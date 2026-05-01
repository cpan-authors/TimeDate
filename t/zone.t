use strict;
use warnings;
use Test::More;
use Time::Zone;

# tz_offset: standard timezone abbreviations
is(tz_offset("GMT"),  0,      "tz_offset GMT = 0");
is(tz_offset("UTC"),  0,      "tz_offset UTC = 0");
is(tz_offset("EST"),  -18000, "tz_offset EST = -18000");
is(tz_offset("CST"),  -21600, "tz_offset CST = -21600");
is(tz_offset("MST"),  -25200, "tz_offset MST = -25200");
is(tz_offset("PST"),  -28800, "tz_offset PST = -28800");
is(tz_offset("CET"),  3600,   "tz_offset CET = 3600");
is(tz_offset("JST"),  32400,  "tz_offset JST = 32400");
is(tz_offset("IST"),  19800,  "tz_offset IST = 19800");
is(tz_offset("NST"),  -12600, "tz_offset NST = -12600 (Newfoundland Standard)");
is(tz_offset("NFT"),  -12600, "tz_offset NFT = -12600 (Newfoundland)");

# tz_offset: Newfoundland Daylight (half-hour DST)
is(tz_offset("NDT"),  -9000,  "tz_offset NDT = -9000 (Newfoundland Daylight)");

# tz_offset: DST timezone abbreviations
is(tz_offset("EDT"),  -14400, "tz_offset EDT = -14400");
is(tz_offset("CDT"),  -18000, "tz_offset CDT = -18000");
is(tz_offset("MDT"),  -21600, "tz_offset MDT = -21600");
is(tz_offset("PDT"),  -25200, "tz_offset PDT = -25200");
is(tz_offset("BST"),  3600,   "tz_offset BST = 3600");
is(tz_offset("CEST"), 7200,   "tz_offset CEST = 7200");

# tz_offset: numeric offsets
is(tz_offset("+0000"), 0,      "tz_offset +0000 = 0");
is(tz_offset("-0500"), -18000, "tz_offset -0500 = -18000");
is(tz_offset("+0530"), 19800,  "tz_offset +0530 = 19800");
is(tz_offset("+0900"), 32400,  "tz_offset +0900 = 32400");
is(tz_offset("-0800"), -28800, "tz_offset -0800 = -28800");

# tz_offset: Southeast Asian timezones (RT#123247)
is(tz_offset("ICT"),  25200, "tz_offset ICT = 25200 (Indochina Time, UTC+7)");
is(tz_offset("PHT"),  28800, "tz_offset PHT = 28800 (Philippine Time, UTC+8)");
is(tz_offset("ict"),  25200, "tz_offset ict case insensitive");
is(tz_offset("pht"),  28800, "tz_offset pht case insensitive");

# tz_offset: Australian timezone abbreviations
is(tz_offset("ACST"), 34200,  "tz_offset ACST = 34200 (Australian Central Standard, UTC+9:30)");
is(tz_offset("ACDT"), 37800,  "tz_offset ACDT = 37800 (Australian Central Daylight, UTC+10:30)");
is(tz_offset("AEST"), 36000,  "tz_offset AEST = 36000 (Australian Eastern Standard, UTC+10)");
is(tz_offset("AEDT"), 39600,  "tz_offset AEDT = 39600 (Australian Eastern Daylight, UTC+11)");
is(tz_offset("AWST"), 28800,  "tz_offset AWST = 28800 (Australian Western Standard, UTC+8)");
is(tz_offset("AWDT"), 32400,  "tz_offset AWDT = 32400 (Australian Western Daylight, UTC+9)");

# tz_offset: African timezone abbreviations
is(tz_offset("SAST"), 7200,   "tz_offset SAST = 7200 (South African Standard, UTC+2)");
is(tz_offset("EAT"),  10800,  "tz_offset EAT = 10800 (East Africa, UTC+3)");

# tz_offset: Middle East and South Asian timezone abbreviations
is(tz_offset("TRT"),  10800,  "tz_offset TRT = 10800 (Turkey, UTC+3)");
is(tz_offset("IRST"), 12600,  "tz_offset IRST = 12600 (Iran Standard, UTC+3:30)");
is(tz_offset("IRDT"), 16200,  "tz_offset IRDT = 16200 (Iran Daylight, UTC+4:30)");
is(tz_offset("AFT"),  16200,  "tz_offset AFT = 16200 (Afghanistan, UTC+4:30)");
is(tz_offset("PKT"),  18000,  "tz_offset PKT = 18000 (Pakistan Standard, UTC+5)");
is(tz_offset("NPT"),  20700,  "tz_offset NPT = 20700 (Nepal, UTC+5:45)");

# tz_offset: European DST abbreviations
is(tz_offset("WEST"), 3600,   "tz_offset WEST = 3600 (Western European Summer, UTC+1)");

# tz_offset: unknown zone returns undef
is(tz_offset("BOGUS"), undef, "tz_offset unknown zone returns undef");

# tz_offset: case insensitivity
is(tz_offset("gmt"), 0,      "tz_offset case insensitive: gmt");
is(tz_offset("est"), -18000, "tz_offset case insensitive: est");

# tz_name: with explicit $dst parameter (deterministic, no system-time dependency)
# When $dst=0, offset -18000 (-5h) should resolve to a standard timezone (EST)
# When $dst=1, offset -18000 (-5h) should resolve to a DST timezone (CDT)
is(tz_name(-18000, 0), "est", "tz_name(-18000, dst=0) is est");
is(tz_name(-18000, 1), "cdt", "tz_name(-18000, dst=1) is cdt");

# tz_name: offset 0 is always GMT/UTC regardless of DST flag
like(tz_name(0, 0), qr/^(?:gmt|utc)$/i, "tz_name(0, dst=0) is GMT or UTC");
like(tz_name(0, 1), qr/^(?:gmt|utc)$/i, "tz_name(0, dst=1) is GMT or UTC");

# tz_name: offsets with only standard or only DST entries
is(tz_name(32400, 0),  "jst",  "tz_name(32400, dst=0) is jst (Japan Standard)");
is(tz_name(-25200, 1), "pdt",  "tz_name(-25200, dst=1) is pdt (Pacific Daylight)");
is(tz_name(-28800, 0), "pst",  "tz_name(-28800, dst=0) is pst (Pacific Standard)");

# tz_name: unknown offset returns correct +HHMM numeric string (RT#59298)
# 5400s = 90 minutes = UTC+1:30 → "+0130" (not "+9000" which the buggy code produced)
is(tz_name(5400, 0),  "+0130", "tz_name(5400) returns +0130 (UTC+1:30)");
# Negative fractional-hour offset: -5400s = UTC-1:30 → "-0130"
# (Note: -9000 is now NDT/Newfoundland Daylight, so use -5400 instead)
is(tz_name(-5400, 0), "-0130", "tz_name(-5400) returns -0130 (UTC-1:30)");

# tz_local_offset: returns a sane value
{
    my $offset = tz_local_offset();
    ok(defined $offset, "tz_local_offset returns defined value");
    cmp_ok($offset, '>=', -12 * 3600, "tz_local_offset >= -12 hours");
    cmp_ok($offset, '<=', 14 * 3600,  "tz_local_offset <= 14 hours");
}

done_testing;
