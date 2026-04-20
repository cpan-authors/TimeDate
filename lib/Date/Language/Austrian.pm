##
## Austrian tables
##

package Date::Language::Austrian;

use strict;
use warnings;
use utf8;

use Date::Language ();
use Date::Language::English ();

# VERSION: generated
# ABSTRACT: Austrian localization for Date::Format

use base 'Date::Language';

our @MoY  = qw(Jänner Feber März April Mai Juni
       Juli August September Oktober November Dezember);
our @MoYs = qw(Jän Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez);
our @DoW  = qw(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag);
our @DoWs = qw(So Mo Di Mi Do Fr Sa);


our @AMPM = @{Date::Language::English::AMPM};
our @Dsuf = @{Date::Language::English::Dsuf};

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Timezone abbreviation translations (English → German, same as German locale)
our %TZ = (
    'CET'  => 'MEZ',    # Mitteleuropäische Zeit
    'CEST' => 'MESZ',   # Mitteleuropäische Sommerzeit
    'WET'  => 'WEZ',    # Westeuropäische Zeit
    'WEST' => 'WESZ',   # Westeuropäische Sommerzeit
    'EET'  => 'OEZ',    # Osteuropäische Zeit
    'EEST' => 'OESZ',   # Osteuropäische Sommerzeit
);

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;
