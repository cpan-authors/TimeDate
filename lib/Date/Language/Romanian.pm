##
## Romanian tables
##

package Date::Language::Romanian;

use strict;
use warnings;

use Date::Language ();
use base 'Date::Language';

# VERSION: generated
# ABSTRACT: Romanian localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@MoY  = qw(ianuarie februarie martie aprilie mai iunie
        iulie august septembrie octombrie noiembrie decembrie);
@DoW  = qw(duminica luni marti miercuri joi vineri sambata);
@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;

@AMPM = qw(AM PM);

@Dsuf = ('') x 31;


Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;
