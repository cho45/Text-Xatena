use strict;
use warnings;
use lib 'lib';
use lib 't/lib';
use Test::More;
use Text::Xatena;
use Encode;
use Text::Xatena::Test;
use Text::Xatena::Test::MyInline;
use Test::HTML::Differences;

plan tests => 3;

sub u8 ($) {
    decode_utf8(shift);
}

sub is_u8 ($;$) {
    ok utf8::is_utf8(shift), shift;
}

subtest "basic" => sub {
    my $thx = Text::Xatena->new;
    isa_ok $thx, "Text::Xatena";
    ok $thx->format('foobar');
    is_u8 $thx->format(u8 'あああ'), 'format takes utf8 strings';
    done_testing;
};

subtest "replace inline" => sub {
    my $thx = Text::Xatena->new;
    is $thx->format('TEST'), "<p>TEST</p>\n";
    {
        is $thx->format('TEST', inline => Text::Xatena::Test::MyInline->new), "<p>XXXX</p>\n";
        is $thx->format('http://example.com/'), qq{<p><a href="http://example.com/">http://example.com/</a></p>\n};
    };
    is $thx->format('TEST'), "<p>TEST</p>\n";

    done_testing;
};

subtest "replace block" => sub {
    my $thx = Text::Xatena->new(syntaxes => [
    ]);
    eq_or_diff_html $thx->format(">>\nquote\n<<"), "<p>>><br />quote<br /><<</p>";

    done_testing;
};


