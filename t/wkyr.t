use Test::More;
use Date::Format qw(time2str);

# Regression test for wkyr() off-by-one bug:
# %U and %W were wrong by one week in years where Jan 1 falls on the
# week-start day (Sunday for %U, Monday for %W).

my @tests = (
    # [epoch, zone, format, expected, description]
    # Note: %U/%W are not zero-padded in Date::Format

    # 2023: Jan 1 is Sunday — triggered %U off-by-one
    [1672531200, 'UTC', '%U', 1,  'Jan 1 2023 (Sun) %U'],
    [1672531200, 'UTC', '%W', 0,  'Jan 1 2023 (Sun) %W'],
    [1673136000, 'UTC', '%U', 2,  'Jan 8 2023 (Sun) %U'],
    [1673136000, 'UTC', '%W', 1,  'Jan 8 2023 (Mon from Jan 2) %W'],
    # Dec 31, 2023 (Sun) — week 53 for %U
    [1703980800, 'UTC', '%U', 53, 'Dec 31 2023 (Sun) %U'],

    # 2024: Jan 1 is Monday — triggered %W off-by-one
    [1704067200, 'UTC', '%U', 0,  'Jan 1 2024 (Mon) %U'],
    [1704067200, 'UTC', '%W', 1,  'Jan 1 2024 (Mon) %W'],
    [1704585600, 'UTC', '%U', 1,  'Jan 7 2024 (Sun) %U'],
    [1704585600, 'UTC', '%W', 1,  'Jan 7 2024 (Sun) %W'],
    [1704672000, 'UTC', '%U', 1,  'Jan 8 2024 (Mon) %U'],
    [1704672000, 'UTC', '%W', 2,  'Jan 8 2024 (Mon) %W'],

    # 1999: Jan 1 is Friday — neither %U nor %W affected (baseline)
    [936709362,  'UTC', '%U', 36, 'Sep 7 1999 (Tue) %U baseline'],
    [936709362,  'UTC', '%W', 36, 'Sep 7 1999 (Tue) %W baseline'],
);

plan tests => scalar @tests;

for my $tc (@tests) {
    my ($epoch, $zone, $fmt, $expected, $desc) = @$tc;
    is(time2str($fmt, $epoch, $zone), $expected, $desc);
}
