##
## Finnish tables
## Contributed by Matthew Musgrove <muskrat@mindless.com>
## Corrected by roke
##

package Date::Language::Finnish;

use strict;
use warnings;
use utf8;

use base 'Date::Language';

# VERSION: generated
# ABSTRACT: Finnish localization for Date::Format
use Date::Language ();

# In Finnish, the names of the months and days are only capitalized at the beginning of sentences.
our @MoY  = map($_ . "kuu", qw(tammi helmi maalis huhti touko kesä heinä elo syys loka marras joulu));
our @DoW  = qw(sunnuntai maanantai tiistai keskiviikko torstai perjantai lauantai);

# it is not customary to use abbreviated names of months or days
# per Graham's suggestion:
our @MoYs = @MoY;
our @DoWs = @DoW;

# the short form of ordinals
our @Dsuf = ('.') x 32;

# doesn't look like this is normally used...
our @AMPM = qw(ap ip);

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_o { sprintf("%2de",$_[0]->[3]) }

1;