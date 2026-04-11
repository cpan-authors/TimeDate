use strict;
use warnings;
use Test::More tests => 20;
use Date::Format qw(time2str);

# Unix timestamp for Tue Sep 7 11:22:42 1999 GMT (used in format.t)
my $t = 936709362;

# Baseline: English (default)
is( time2str('%A', $t, 'GMT'),          'Tuesday',   'English day (no lang arg)'  );
is( time2str('%B', $t, 'GMT'),          'September', 'English month (no lang arg)');

# Explicit English via language argument
is( time2str('%A', $t, 'GMT', 'English'), 'Tuesday',   'English day (explicit)'  );
is( time2str('%B', $t, 'GMT', 'English'), 'September', 'English month (explicit)');

# German
is( time2str('%A', $t, 'GMT', 'German'), 'Dienstag', 'German day'  );
is( time2str('%B', $t, 'GMT', 'German'), 'September', 'German month');

# French
is( time2str('%A', $t, 'GMT', 'French'), 'mardi',     'French day'  );
is( time2str('%B', $t, 'GMT', 'French'), 'septembre', 'French month');

# --- %o (ornate day) should use language-specific ordinal suffixes ---

# Timestamp for Jan 1, 2024 12:00:00 GMT (day 1)
my $jan1 = 1704110400;
# Timestamp for Jan 2, 2024 12:00:00 GMT (day 2)
my $jan2 = 1704196800;
# Timestamp for Jan 15, 2024 12:00:00 GMT (day 15)
my $jan15 = 1705320000;

# English %o uses st/nd/rd/th
is( time2str('%o', $jan1, 'GMT'),            ' 1st', 'English %o day 1 (default)' );
is( time2str('%o', $jan2, 'GMT'),            ' 2nd', 'English %o day 2 (default)' );
is( time2str('%o', $jan15, 'GMT'),           '15th', 'English %o day 15 (default)');
is( time2str('%o', $jan1, 'GMT', 'English'), ' 1st', 'English %o day 1 (explicit)');

# French uses er/e suffixes
is( time2str('%o', $jan1, 'GMT', 'French'),  ' 1er', 'French %o day 1'  );
is( time2str('%o', $jan2, 'GMT', 'French'),  ' 2e',  'French %o day 2'  );

# German uses period suffix
is( time2str('%o', $jan1, 'GMT', 'German'),  ' 1.',  'German %o day 1'  );
is( time2str('%o', $jan15, 'GMT', 'German'), '15.',  'German %o day 15' );

# Spanish has language-specific suffixes (not English th/st/nd/rd)
# Day 1 should use Spanish @Dsuf[1] which is 'do', not English 'st'
{
    my $result = time2str('%o', $jan1, 'GMT', 'Spanish');
    unlike( $result, qr/st$/, 'Spanish %o day 1 is not English "st"' );
}

# Romanian uses empty suffix (just the number)
is( time2str('%o', $jan1, 'GMT', 'Romanian'), ' 1',  'Romanian %o day 1 (no suffix)' );
is( time2str('%o', $jan15,'GMT', 'Romanian'), '15',  'Romanian %o day 15 (no suffix)');

# Occitan uses language-specific suffixes (not English th/st/nd/rd)
{
    my $result = time2str('%o', $jan1, 'GMT', 'Occitan');
    unlike( $result, qr/st$/, 'Occitan %o day 1 is not English "st"' );
}
