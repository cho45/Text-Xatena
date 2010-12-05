package Text::Xatena::Test;

use strict;
use warnings;
use Test::Base -Base;
use HTML::Parser;
use Data::Dumper;
use UNIVERSAL::require;
use HTML::Entities;
use Test::Differences;

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
    eq_or_diff(html($got), html($expected), $desc);
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

    my $root  = [ root => {} => [] ];
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

    my $ret = [];
    my $walker; $walker = sub {
        my ($parent, $level) = @_;
        my ($tag, $attr, $children) = @$parent;

        my $a = join ' ', map { sprintf('%s="%s"', $_,  encode_entities($attr->{$_})) } sort { $a cmp $b } keys %$attr;
        my $has_element = grep { ref($_) } @$children;
        if ($has_element) {
            push @$ret, sprintf('%s<%s%s>', "  " x $level, $tag, $a ? " $a" : "");
            for my $node (@$children) {
                if (ref($node)) {
                    $walker->($node, $level + 1);
                } else {
                    push @$ret, $node;
                }
            }
            push @$ret, sprintf('%s</%s>', "  " x $level, $tag);
        } else {
            push @$ret, sprintf('%s<%s%s>%s</%s>', "  " x $level, $tag, $a ? " $a" : "", join(' ', @$children), $tag);
        }
    };
    $walker->($root, 0);

    $ret;
}



1;
