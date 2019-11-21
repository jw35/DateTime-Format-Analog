use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'		=> 'DateTime::Format::Analog',
    'VERSION_FROM'	=> 'Analog.pm',                # finds $VERSION
    'PREREQ_PM'		=> { DateTime => 0,
			   }
);
