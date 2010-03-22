use strict;
use warnings;
use lib 't/lib';
use Text::Xatena::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
>>
quote
<<
--- expected
<blockquote>
<p>quote</p>
</blockquote>

=== test
--- input
>>
quote1
>>
quote2
<<
<<
--- expected
<blockquote>
    <p>quote1</p>
    <blockquote>
        <p>quote2</p>
    </blockquote>
</blockquote>

=== test
--- input
>http://example.com/>
quote
<<
--- expected
<blockquote cite="http://example.com/">
	<p>quote</p>
	<cite><a href="http://example.com/">http://example.com/</a></cite>
</blockquote>

=== test
--- input
>>
quote
<<
test
--- expected
<blockquote>
<p>quote</p>
</blockquote>
<p>test</p>
