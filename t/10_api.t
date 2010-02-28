use strict;
use warnings;
use lib 'lib';
use lib 't/lib';
use Test::More;
use Text::HatenaX;
use Encode;

sub u8 ($) {
    decode_utf8(shift);
}

sub is_u8 ($) {
    ok utf8::is_utf8(shift);
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
    is $thx->format('TEST'), "<p>TEST</p>\n";
    {
        local $Text::HatenaX::Node::INLINE = "Text::HatenaX::Test::MyInline";
        is $thx->format('TEST'), "<p>XXXX</p>\n";
    };
    is $thx->format('TEST'), "<p>TEST</p>\n";

    done_testing;
};


done_testing;

