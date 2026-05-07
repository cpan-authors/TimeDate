package Date::Language::Arabic;

use strict;
use warnings;
use utf8;
use Date::Language ();
use base 'Date::Language';

# VERSION: generated
# ABSTRACT: Arabic localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = qw(الأحد الاثنين الثلاثاء الأربعاء الخميس الجمعة السبت);
@MoY = qw(يناير فبراير مسيرة أبريل مايو يونيو يوليو أغسطس سبتمبر أكتوبر نوفمبر ديسمبر);
@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;
$MoYs[6] = 'يوليو';
@AMPM = qw(صباحا مساءا);

@Dsuf = ((qw(er e e e e e e e e e)) x 3, 'er', 'e'); #To be amended

Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;
