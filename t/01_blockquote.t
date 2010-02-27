use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

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

