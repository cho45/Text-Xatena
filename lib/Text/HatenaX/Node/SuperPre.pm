package Text::HatenaX::Node::SuperPre;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);
use Text::HatenaX::Util;

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^>\|\|$/)) {
        my $content = $s->scan_until(qr/^\|\|<$/);
        pop @$content;
        my $a = $class->new([join("\n", @$content)]);
        push @$parent, $a;
        return 1;
    }
}

sub as_html {
    my ($self) = @_;
    '<pre>' . escape_html(join "", @{ $self->children }) . '</pre>';
}

1;
__END__



