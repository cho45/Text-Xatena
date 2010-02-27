package Text::HatenaX::Node;

use strict;
use warnings;
use overload
    '@{}' => \&children,
    fallback => 1;

sub new {
    my ($class, $children) = @_;
    bless {
        children => $children || [],
    }, $class;
}

sub children { $_[0]->{children} };

sub as_html {
    my ($self) = @_;
    my $ret = "";

    my $children = $self->children;
    my $texts = [];
    for my $child (@$children) {
        if (ref($child)) {
            $ret .= $self->as_html_paragraph(join("\n", @$texts)) if @$texts;
            $texts = [];
            $ret .= $child->as_html;
        } else {
            push @$texts, $child;
        }
    }
    $ret .= $self->as_html_paragraph(join("\n", @$texts)) if @$texts;

    $ret;
}

sub as_html_paragraph {
    my ($self, $text) = @_;
    "<p>" . join("</p>\n<p>", map { join("<br />", split /\n/) } split(/\n\n/, $text)) . "</p>\n";
}


1;
__END__



