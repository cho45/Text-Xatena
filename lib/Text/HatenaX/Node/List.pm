package Text::HatenaX::Node::List;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    for my $l (qw/- +/) {
        my $l = quotemeta $l;
        if ($s->scan(qr/^$l/)) {
            my $node = $class->new([ $s->matched->[0] ]);
            until ($s->eos || !$s->scan(qr/^$l/)) {
                push @$node, $s->matched->[0];
            }
            push @$parent, $node;
            return 1;
        }
    }
}

sub as_struct {
    my ($self) = @_;

    my $stack = [ { children => [] } ];
    my $children = $self->children;

    for my $line (@$children) {
        my ($symbol, $text) = ($line =~ /^([-+]+)(.+)$/);
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
    my $ret = "<" . $obj->{name} . ">\n";
    for my $child (@{ $obj->{children} }) {
        if (ref($child)) {
            $ret .= $self->_as_html($child, %opts);
        } else {
            $ret .= $child;
        }
    }
    $ret .= "</" . $obj->{name} . ">\n";
    $ret;
}


1;
__END__



