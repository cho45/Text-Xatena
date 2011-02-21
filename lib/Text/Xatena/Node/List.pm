package Text::Xatena::Node::List;

use strict;
use warnings;
use base qw(Text::Xatena::Node);
use constant {
    UL => qr/^-/,
    OL => qr/^\+/,
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
    my ($self, %opts) = @_;
    $self->_as_html($self->as_struct, %opts);
}

sub _as_html {
    my ($self, $obj, %opts) = @_;
    my $ret = "<" . $obj->{name} . ">";
    $ret .= "\n" unless $obj->{name} eq 'li';
    for my $child (@{ $obj->{children} }) {
        if (ref($child)) {
            $ret .= $self->_as_html($child, %opts);
        } else {
            $ret .= $self->inline($child, %opts);
        }
    }
    $ret .= "</" . $obj->{name} . ">\n";
    $ret;
}


1;
__END__



