#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Benchmark qw(:all) ;

my $text = <<EOS;
* Xatena

This is Xatena.

- foo
- bar
- baz

+ aaa
+ bbb
+ ccc

>|perl|
test code
||<

^L

Markdown
========

This is markdown

 * foo
 * bar
 * baz

 1. aaa
 2. bbb
 3. ccc


  test code

^L

h1. Textile

A _simple_ demonstration of Textile markup.

* foo
* bar
* baz

# foo
# bar
# baz

<pre><code class="perl">
perl code
</code></pre>

EOS

use Text::Hatena;
use Text::Xatena;
use Text::Markdown;
use Text::Textile;

my $thx = Text::Xatena->new;
my $markdown = Text::Markdown->new;
my $textile = Text::Textile->new;

cmpthese(-1, {
	'Xatena' => sub {
		my $html = $thx->format($text);
	},
	'Hatena' => sub {
		my $html = Text::Hatena->parse($text);
	},
	'Markdown' => sub {
		my $html = $markdown->markdown($text);
	},
	'Textile' => sub {
		my $html = $textile->process($text);
	},
});

__END__
           Rate   Hatena  Textile Markdown   Xatena
Hatena   26.5/s       --     -85%     -86%     -93%
Textile   175/s     563%       --      -8%     -56%
Markdown  191/s     621%       9%       --     -52%
Xatena    395/s    1393%     125%     107%       --
