package Text::Xatena::Node::DefinitionList;

use strict;
use warnings;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^:([^:]*):(.*)/)) {
        my $node = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(qr/^:([^:]*):(.*)/)) {
            push @$node, $s->matched->[0];
        }
        push @$parent, $node;
        return 1;
    }
}

## NOT COMPATIBLE WITH Hatena Syntax
sub as_struct {
    my ($self) = @_;
    my $ret = [];

    my $children = $self->children;

    for my $line (@$children) {
        if (my ($description) = ($line =~ /^::(.+)/)) {
            push @$ret, +{
                name => 'dd',
                children => [ $description ],
            };
        } else {
            my ($title, $description) = ($line =~ /^:([^:]+)(?::(.*))?$/);
            push @$ret, +{
                name => 'dt',
                children => [ $title ],
            };
            push @$ret, +{
                name => 'dd',
                children => [ $description ],
            } if $description;
        }
    }

    $ret;
}

sub as_html {
    my ($self, %opts) = @_;

    my $ret = "<dl>\n";
    for my $e (@{ $self->as_struct }) {
        $ret .= sprintf("<%s>%s</%s>\n",
            $e->{name},
            $self->inline(join("", @{ $e->{children} }), %opts),
            $e->{name}
        );
    }
    $ret .= "</dl>\n";
    $ret;
}



1;
__END__



