use strict;
use warnings;
use lib 'lib';
use lib 't/lib';
use Test::More;
use Text::HatenaX;
use Encode;
use Text::HatenaX::Test;
use Text::HatenaX::Test::MyInline;

plan tests => 2;

sub u8 ($) {
    decode_utf8(shift);
}

sub is_u8 ($;$) {
    ok utf8::is_utf8(shift), shift;
}

subtest "basic" => sub {
    my $thx = Text::HatenaX->new;
    isa_ok $thx, "Text::HatenaX";
    ok $thx->format('foobar');
    is_u8 $thx->format(u8 'あああ'), 'format takes utf8 strings';
    done_testing;
};

subtest "replace inline" => sub {
    my $thx = Text::HatenaX->new;
    is_html $thx->format('TEST'), "<p>TEST</p>";
    {
        is_html $thx->format('TEST', inline => Text::HatenaX::Test::MyInline->new), "<p>XXXX</p>";
        is_html $thx->format('http://example.com/'), '<p><a href="http://example.com/">http://example.com/</a></p>';
    };
    is_html $thx->format('TEST'), "<p>TEST</p>";

    done_testing;
};


