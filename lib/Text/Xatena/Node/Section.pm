package Text::Xatena::Node::Section;

use strict;
use warnings;
use base qw(Text::Xatena::Node);

use Text::Xatena::Util;

use constant {
    SECTION => qr/^(?:
        (\*\*\*?)([^\*].*)     | # *** or **
        (\*)((?!\*\*?[^\*]).*)   # *
    )$/x,
};

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(SECTION)) {
        my $level = length($s->matched->[1] || $s->matched->[3]);
        my $title = $s->matched->[2] || $s->matched->[4];
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
    my ($self, $context, %opts) = @_;
    my $level = $self->level;

    $context->_tmpl(__PACKAGE__, q[
        <div class="section">
            <h{{= $level + 2 }}>{{= $title }}</h{{= $level + 2 }}>
            {{= $content }}
        </div>
    ], {
        title   => $context->inline->format($self->title),
        level   => $level,
        content => $self->SUPER::as_html($context, %opts),
    });
}

1;
__END__



