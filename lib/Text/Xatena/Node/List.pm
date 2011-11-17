package Text::Xatena::Node::List;

use strict;
use warnings;
use base qw(Text::Xatena::Node);
use constant {
    UL => qr/^-.+/,
    OL => qr/^\+.+/,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;

    if ($s->scan(UL)) {
        my $node = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(UL)) {
            push @$node, $s->matched->[0];
        }
        push @$parent, $node;
        return 1;
    }

    # same as above except regexp (unrolled for performance)
    if ($s->scan(OL)) {
        my $node = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(OL)) {
            push @$node, $s->matched->[0];
        }
        push @$parent, $node;
        return 1;
    }
}

sub as_struct {
    my ($self) = @_;

    my $stack = [ { children => [] } ];
    my $children = $self->children;

    for my $line (@$children) {
        my ($symbol, $text) = ($line =~ /^([-+]+)\s*(.+)$/);
        my $level = length($symbol);
        pop @$stack while (scalar @$stack > $level * 2);
        while (scalar @$stack < $level * 2) {
            my $node = +{
                name     => (substr($line, $level - 1, 1) eq '+' ? 'ol' : 'ul'),
                children => []
            };

            push @{ $stack->[-1]->{children} }, $node if @$stack;
            push @$stack, $node;
        }

        my $node = +{
            name     => 'li',
            children => [ $text ]
        };
        push @{ $stack->[-1]->{children} }, $node;
        push @$stack, $node;
    }

    $stack->[1];
}

sub as_html {
    my ($self, $context, %opts) = @_;
    $self->_as_html($context, $self->as_struct, %opts);
}

sub _as_html {
    my ($self, $context, $obj, %opts) = @_;

    if ($obj->{name} eq 'li') {
        join('', map { ref($_) ? $self->_as_html($context, $_, %opts) : $context->inline->format($_) } @{ $obj->{children} } );
    } else {
        $context->_tmpl(__PACKAGE__, q[
            <{{= $name }}>
            ? for (@$items) {
            <li>{{= $_ }}</li>
            ? }
            </{{= $name }}>
        ], {
            name  => $obj->{name},
            items => [ map { $self->_as_html($context, $_, %opts) } @{ $obj->{children} } ]
        });
    }
}


1;
__END__



