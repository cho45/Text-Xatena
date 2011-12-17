package Text::Xatena::Node::Blockquote;

use strict;
use warnings;
use base qw(Text::Xatena::Node);
use constant {
    BEGINNING => qr/^>(.*?)>$/,
    ENDOFNODE => qr/^<<$/,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(BEGINNING)) {
        my $node = $class->new;
        $node->{beginning} = $s->matched;
        push @$parent, $node;
        push @$stack, $node;
        return 1;
    }
    if ($s->scan(ENDOFNODE)) {
        pop @$stack while ref($stack->[-1]) eq 'Text::Xatena::Node::Section';
        my $node = pop @$stack;
        ref($node) eq $class or warn sprintf("syntax error: unmatched syntax got:%s expected:%s", ref($node), $class);
        $node->{endofnode} = $s->matched;
        return 1;
    }
}

sub as_html {
    my ($self, $context, %opts) = @_;

    my $text   = $self->{beginning}->[1];

    my ($title, $uri);
    if ($text =~ /^http/) {
        $title = $context->inline->format('[' . $text . ']');
    } else {
        $title = $context->inline->format($text);
    }
    my ($uri) = ($title =~ m{(https?://[^\s"':]+)});

    $context->_tmpl(__PACKAGE__, q[
        <blockquote {{if ($cite) { }}cite="{{= $cite }}"{{ } }}>
            {{= $content }}
            {{ if ($title) { }}
            <cite>{{= $title }}</cite>
            {{ } }}
        </blockquote>
    ], {
        cite    => $uri,
        title   => $title,
        content => $self->SUPER::as_html($context, %opts),
    });
}

1;
__END__



