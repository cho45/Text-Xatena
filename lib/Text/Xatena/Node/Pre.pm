package Text::Xatena::Node::Pre;

use strict;
use warnings;
use base qw(Text::Xatena::Node::StopP);
use constant {
    BEGINNING => qr/^>\|$/,
    ENDOFNODE => qr/^(.*?)\|<$/,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(BEGINNING)) {
        my $node = $class->new;
        push @$parent, $node;
        push @$stack, $node;
        return 1;
    }

    if ($s->scan(ENDOFNODE)) {
        push @$parent, $s->matched->[1];
        my $node = pop @$stack;
        ref($node) eq $class or warn sprintf("syntax error: unmatched syntax got:%s expected:%s", ref($node), $class);
        return 1;
    }
}

sub as_html {
    my ($self, %opts) = @_;
    '<pre>' . $self->SUPER::as_html(%opts, stopp => 1) . '</pre>';
}

1;
__END__



