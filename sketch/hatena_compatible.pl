#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
sub p ($) { warn Dumper shift }

use Perl6::Say;

use lib glob 'modules/*/lib';
use lib 'lib';


use Text::HatenaX;


my $thx = Text::HatenaX->new;
no warnings "once", "redefine";
local $Text::HatenaX::Node::Section::BEGINNING = "";
local $Text::HatenaX::Node::Section::ENDOFNODE = "";
local *Text::HatenaX::Node::as_html_paragraph = sub {
	my ($self, $text, %opts) = @_;
	if ($opts{stopp}) {
		$text;
	} else {
		"<p>" . join("</p>\n<p><br /></p>\n<p>", map { join("</p>\n<p>", split /\n+/) } split(/\n\n\n/, $text)) . "</p>\n";
	}
};

say $thx->format(q{
* foo
aaa
bbb


ccc

** baz
bbb
});

