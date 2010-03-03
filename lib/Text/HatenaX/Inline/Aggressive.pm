package Text::HatenaX::Inline::Aggressive;

use strict;
use warnings;
use URI::Escape;
use Text::HatenaX::Inline -Base;

match qr<\[((?:https?|ftp)://[^\s:]+)(:(?:title(?:=([^[]+))?|barcode))?\]>i => sub {
    my ($self, $uri, $opt, $title) = @_;
    if ($opt && $opt =~ /:barcode/) {
        sprintf('<img src="http://chart.apis.google.com/chart?chs=150x150&cht=qr&chl=%s" title="%s"/>',
            uri_escape($uri),
            $uri,
        );
    } else {
        sprintf('<a href="%s">%s</a>',
            $uri,
            $title || $uri
        );
    }
};




1;
__END__



