package Text::Xatena::Node::Table;

use strict;
use warnings;
use base qw(Text::Xatena::Node);
use constant {
    TABLE => qr/^\|/,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(TABLE)) {
        my $a = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(TABLE)) {
            push @$a, $s->matched->[0];
        }
        push @$parent, $a;
        return 1;
    }
}

sub as_struct {
    my ($self) = @_;
    my $ret = [];
    my $children = $self->children;

    for my $line (@$children) {
        my $row = [];
        for my $col (split /\|/, $line) {
            my ($th, $content) = ($col =~ /^(\*)?(.*)$/);
            push @$row, +{
                name => ($th ? 'th' : 'td'),
                children => [ $content ],
            };
        }
        shift @$row;
        push @$ret, $row;
    }

    $ret;
}

sub as_html {
    my ($self, %opts) = @_;
    my $ret  = "<table>\n";
    for my $row (@{ $self->as_struct }) {
        $ret .= "<tr>\n";
        for my $col (@$row) {
            $ret .= sprintf("<%s>%s</%s>\n",
                $col->{name},
                $self->inline(join("", @{ $col->{children} }), %opts),
                $col->{name}
            );
        }
        $ret .= "</tr>\n";
    }
    $ret .= "</table>\n";
    $ret;
}


1;
__END__



