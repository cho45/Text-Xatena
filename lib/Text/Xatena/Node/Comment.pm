package Text::Xatena::Node::Comment;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^(.*)<!--.*?(-->)?$/)) {
        my $pre = $s->matched->[1];
        push @$parent, $pre;
        unless ($s->matched->[2]) {
            $s->scan_until(qr/^-->$/);
        }

        my $node = $class->new;
        push @$parent, $node;
        return 1;
    }
}

sub as_html {
    my ($self, %opts) = @_;
    '<!-- -->';
}

1;
__END__



