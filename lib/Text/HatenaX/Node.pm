package Text::HatenaX::Node;

use strict;
use warnings;
use overload
    '@{}' => \&children,
    fallback => 1;

use Exporter::Lite;
use UNIVERSAL::require;
our @EXPORT_OK = qw(node);

sub node {
    my ($name) = @_;
    my $pkg = $name ? __PACKAGE__ . '::' . $name : __PACKAGE__;
    $pkg->use;
    $pkg;
}


sub parse {
    my ($class, $s, $parent, $stack) = @_;
    if ($s->scan($class->beginning)) {
        my $node = $class->new;
        $node->{beginning} = $s->matched;
        push @$parent, $node;
        push @$stack, $node;
        return 1;
    }
    if ($s->scan($class->endofnode)) {
        my $node = pop @$stack;
        $node->{endofnode} = $s->matched;
        return 1;
    }
}

sub new {
    my ($class, $children) = @_;
    bless {
        children => $children || [],
    }, $class;
}

sub children { $_[0]->{children} };



1;
__END__



