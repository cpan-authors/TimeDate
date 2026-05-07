##
## Occitan tables, contributed by Quentn PAGÈS
##

package Date::Language::Occitan;

use strict;
use warnings;
use Date::Language ();
use base 'Date::Language';

# VERSION: generated
# ABSTRACT: Occitan localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = qw(dimenge diluns dimars dimècres dijòus divendres dissabte);
@MoY = qw(genièr febrièr març abrial mai junh
          julhet agost setembre octòbre novembre decembre);
@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;
$MoYs[6] = 'jul';
@AMPM = qw(AM PM);

@Dsuf = ((qw(er e e e e e e e e e)) x 3, 'er', 'e');

Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;
