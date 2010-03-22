package Text::Xatena::Test;

use strict;
use warnings;
use Test::Base -Base;
use HTML::Parser;
use Data::Dumper;
use UNIVERSAL::require;

use lib 'lib';
use Text::Xatena;
our $options = {};

filters {
    input => [qw/chomp/],
    expected => [qw/chomp/],
};

our @EXPORT = qw(run_html is_html);
our $INLINE = "";
our $INLINE_ARGS = [];

sub thx ($);
sub html ($);

sub run_html {
    run {
        my ($block) = @_;
        my $input = $block->input;
        my $expected = $block->expected;
        my $got = thx $input;
        is_html($got, $expected, $block->name);
    }
}

sub is_html ($$;$) {
    my ($got, $expected, $desc) = @_;
    is_deeply(html($got), html($expected), $desc) or warn sprintf("expected:\n%s\ngot:\n%s\n",
        scalar $expected,
        scalar $got,
    );
}

sub thx ($) {
    my ($str) = @_;
    my $thx = Text::Xatena->new(%{ $options });
    $INLINE->use if $INLINE;
    my $ret = $thx->format($str, inline => $INLINE ? $INLINE->new(@{ $INLINE_ARGS }) : undef );
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
