package Text::HatenaX::Test;

use strict;
use warnings;
use Test::Base -Base;
use HTML::Parser;
use Data::Dumper;

use Text::HatenaX;

filters {
    input => [qw/chomp/],
    expected => [qw/chomp/],
};

our @EXPORT = qw(run_html);

sub thx ($);
sub html ($);

sub run_html {
    run {
        my ($block) = @_;
        my $input = $block->input;
        my $expected = html $block->expected;
        my $got = html thx $input;
        is_deeply($got, $expected, $block->name) or warn sprintf("expected:\n%s\n\n%s\ngot:\n%s\n\n%s\n",
            scalar $block->expected,
            Dumper $expected,
            scalar thx($input),
            Dumper $got,
        );
    }
}

sub thx ($) {
    my ($str) = @_;
    my $thx = Text::HatenaX->new;
    my $ret = $thx->format($str);
    $ret;
}

sub html ($) {
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
            comment => [
                sub {
                    my ($text) = @_;
                    push @{ $stack->[-1]->[2] }, $text;
                },
                "text"
            ],
            text  => [
                sub {
                    my ($dtext) = @_;
                    $dtext =~ s/^\s+|\s+$//g;
                    push @{ $stack->[-1]->[2] }, $dtext if $dtext =~ /\S/;
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



1;
