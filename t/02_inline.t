use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

plan tests => 1 * blocks;

run_html;


__END__
=== test
--- input
<a href="http://example.com/">http://example.com/</a>
--- expected
<p>
<a href="http://example.com/">
http://example.com/
</a>
</p>

=== test
--- input
http://example.com/
--- expected
<p>
<a href="http://example.com/">
http://example.com/
</a>
</p>

=== test
--- input
mailto:cho45@lowreal.net
--- expected
<p>
<a href="mailto:cho45@lowreal.net">
cho45@lowreal.net
</a>
</p>

=== test
--- input
[http://example.com/]
--- expected
<p>
<a href="http://example.com/">
http://example.com/
</a>
</p>

=== test
--- input
[http://example.com/:title=Foo bar]
--- expected
<p>
<a href="http://example.com/">
Foo bar
</a>
</p>

=== test
--- input
[http://example.com/:barcode]
--- expected
<p>
<img src="http://chart.apis.google.com/chart?chs=150x150&cht=qr&chl=http%3A%2F%2Fexample.com%2F" title="http://example.com/"/>
</p>

=== test
--- input
[]http://example.com/[]
--- expected
<p>
http://example.com/
</p>

=== test
--- input
<strong>http://example.com/</strong>
--- expected
<p>
<strong>
	<a href="http://example.com/">
	http://example.com/
	</a>
</strong>
</p>

=== test
--- input
<q cite="http://example.com/">http://example.com/</q>
--- expected
<p>
<q cite="http://example.com/">
	<a href="http://example.com/">
	http://example.com/
	</a>
</q>
</p>
