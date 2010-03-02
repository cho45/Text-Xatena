package Text::HatenaX::Node::Blockquote;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub beginning { qr/^>(.*?)>$/ };
sub endofnode { qr/^<<$/ };

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan($class->beginning)) {
        my $node = $class->new;
        $node->{beginning} = $s->matched;
        push @$parent, $node;
        push @$stack, $node;
        return 1;
    }
    if ($s->scan($class->endofnode)) {
        my $node = pop @$stack;
        ref($node) eq $class or warn sprintf("syntax error: unmatched syntax got:%s expected:%s", ref($node), $class);
        $node->{endofnode} = $s->matched;
        return 1;
    }
}

sub as_html {
    my ($self, %opts) = @_;
    if ($self->{beginning}->[1]) {
        sprintf('<blockquote cite="%s">%s</blockquote>',
            $self->{beginning}->[1],
            $self->SUPER::as_html(%opts)
        );
    } else {
        '<blockquote>' . $self->SUPER::as_html(%opts) . '</blockquote>';
    }
}

1;
__END__



