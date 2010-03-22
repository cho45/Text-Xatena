use strict;
use warnings;
use lib 't/lib';
use Text::Xatena::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
<!--
secret
-->

--- expected
<!-- -->

=== test
--- input
<!-- secret -->

--- expected
<!-- -->

=== test
--- input
foobar <!-- secret -->

--- expected
<p>foobar</p>
<!-- -->

=== test
--- input
- <!-- foobar -->
- 1

--- expected
<ul>
    <li><!-- --></li>
    <li>1</li>
</ul>

=== test inline comment
--- input
- baz <!-- foobar --> bar
- 1

--- expected
<ul>
    <li>baz <!-- --> bar</li>
    <li>1</li>
</ul>

