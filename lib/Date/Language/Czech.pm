##
## Czech tables
##
## Contributed by Honza Pazdziora

package Date::Language::Czech;

use strict;
use warnings;
use utf8;
use Date::Language ();

use base 'Date::Language';

# VERSION: generated
# ABSTRACT: Czech localization for Date::Format

our @MoY = qw(leden únor březen duben květen červen červenec srpen září
          říjen listopad prosinec);
our @MoYs = qw(led únor bře dub kvě čvn čec srp září říj lis pro);
our @MoY2 = @MoY;
for (@MoY2)
      { s!en$!na! or s!ec$!ce! or s!ad$!adu! or s!or$!ora!; }

our @DoW = qw(neděle pondělí úterý středa čtvrtek pátek sobota);
our @DoWs = qw(Ne Po Út St Čt Pá So);

our @AMPM = qw(dop. odp.);
our @Dsuf = ('.') x 31;

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

sub format_d { $_[0]->[3] }
sub format_m { $_[0]->[4] + 1 }
sub format_o { $_[0]->[3] . '.' }

sub format_Q { $MoY2[$_[0]->[4]] }

sub time2str {
      my $ref = shift;
      my @a = @_;
      $a[0] =~ s/(%[do]\.?\s?)%B/$1%Q/;
      $ref->SUPER::time2str(@a);
      }

sub strftime {
      my $ref = shift;
      my @a = @_;
      $a[0] =~ s/(%[do]\.?\s?)%B/$1%Q/;
      $ref->SUPER::strftime(@a);
      }

1;
