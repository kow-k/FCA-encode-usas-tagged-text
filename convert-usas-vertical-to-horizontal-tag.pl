#!/usr/bin/env perl
#
# developed by Kow Kuroda
# created on 2022/05/07
# modified on 2022/05/14

# modules
use strict;
use warnings;

# variables
my $verbose = 0;
my $sid = 0;
my $tag_sep = ' ';
my $tag_joint = "~";

# main
while ( <> ) {
	my $line = $_;
	if ( $verbose ) { print $line; }
	# detect a sentence
	if ( $line =~ /-----/ ) {
			$sid++;
			if ( $verbose ) { printf "s%s begins.\n", $sid; }
			print "\n";
	}
	# parse lines of vertical mode and generate tag concatenations
	if ( $line =~ /(\w+)\ +(\w+)\ +(\w+)\ +(['\w]+)\ +([^\n]+)\n/ ) {
		if ($verbose) { print "#parse: $1; $2; $3; $4; $5;\n"; }
		my $word = $4;
		my $tags = $5;
		$tags =~ s/[%@]//g; # remove offensive characters
		printf "%s_%s ", $word, join($tag_joint, split($tag_sep, $tags));
	}
}

### end of script
