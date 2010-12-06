package Text::Xatena::Node::Blockquote;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

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
        my $url = $self->{beginning}->[1];
        sprintf("<blockquote cite=\"%s\">\n%s\n<cite><a href=\"%s\">%s</a></cite>\n</blockquote>\n",
            $url,
            $self->SUPER::as_html(%opts),
            $url,
            $url,
        );
    } else {
        "<blockquote>\n" . $self->SUPER::as_html(%opts) . "</blockquote>\n";
    }
}

1;
__END__



