package Text::HatenaX::Test;

use strict;
use warnings;
use Test::Base -Base;

use Text::HatenaX;

filters {
    input => [qw/thx chomp html/],
    expected => [qw/html/],
};

package Text::HatenaX::Test::Filter;
use Test::Base::Filter -base;
use HTML::Parser;

sub html {
    my ($s) = @_;
    my $root  = [ tag => attr => [] ];
    my $stack = [ $root ];
    my $p = HTML::Parser->new(
        api_version => 3,
        handlers => {
            start => [
                sub {
                    my ($tagname, $attr) = @_;
                    my $e = [
                        $tagname => $attr => []
                    ];
                    push @{ $stack->[-1]->[2] }, $e;
                    push @$stack, $e;
                },
                "tagname, attr"
            ],
            end => [
                sub {
                    pop @$stack;
                },
                "tagname",
            ],
            text  => [
                sub {
                    my ($dtext) = @_;
                    $dtext =~ s/^\s+|\s+$//g;
                    push @{ $stack->[-1]->[2 ]}, $dtext if $dtext =~ /\S/;
                },
                "dtext"
            ]
        }
    );
    $p->unbroken_text(1);
    $p->empty_element_tags(1);
    $p->parse($s);
    $p->eof;

    $root;
}

sub thx {
    my $thx = Text::HatenaX->new;
    $thx->format(shift);
}


1;
