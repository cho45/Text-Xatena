use strict;
use warnings;
use lib 't/lib';
use Test::Most;
use Text::Xatena::Test;
use Text::Xatena::Inline;

plan tests => 1 * blocks() + 1;

run_html;

subtest 'footnote' => sub {
	my $thx = Text::Xatena->new;
	my $inline = Text::Xatena::Inline->new;
	$thx->format('((foobar)) ((barbaz))', inline => $inline);
	eq_or_diff $inline->footnotes, [
		{
			'number' => 1,
			'title' => 'foobar',
			'note' => 'foobar'
		},
		{
			'number' => 2,
			'title' => 'barbaz',
			'note' => 'barbaz'
		}
	];
};

done_testing;


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

=== test
--- input
[http://example.com:80/]
--- expected
<p>
<a href="http://example.com:80/">
http://example.com:80/
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
[http://example.com/:title=Foo bar]
--- expected
<p>
<a href="http://example.com/">
Foo bar
</a>
</p>

=== gkbr: http://d.hatena.ne.jp/hatenadiary/20030315/1047690605
--- input
(((foobar)))
--- expected
<p>
(((foobar)))
</p>

=== escape footnote
--- input
)((foobar))(
--- expected
<p>
((foobar))
</p>

=== footnote
--- input
((foobar)) xxx ((barbaz))
--- expected
<p>
<a href="#fn1" title="foobar">*1</a>
xxx
<a href="#fn2" title="barbaz">*2</a>
</p>

=== footnote
--- input
((<a href="">foo</a>bar))
--- expected
<p>
<a href="#fn1" title="foobar">*1</a>
</p>

