
package Date::Language;

use     strict;
use     Time::Local;
use     Carp;

require Date::Format;

# VERSION: generated
# ABSTRACT: Language specific date formatting and parsing

use base qw(Date::Format::Generic);

sub _build_lookups
{
 my $pkg = caller;
 no strict 'refs';
 @{"${pkg}::MoY"}{@{"${pkg}::MoY"}}  = (0 .. scalar(@{"${pkg}::MoY"}));
 @{"${pkg}::MoY"}{@{"${pkg}::MoYs"}} = (0 .. scalar(@{"${pkg}::MoYs"}));
 @{"${pkg}::DoW"}{@{"${pkg}::DoW"}}  = (0 .. scalar(@{"${pkg}::DoW"}));
 @{"${pkg}::DoW"}{@{"${pkg}::DoWs"}} = (0 .. scalar(@{"${pkg}::DoWs"}));
}

sub new
{
 my $self = shift;
 my $type = shift || $self;

 $type =~ s/^(\w+)$/Date::Language::$1/;

 croak "Bad language"
    unless $type =~ /^[\w:]+$/;

 eval "require $type"
    or croak $@;

 bless [], $type;
}

# Stop AUTOLOAD being called ;-)
sub DESTROY {}

sub AUTOLOAD
{
 our $AUTOLOAD;
 if($AUTOLOAD =~ /::strptime\Z/o)
  {
   my $self = $_[0];
   my $type = ref($self) || $self;
   require Date::Parse;

   no strict 'refs';
   *{"${type}::strptime"} = Date::Parse::gen_parser(
    \%{"${type}::DoW"},
    \%{"${type}::MoY"},
    \@{"${type}::Dsuf"},
    1);

   goto &{"${type}::strptime"};
  }

 croak "Undefined method &$AUTOLOAD called";
}

sub format_Z {
    my $tz = Date::Format::Generic::format_Z(@_);
    my $pkg = ref($_[0]) || 'Date::Language';
    no strict 'refs';
    my $tz_map = \%{"${pkg}::TZ"};
    return exists $tz_map->{$tz} ? $tz_map->{$tz} : $tz;
}

sub str2time
{
 my $me = shift;
 my @t = $me->strptime(@_);

 return undef
    unless @t;

 my($ss,$mm,$hh,$day,$month,$year,$zone,$century) = @t;
 my @lt  = localtime(time);

 $hh    ||= 0;
 $mm    ||= 0;
 $ss    ||= 0;

 my $frac = $ss - int($ss);
 $ss = int $ss;

 $month = $lt[4]
    unless(defined $month);

 $day  = $lt[3]
    unless(defined $day);

 unless (defined $year) {
   my $is_future = $month > $lt[4]
                || ($month == $lt[4] && $day > $lt[3]);
   $year = $is_future ? ($lt[5] - 1) : $lt[5];
 }

 # Restore 4-digit year when century was present in the input
 $year += 1900 if defined $century;

 # Normalize two-digit years using POSIX convention (match Date::Parse behavior).
 # Without this, Time::Local's own sliding window produces different results than
 # Date::Parse::str2time for the same input string.
 $year += ($year >= 69 ? 1900 : 2000) if $year < 100;

 return undef
    unless($month <= 11 && $day >= 1 && $day <= 31
        && $hh <= 23 && $mm <= 59 && $ss <= 59);

 my $result;

 if (defined $zone) {
   $result = eval {
     local $SIG{__DIE__} = sub {}; # match Date::Parse behavior
     timegm($ss,$mm,$hh,$day,$month,$year);
   };
   return undef
     if !defined $result
        or $result == -1
           && join("",$ss,$mm,$hh,$day,$month,$year)
                ne "59592331111969";
   return undef if $result < 0 && $year >= 1970;
   $result -= $zone;
 }
 else {
   $result = eval {
     local $SIG{__DIE__} = sub {}; # match Date::Parse behavior
     timelocal($ss,$mm,$hh,$day,$month,$year);
   };
   my @_neg1 = localtime(-1);
   $_neg1[5] += 1900;
   return undef
     if !defined $result
        or $result == -1
           && join("",$ss,$mm,$hh,$day,$month,$year)
                ne join("",@_neg1[0..5]);
   return undef if $result < 0 && $year >= 1971;
 }

 return $result + $frac;
}

1;

__END__


=head1 NAME

Date::Language - Language specific date formatting and parsing

=head1 SYNOPSIS

  use Date::Language;

  my $lang = Date::Language->new('German');
  $lang->time2str("%a %b %e %T %Y\n", time);

=head1 DESCRIPTION

L<Date::Language> provides objects to parse and format dates for specific languages. Available languages are

  Afar                    French                  Russian_cp1251
  Amharic                 Gedeo                   Russian_koi8r
  Austrian                German                  Sidama
  Brazilian               Greek                   Somali
  Chinese                 Hungarian               Spanish
  Chinese_GB              Icelandic               Swedish
  Czech                   Italian                 Tigrinya
  Danish                  Norwegian               TigrinyaEritrean
  Dutch                   Oromo                   TigrinyaEthiopian
  English                 Romanian                Turkish
  Finnish                 Russian                 Bulgarian
  Occitan

=head1 METHODS

=over

=item time2str

See L<Date::Format/time2str>

=item strftime

See L<Date::Format/strftime>

=item ctime

See L<Date::Format/ctime>

=item asctime

See L<Date::Format/asctime>

=item str2time

See L<Date::Parse/str2time>

=item strptime

See L<Date::Parse/strptime>

=back
