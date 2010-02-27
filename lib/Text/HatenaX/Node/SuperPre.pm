package Text::HatenaX::Node::SuperPre;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^>\|\|$/)) {
        my $content = $s->scan_until(qr/^\|\|<$/);
        pop @$content;
        my $a = $class->new([join("\n", @$content)]);
        push @$parent, $a;
        return 1;
    }
}


1;
__END__



