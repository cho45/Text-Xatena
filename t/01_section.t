use strict;
use warnings;
use lib 't/lib';
use Text::Xatena::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
* test1

foo

* test2

bar
--- expected
<div class="section">
<h3>test1</h3>
<p>foo</p>
</div>

<div class="section">
<h3>test2</h3>
<p>bar</p>
</div>


=== test
--- input
* test1

foo

** test1.1

foo!

** test1.2

foo!

*** test1.2.1

foo!

* test2

bar
--- expected
<div class="section">
<h3>test1</h3>
<p>foo</p>

<div class="section">
<h4>test1.1</h4>
<p>foo!</p>
</div>

<div class="section">
<h4>test1.2</h4>
<p>foo!</p>

<div class="section">
<h5>test1.2.1</h5>
<p>foo!</p>
</div>
</div>
</div>

<div class="section">
<h3>test2</h3>
<p>bar</p>
</div>


=== test
--- input
* http://example.com/
foo
--- expected
<div class="section">
<h3><a href="http://example.com/">http://example.com/</a></h3>
<p>foo</p>
</div>

