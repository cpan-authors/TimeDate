use Test::More tests => 324;
use Date::Format qw(ctime time2str);
use Date::Language;
use utf8;
my ($pkg, $t,$language);
$pkg = 'Date::Format::Generic';
while(<DATA>) {
  chomp;
  if (/^(\d+)/) {
    $t = $1;
    next;
  }
  elsif (/^(\w+)/) {
    $language = $1;
    $pkg = Date::Language->new($language);
    next;
  }

  my($fmt,$res) = split(/\t+/,$_);
  my $str = $pkg->time2str($fmt,$t,'GMT');
    is($str, $res,"$fmt");
}

__DATA__
936709362 # Tue Sep  7 11:22:42 1999 GMT
%y	99
%Y	1999
%%	%
%a	Tue
%A	Tuesday
%b	Sep
%B	September
%c	09/07/99 13:02:42
%C	Tue Sep  7 13:02:42 GMT 1999
%d	07
%e	 7
%D	09/07/99
%g	99
%G	1026
%h	Sep
%H	13
%I	01
%j	250
%k	13
%l	 1
%L	9
%m	09
%M	02
%o	 7th
%p	PM
%P	pm
%q	3
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%x	09/07/99
%X	13:02:42
%y	99
%Y	1999
%Z	GMT
%z	+0000
%F	1999-09-07
%u	2
%Od	VII
%Oe	VII
%OH	XIII
%OI	I
%Oj	CCL
%Ok	XIII
%Ol	I
%Om	IX
%OM	II
%Oq	III
%OY	MCMXCIX
%Oy	XCIX
German
%y	99
%Y	1999
%%	%
%a	Di
%A	Dienstag
%b	Sep
%B	September
%c	09/07/99 13:02:42
%C	Di Sep  7 13:02:42 GMT 1999
%d	07
%e	 7
%D	09/07/99
%h	Sep
%H	13
%I	01
%j	250
%k	13
%l	 1
%L	9
%m	09
%M	02
%o	 7.
%p	PM
%q	3
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%x	09/07/99
%X	13:02:42
%y	99
%Y	1999
%Z	GMT
%z	+0000
%F	1999-09-07
%u	2
%Od	VII
%Oe	VII
%OH	XIII
%OI	I
%Oj	CCL
%Ok	XIII
%Ol	I
%Om	IX
%OM	II
%Oq	III
%OY	MCMXCIX
%Oy	XCIX
French
%y	99
%Y	1999
%%	%
%a	mar
%A	mardi
%b	sep
%B	septembre
%c	09/07/99 13:02:42
%C	mar sep  7 13:02:42 GMT 1999
%d	07
%e	 7
%D	09/07/99
%h	sep
%H	13
%I	01
%j	250
%k	13
%l	 1
%L	9
%m	09
%M	02
%o	 7e
%p	PM
%q	3
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%x	09/07/99
%X	13:02:42
%y	99
%Y	1999
%Z	GMT
%z	+0000
%F	1999-09-07
%u	2
915192000 # Fri Jan  1 12:00:00 1999 GMT
%o	 1er
%A	vendredi
936709362 # Tue Sep  7 11:22:42 1999 GMT
Italian
%y	99
%Y	1999
%%	%
%a	Mar
%A	Martedì
%b	Set
%B	Settembre
%c	09/07/99 13:02:42
%C	Mar Set  7 13:02:42 GMT 1999
%d	07
%e	 7
%D	09/07/99
%h	Set
%H	13
%I	01
%j	250
%k	13
%l	 1
%L	9
%m	09
%M	02
%o	 7th
%p	PM
%q	3
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%x	09/07/99
%X	13:02:42
%y	99
%Y	1999
%Z	GMT
%z	+0000
%F	1999-09-07
%u	2
%Od	VII
%Oe	VII
%OH	XIII
%OI	I
%Oj	CCL
%Ok	XIII
%Ol	I
%Om	IX
%OM	II
%Oq	III
%OY	MCMXCIX
%Oy	XCIX
315964800	# Sun Jan  6 00:00:00 1980 GMT
%u	7
%w	0
%F	1980-01-06
316648800	# Wed Jan  14 00:00:00 1980
%G	1	#0 is interpreted as empty string
Bulgarian
1283926923 # ср сеп  8 09:22:03 EET 2010 /Tue Sep 06:22:03 GMT 2010
%y	10
%Y	2010
%%	%
%a	ср
%A	сряда
%b	сеп
%B	септември
%c	09/08/10 06:22:03
%C	ср сеп  8 06:22:03 GMT 2010
%d	08
%e	 8
%D	09/08/10
%G	1600
%h	сеп
%H	06
%I	06
%j	251
%k	 6
%l	 6
%L	9
%m	09
%M	22
%o	 8ми
%p	AM
%q	3
%r	06:22:03 AM
%R	06:22
%s	1283926923
%S	03
%T	06:22:03
%U	36
%w	3
%W	36
%x	09/08/10
%X	06:22:03
%Z	GMT
%z	+0000
%z	+0000
%F	2010-09-08
%u	3
%Od	VIII
%Oe	VIII
%OH	VI
%OI	VI
%Oj	CCLI
%Ok	VI
%Ol	VI
%Om	IX
%OM	XXII
%Oq	III
%OY	MMX
%Oy	X
936709362 # Tue Sep  7 13:02:42 1999 GMT
Portuguese
%y	99
%Y	1999
%%	%
%a	ter
%A	terça-feira
%b	set
%B	setembro
%c	09/07/99 13:02:42
%C	ter set  7 13:02:42 GMT 1999
%d	07
%e	 7
%D	09/07/99
%h	set
%H	13
%I	01
%j	250
%k	13
%l	 1
%L	9
%m	09
%M	02
%o	 7º
%p	PM
%q	3
%r	01:02:42 PM
%R	13:02
%s	936709362
%S	42
%T	13:02:42
%U	36
%w	2
%W	36
%x	09/07/99
%X	13:02:42
%y	99
%Y	1999
%Z	GMT
%z	+0000
%F	1999-09-07
%u	2
%Od	VII
%Oe	VII
%OH	XIII
%OI	I
%Oj	CCL
%Ok	XIII
%Ol	I
%Om	IX
%OM	II
%Oq	III
%OY	MCMXCIX
%Oy	XCIX
936709362 # Tue Sep  7 13:02:42 1999 GMT (PM)
Dutch
%p	NM
%P	nm
%a	di
%A	dinsdag
1283926923 # Wed Sep  8 06:22:03 2010 GMT (AM)
%p	VM
%P	vm
1767182400 # Wed Dec 31 12:00:00 2025 GMT — ISO week 1 of 2026
%g	26
%V	01
%y	25
1451649600 # Fri Jan  1 12:00:00 2016 GMT — ISO week 53 of 2015
%g	15
%V	53
%y	16
1419854400 # Mon Dec 29 12:00:00 2014 GMT — ISO week 1 of 2015
%g	15
%V	01
%y	14
