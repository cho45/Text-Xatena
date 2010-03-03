use strict;
use warnings;
use lib 't/lib';
use Text::Xatena::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
>|
quote
|<
--- expected
<pre>
quote
</pre>

=== test
--- input
>|
quote1
>>
quote2
<<
|<
--- expected
<pre>
quote1
    <blockquote>
        quote2
    </blockquote>
</pre>

