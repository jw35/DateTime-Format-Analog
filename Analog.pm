package DateTime::Format::Analog;

use strict;

use vars qw ($VERSION);

$VERSION = '0.003';

use DateTime;
use Carp;

sub parse_datetime {

  my $class = shift;
  my ($date,$base) = @_;

  #print "$date\n";
  
   if ($date =~ 
  /^([+-]?\d{2,})([+-]?\d{2,})([+-]?\d{2,})(:([+-]?\d{2,})([+-]?\d{2,}))?$/) {

    my ($yy,$MM,$dd,$hh,$mm) = ($1,$2,$3,$5,$6);
    #print "# |$yy|$MM|$dd|$hh|$mm|\n";

    my $datetime = 
      $base ? $base->clone : DateTime->now(time_zone => 'floating');
    $datetime->truncate(to => 'minute');

    if ($yy =~ /^[+-]/) {
      $datetime->add(years => $yy);
    }
    else {
      $datetime->set(year => $yy + ($yy <= 69 ? 2000 : 1900),  );
    }

    if ($MM =~ /^[+-]/) {
      $datetime->add(months => $MM);
    }
    else {
      $datetime->set(month => $MM);
    }

    if ($dd =~ /^[+-]/) {
      $datetime->add(days => $dd);
    }
    else {
      # don't set day off the end of the month
      my $eom = DateTime->last_day_of_month(year => $datetime->year, 
					    month => $datetime->month);
      $dd = $eom->day if $eom->day < $dd;
      $datetime->set(day => $dd);
    }

    if (defined($hh)) {
      # if we have time components
      if ($hh =~ /^[+-]/) {
	$datetime->add(hours => $hh);
      }
      else {
	$datetime->set(hour => $hh);
      }
      if ($mm =~ /^[+-]/) {
	$datetime->add(minutes => $mm);
      }
      else {
	$datetime->set(minute => $mm);
      }
    }
    else {
      # otherwise truncate
      $datetime->truncate(to => 'day');
    }
  }
  
  else {
    croak ("DateTime::Format::Analog: unreadable format, date was '$date'");
  }

}

1;

__END__

=head1 NAME

DateTime::Format::Analog - Parse date/time formats as used by Analog

=head1 SYNOPSIS

  use DateTime::Format::Analog;

  my $dt = DateTime::Format::Analog->parse_datetime( '-00-00-01:1800' );

  # On 1960-03-05T12:34:56 would give 1960-03-04T18:00:00

=head1 DESCRIPTION

This module understands the formats used by the web server log
analysis tool Analog (http://www.analog.cx/) for its 'FROM' and 'TO'
commands. The Analog manyal describes this format thusly:

=over 4

"There is also one other pair of commands which belongs in this
category, namely the C<FROM> and C<TO> commands. These specify a time period
to restrict the analysis to. The simplest usage of these commands is
C<FROM yyMMdd> or C<FROM yyMMdd:hhmm>, where C<yy> represents the last two
digits of the year (analog assumes that the year is between 1970 and
2069), C<MM> represents the month, C<dd> is the date, C<hh> the hour, and C<mm>
the minute. So, for example, to analyse only requests from 1st July
1999 to 1pm on 15th June 2000 I would use the configuration

  FROM 990701
  TO   000615:1300

"Alternatively, each of the components can be preceded by C<+> or C<->
to represent time relative to the time at which the program was
invoked. In this case, the date can have more than 2 digits. This
allows constructions like

  FROM -01-00+01   # from tomorrow last year
  TO -00-0131  # to the end of last month (OK even if last month
               # didn't have 31 days)
  FROM -00-00-112
  TO   -00-00-01  # statistics for the last 16 weeks
  FROM -00-00-00:-06+01  # statistics for the last 6 hours

"There are command line abbreviations +F and +T for the FROM and TO
commands; for example, +T-00-00-01:1800 looks at statistics until 6pm
yesterday. -F and -T turn off the from and to, as do FROM OFF and TO
OFF."

=back

=head1 METHODS

=over 4

=item * parse_datetime($string)

Given a value of the appropriate type, this method will return a new
C<DateTime> object.  The time zone for this object will always be the
floating time zone, because the Analog format does not include time
zone information, not UTC.

If given an improperly formatted string, this method may die.

=back

=head1 SUPPORT

Support for this module may be available from the author.

=head1 AUTHOR

Jon Warbrick <jon.warbrick@cam.ac.uk>

=head1 COPYRIGHT

Copyright (c) 2004 jon Warbrick and/or the University of Cambridge.
All rights reserved.  This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

=cut



