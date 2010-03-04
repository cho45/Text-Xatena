package Text::Xatena::Inline;

use strict;
use warnings;
use Text::Xatena::Inline::Base -Base;

match qr{(<a[^>]+>[\s\S]*?</a>)}i => sub {
    my ($self, $anchor) = @_;
    $anchor;
};

match qr{(<[^>]+>)}i => sub {
    my ($self, $tag) = @_;
    $tag;
};

match qr{\[\]([\s\S]*?)\[\]}i => sub {
    my ($self, $unlink) = @_;
    $unlink;
};

match qr<\[?((?:https?|ftp):(?!([^\s<>\]]+?):(?:barcode|title))([^\s<>\]]+))\]?>i => sub {
    my ($self, $uri) = @_;
    sprintf('<a href="%s">%s</a>',
        $uri,
        $uri
    );
};

match qr<\[?mailto:([^\s\@:?]+\@[^\s\@:?]+(\?[^\s]+)?)\]?>i => sub {
    my ($self, $uri) = @_;
    sprintf('<a href="mailto:%s">%s</a>',
        $uri,
        $uri
    );
};


1;
__END__



