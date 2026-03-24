# NAME

TimeDate - Date and time formatting subroutines

# VERSION

version 2.35

# SYNOPSIS

```perl
use Date::Format;
use Date::Parse;

# Formatting
print time2str("%Y-%m-%d %T", time);          # 2024-01-15 14:30:00
print time2str("%a %b %e %T %Y\n", time);     # Mon Jan 15 14:30:00 2024

# Parsing
my $time = str2time("Wed, 16 Jun 94 07:29:35 CST");
my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime("2024-01-15T14:30:00Z");

# Multi-language support
use Date::Language;
my $lang = Date::Language->new('German');
print $lang->time2str("%a %b %e %T %Y\n", time);
```

# DESCRIPTION

The TimeDate distribution provides date parsing, formatting, and timezone
handling for Perl.

- [Date::Parse](https://metacpan.org/pod/Date%3A%3AParse)

    Parse date strings in a wide variety of formats into Unix timestamps
    or component values.

- [Date::Format](https://metacpan.org/pod/Date%3A%3AFormat)

    Format Unix timestamps or localtime arrays into strings using
    `strftime`-style conversion specifications.

- [Date::Language](https://metacpan.org/pod/Date%3A%3ALanguage)

    Format and parse dates in over 30 languages including French, German,
    Spanish, Chinese, Russian, Arabic, and many more.

- [Time::Zone](https://metacpan.org/pod/Time%3A%3AZone)

    Timezone offset lookups and conversions for named timezones.

# AI POLICY

This project uses AI tools to assist development. Humans review and approve every change before it is merged. See [AI\_POLICY.md](AI_POLICY.md) for details.

# SEE ALSO

[Date::Format](https://metacpan.org/pod/Date%3A%3AFormat), [Date::Parse](https://metacpan.org/pod/Date%3A%3AParse), [Date::Language](https://metacpan.org/pod/Date%3A%3ALanguage), [Time::Zone](https://metacpan.org/pod/Time%3A%3AZone)

# AUTHOR

Graham <gbarr@pobox.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
