#!/usr/bin/env perl
#
# developed by Kow Kuroda
# created on 2022/05/07

use strict;
use warnings;

my $verbose = 0;
my $sid = 0;
my $splitter = ' ';
my $joint = "~";

while ( <> ) {
	if ( $verbose ) { print $_; }
	#
	if ( $_ =~ /-----/ ) {
			$sid++;
			if ($verbose) { printf "s%s begins.\n", $sid; }
			print "\n";
	}
	elsif ( $_ =~ /(\w+)\ +(\w+)\ +(\w+)\ +(['\w]+)\ +([^\n]+)\n/ ) {
		if ($verbose) { print "$1; $2; $3; $4; $5;\n"; }
		my $word = $4;
		my $tagged = $5;
		$tagged =~ s/[%@]//g; # remove offensive characters
		printf "%s_%s ", $word, join($joint, split($splitter, $tagged));
	}
}

### end of script
