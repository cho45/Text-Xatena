package Text::HatenaX::Node::Table;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^\|/)) {
        my $a = $class->new([ $s->matched->[0] ]);
        until ($s->eos || !$s->scan(qr/^\|/)) {
            push @$a, $s->matched->[0];
        }
        push @$parent, $a;
        return 1;
    }
}


1;
__END__



