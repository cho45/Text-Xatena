package Text::Xatena::Node::StopP;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^>(<.+>)(<)?$/)) {
        my $node = $class->new([ $s->matched->[1] ]);
        push @$parent, $node;
        if (!$s->matched->[2]) {
            push @$stack, $node;
        }
        return 1;
    }

    if ($s->scan(qr/^(.+>)<$/)) {
        my $node = pop @$stack;
        push @$node, $s->matched->[1];
        ref($node) eq $class or warn sprintf("syntax error: unmatched syntax got:%s expected:%s", ref($node), $class);
        return 1;
    }
}

sub as_html {
    my ($self, %opts) = @_;
    $self->SUPER::as_html(%opts, stopp => 1);
}

1;
__END__



