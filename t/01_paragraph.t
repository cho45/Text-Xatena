use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

plan tests => 1 * blocks;

run_is_deeply input => 'expected';


__END__

=== test
--- input
test
--- expected
<p>test</p>

=== test
--- input
test
test
--- expected
<p>test<br />test</p>

=== test
--- input
test
test

test
--- expected
<p>test<br />test</p>
<p>test</p>

