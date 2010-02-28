package Text::HatenaX::Node::DefinitionList;

use strict;
use warnings;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^:/)) {
        my $node = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(qr/^:/)) {
            push @$node, $s->matched->[0];
        }
        push @$parent, $node;
        return 1;
    }
}

sub as_struct {
    my ($self) = @_;
    my $ret = [];

    my $children = $self->children;

    for my $line (@$children) {
        my ($title, $description) = ($line =~ /^:([^:]+)(?::(.*))?$/);
        push @$ret, +{
            name => 'dt',
            children => [ $title ],
        };
        push @$ret, +{
            name => 'dd',
            children => [ $description ],
        };
    }

    $ret;
}

sub as_html {
    my ($self, %opts) = @_;
    $Text::HatenaX::Node::INLINE->use;

    my $ret = "<dl>\n";
    for my $e (@{ $self->as_struct }) {
        $ret .= sprintf("<%s>%s</%s>\n",
            $e->{name},
            $Text::HatenaX::Node::INLINE->new(%opts)->format(join("", @{ $e->{children} })),
            $e->{name}
        );
    }
    $ret .= "</dl>\n";
    $ret;
}



1;
__END__


