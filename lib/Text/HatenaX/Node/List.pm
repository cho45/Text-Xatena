package Text::HatenaX::Node::List;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    for my $l (qw/- + :/) {
        my $l = quotemeta $l;
        if ($s->scan(qr/^$l/)) {
            my $a = $class->new([ $s->matched->[0] ]);
            until ($s->eos || !$s->scan(qr/^$l/)) {
                push @$a, $s->matched->[0];
            }
            push @$parent, $a;
            return 1;
        }
    }
}


1;
__END__



