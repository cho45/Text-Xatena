package Text::HatenaX::Inline;

use strict;
use warnings;
use Regexp::Assemble;
use URI::Escape;

our $inlines = [];

sub match ($$) { ## no critic
    my ($regexp, $block) = @_;
    push @$inlines, { regexp => $regexp, block => $block };
}

sub new {
    my ($class, %opts) = @_;
    bless {
        %opts
    }, $class;
}

sub format {
    my ($self, $text) = @_;
    my $re = join("|", map { $_->{regexp} } @$inlines);
    $text =~ s{($re)}{$self->_format($1)}ego;
    $text;
}

sub _format {
    my ($self, $string) = @_;
    for my $inline (@$inlines) {
        if (my @matched = ($string =~ $inline->{regexp})) {
            $string = $inline->{block}->($self, @matched);
            last;
        }
    }
    $string;
}

match qr{(<a[^>]+>[\s\S]*?</a>)}i => sub {
    my ($self, $tag) = @_;
    $tag;
};

match qr{\[\]([\s\S]*?)\[\]}i => sub {
    my ($self, $unlink) = @_;
    $unlink;
};

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

match qr<\[?((?:https?|ftp):[^\s:]+)\]?>i => sub {
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


