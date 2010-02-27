use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
>||
test
test
||<
--- expected
<pre>
test
test
</pre>

=== test
--- input
>||
<a href="foobar">foobar</a>
||<
--- expected
<pre>
&lt;a href=&#34;foobar&#34;&gt;foobar&lt;/a&gt;
</pre>

=== test
--- input
>||
>>
foobar
<<
||<
--- expected
<pre>
&gt;&gt;
foobar
&lt;&lt;
</pre>
