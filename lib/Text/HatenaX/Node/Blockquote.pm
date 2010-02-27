package Text::HatenaX::Node::Blockquote;

use strict;
use warnings;
use base qw(Text::HatenaX::Node);

sub beginning { qr/^>>$/ };
sub endofnode { qr/^<<$/ };

1;
__END__



