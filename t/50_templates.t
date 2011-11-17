use utf8;
use strict;
use warnings;
use lib 'lib';
use lib 't/lib';

use Encode;
use Test::More;
use Test::HTML::Differences;

use Text::Xatena;
use Text::Xatena::Util;

subtest html5 => sub {
    my $thx = Text::Xatena->new(
        templates => {
            'Text::Xatena::Node::Section' => q[
                <section class="level-{{= $level }}">
                    <h1>{{= $title }}</h1>
                    {{= $content }}
                </section>
            ],
            'Text::Xatena::Node::Blockquote' => q[
                <figure>
                ? if ($cite) {
                    <blockquote cite="{{= $cite }}">
                        {{= $content }}
                    </blockquote>
                    <figcaption>
                        <cite><a href="{{= $cite }}">{{= $cite }}</a></cite>
                    </figcaption>
                ? } else {
                    <blockquote>
                        {{= $content }}
                    </blockquote>
                ? }
                </figure>
            ],
        },
    );

    eq_or_diff_html $thx->format(unindent q{
        * foobar

        baz

        >http://example.com/>
        quote
        <<

        * piyo
    }), q{
        <section class="level-1">
            <h1>foobar</h1>
            <p>baz</p>
            <figure>
                <blockquote cite="http://example.com/">
                    <p>quote</p>
                </blockquote>
                <figcaption>
                    <cite><a href="http://example.com/">http://example.com/</a></cite>
                </figcaption>
            </figure>
        </section>

        <section class="level-1">
            <h1>piyo</h1>
        </section>
    };
};

done_testing;
