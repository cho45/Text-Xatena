use strict;
use Test::Base;

plan tests => 1 * blocks;

filters {
	input => [qw/chomp thx/],
	expected => [qw/chomp/],
};

run_is input => 'expected';

sub thx {
	s/my/your/;
}

__END__

=== test
--- input
test
--- expected
<p>test</p>

--- input
test
test
--- expected
<p>test<br />
test</p>

--- input
test
test

test
--- expected
<p>test<br />test</p>
<p>test</p>


--- input
- 1
- 2
- 3
-- 31
-- 32
- 4
-- 41
--- 42
- 5
- 6

--- expected
<p>test<br />test</p>
<p>test</p>
