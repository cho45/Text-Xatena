package Text::Xatena::Util;

use strict;
use warnings;

our @EXPORT = qw(escape_html);
use Exporter::Lite;

my %escape = (
    '&' => '&amp;',
    '<' => '&lt;',
    '>' => '&gt;',
    '"' => '&#34;',
    "'" => '&#39;',
);
sub escape_html ($) { ## no critic
    my ($str) = @_;
    my $escape = join "|", keys %escape;
    $str =~ s{($escape)}{ $escape{$1} }ego;
    $str;
}


1;
__END__



