package Text::Xatena::Node::Section;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

our $BASE = 3;
our $BEGINNING = qq{<div class="section">\n};
our $ENDOFNODE = qq{\n</div>};
use constant {
    SECTION => qr/^(\*{1,3})(.*)$/,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(SECTION)) {
        my $level = length $s->matched->[1];
        my $title = $s->matched->[2];
        $title =~ s/^\s+|\s+$//g;

        my $node = $class->new;
        $node->{level} = $level;
        $node->{title} = $title;

        pop @$stack while
            ((ref($stack->[-1]) eq $class) && ($stack->[-1]->level >= $level)) ||
            ($level == 1 && ref($stack->[-1]) eq 'Text::Xatena::Node::SeeMore' && !$stack->[-1]->{is_super});

        $parent = $stack->[-1];

        push @$parent, $node;
        push @$stack, $node;
        return 1;
    }
}

sub level { $_[0]->{level} }
sub title { $_[0]->{title} }

## NOT COMPATIBLE WITH Hatena Syntax
sub as_html {
    my ($self, %opts) = @_;
    my $level = $self->level + $BASE - 1;
    sprintf("%s<h%d>%s</h%d>\n%s\n%s",
        $BEGINNING,
        $level,
        $self->inline($self->title, %opts),
        $level,
        $self->SUPER::as_html(%opts),
        $ENDOFNODE
    );
}

1;
__END__



