#!/usr/bin/perl -w
use strict;
 
#use Test::More tests => 7;
use Test::More qw(no_plan);
use Test::Exception;
 
BEGIN { use_ok('DateTime::Format::Analog'); };

can_ok('DateTime::Format::Analog','parse_datetime');

my @abs_dates = 
  ( [ '990101', '1999-01-01T00:00:00' ],
    [ '000101', '2000-01-01T00:00:00' ], 
    [ '000102', '2000-01-02T00:00:00' ], 
    [ '000202', '2000-02-02T00:00:00' ],
    [ '000202:1234', '2000-02-02T12:34:00' ],

    [ '990701', '1999-07-01T00:00:00' ],
    [ '000615:1300', '2000-06-15T13:00:00' ],
    
  );

foreach my $test (@abs_dates) {
  is (DateTime::Format::Analog->parse_datetime($test->[0])->datetime,
      $test->[1], "trying $test->[0]");
}

lives_ok { DateTime::Format::Analog->parse_datetime('001231') } 'valid day';
dies_ok { DateTime::Format::Analog->parse_datetime('001301') } 'invalid day';
dies_ok { DateTime::Format::Analog->parse_datetime('Foo') } 'invalid format';

my $base = DateTime->new (year   => 1960,
			  month  => 3,
			  day    => 5,
			  hour   => 12,
                          minute => 34,
			  second => 56,
			  );

my @rel_dates = 
  ( [ '+00+00+00',   '1960-03-05T00:00:00' ],

    [ '+01+00+00',   '1961-03-05T00:00:00' ],
    [ '+0001+00+00', '1961-03-05T00:00:00' ],
    [ '-01+00+00',   '1959-03-05T00:00:00' ],

    [ '+00+01+00',   '1960-04-05T00:00:00' ],
    [ '+00+0001+00', '1960-04-05T00:00:00' ],
    [ '+00+12+00',   '1961-03-05T00:00:00' ],
    [ '+00-01+00',   '1960-02-05T00:00:00' ],
    [ '+00-12+00',   '1959-03-05T00:00:00' ],

    [ '+00+00+01',   '1960-03-06T00:00:00' ],
    [ '+00+00+0001', '1960-03-06T00:00:00' ],
    [ '+00+00+31',   '1960-04-05T00:00:00' ],
    [ '+00+00+365',  '1961-03-05T00:00:00' ],
    [ '+00+00-01',   '1960-03-04T00:00:00' ],
    [ '+00+00-29',   '1960-02-05T00:00:00' ],
    [ '+00+00-366',  '1959-03-05T00:00:00' ],

    [ '00+00+00',    '2000-03-05T00:00:00' ],
    [ '+0001+00',    '1960-01-05T00:00:00' ],
    [ '+00+0001',    '1960-03-01T00:00:00' ],

    [ '0001+00',     '2000-01-05T00:00:00' ],
    [ '00+0001',     '2000-03-01T00:00:00' ],
    [ '+000101',     '1960-01-01T00:00:00' ],
    
    [ '+00+0030',    '1960-03-30T00:00:00' ],
    [ '+00+0031',    '1960-03-31T00:00:00' ],
    [ '+00+0032',    '1960-03-31T00:00:00' ],

    [ '+00-0128',    '1960-02-28T00:00:00' ],
    [ '+00-0129',    '1960-02-29T00:00:00' ],
    [ '+00-0130',    '1960-02-29T00:00:00' ],

    [ '+00+00+00:+00+00',     '1960-03-05T12:34:00' ],
    [ '+00+00+00:+01+00',     '1960-03-05T13:34:00' ],
    [ '+00+00+00:+0001+00',   '1960-03-05T13:34:00' ],
    [ '+00+00+00:+12+00',     '1960-03-06T00:34:00' ],
    [ '+00+00+00:-01+00',     '1960-03-05T11:34:00' ],
    [ '+00+00+00:-13+00',     '1960-03-04T23:34:00' ],

    [ '+00+00+00:+00+01',     '1960-03-05T12:35:00' ],
    [ '+00+00+00:+00+0001',   '1960-03-05T12:35:00' ],
    [ '+00+00+00:+00+26',     '1960-03-05T13:00:00' ],
    [ '+00+00+00:+00-01',     '1960-03-05T12:33:00' ],
    [ '+00+00+00:+00-35',     '1960-03-05T11:59:00' ],
    
    [ '+00+00+00:00+00',      '1960-03-05T00:34:00' ],
    [ '+00+00+00:+0000',      '1960-03-05T12:00:00' ],
    [ '+00+00+00:0000',       '1960-03-05T00:00:00' ],

    [ '-01-00+01',            '1959-03-06T00:00:00' ],
    [ '-00-0131',             '1960-02-29T00:00:00' ],
    [ '-00-00-112',           '1959-11-14T00:00:00' ],
    [ '-00-00-01',            '1960-03-04T00:00:00' ],
    [ '-00-00-00:-06+01',     '1960-03-05T06:35:00' ],
    [ '-00-00-01:1800',       '1960-03-04T18:00:00' ],

  );

foreach my $test (@rel_dates) {
  is (DateTime::Format::Analog->parse_datetime($test->[0],$base)->datetime,
      $test->[1], "trying $test->[0]");
}




