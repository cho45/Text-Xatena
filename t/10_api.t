use strict;
use warnings;
use lib 'lib';
use lib 't/lib';
use Test::More;
use Text::Xatena;
use Encode;
use Text::Xatena::Test;
use Text::Xatena::Test::MyInline;

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
    is_html $thx->format('TEST'), "<p>TEST</p>";
    {
        is_html $thx->format('TEST', inline => Text::Xatena::Test::MyInline->new), "<p>XXXX</p>";
        is_html $thx->format('http://example.com/'), '<p><a href="http://example.com/">http://example.com/</a></p>';
    };
    is_html $thx->format('TEST'), "<p>TEST</p>";

    done_testing;
};

subtest "replace block" => sub {
    my $thx = Text::Xatena->new(syntaxes => [
    ]);
    is_html $thx->format(">>\nquote\n<<"), "<p>>><br />quote<br /><<</p>";

    done_testing;
};


