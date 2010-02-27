package Text::HatenaX::Util;

use strict;
use warnings;

our @EXPORT = qw(escape_html);

my %escape = (
    '&' => '&amp;',
    '<' => '&lt;',
    '>' => '&gt;',
    '"' => '&#34;',
    "'" => '&#39;',
);
sub escape_html ($) {
    my ($str) = @_;
    my $escape = join "|", keys %escape;
    $str =~ s{($escape)}{ $escape{$1} }ego;
    $str;
}


1;
__END__



