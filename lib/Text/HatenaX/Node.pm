package Text::HatenaX::Node;

use strict;
use warnings;
use overload
    '@{}' => \&children,
    fallback => 1;

our $INLINE = "Text::HatenaX::Inline";

sub new {
    my ($class, $children) = @_;
    bless {
        children => $children || [],
    }, $class;
}

sub children { $_[0]->{children} };

sub as_html {
    my ($self, %opts) = @_;
    my $ret = "";

    my $children = $self->children;
    my $texts = [];
    for my $child (@$children) {
        if (ref($child)) {
            $ret .= $self->as_html_paragraph(join("\n", @$texts), %opts) if @$texts;
            $texts = [];
            $ret .= $child->as_html(%opts);
        } else {
            push @$texts, $child;
        }
    }
    $ret .= $self->as_html_paragraph(join("\n", @$texts), %opts) if @$texts;

    $ret;
}

## NOT COMPATIBLE WITH Hatena Syntax
sub as_html_paragraph {
    my ($self, $text, %opts) = @_;
    $INLINE->use or die $@;
    $text =~ s{^\n}{}g;
    $text = $INLINE->new(%opts)->format($text);

    if ($opts{stopp}) {
        $text;
    } else {
        "<p>" . join("</p>\n<p>", map { join("<br />", split /\n/) } split(/\n\n/, $text)) . "</p>\n";
    }
}


1;
__END__



