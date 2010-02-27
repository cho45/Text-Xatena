package Text::HatenaX::Node::StopP;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $cur, $stack) = @_;
    if ($s->scan(qr/^>(<.+>)(<)?$/)) {
        my $new = $class->new([ $s->matched->[1] ]);
        push @$cur, $new;
        if (!$s->matched->[2]) {
            push @$stack, $new;
        }
        return 1;
    }

    if ($s->scan(qr/^(.+>)<$/)) {
        push @$cur, $s->matched->[1];
        pop @$stack;
        return 1;
    }
}


1;
__END__



