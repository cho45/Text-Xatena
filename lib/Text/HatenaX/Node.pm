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
    $pkg->use or die $@;
    $pkg;
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



