package Text::HatenaX::Node::SuperPre;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);
use Text::HatenaX::Util;

sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan(qr/^>\|([^|]*)\|$/)) {
        my $lang = $s->matched->[1];
        my $content = $s->scan_until(qr/^\|\|<$/);
        pop @$content;
        my $node = $class->new([join("\n", @$content)]);
        $node->{lang} = $lang;
        push @$parent, $node;
        return 1;
    }
}

sub lang { $_[0]->{lang} }

sub as_html {
    my ($self, %opts) = @_;
    sprintf('<pre class="code%s">%s</pre>',
        $self->lang ? " lang-" . $self->lang : "",
        escape_html(join "", @{ $self->children })
    );
}

1;
__END__



