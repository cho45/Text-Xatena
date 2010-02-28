use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

plan tests => 1 * blocks;

run_html;


__END__

=== test
--- input
* This is a head

foobar

barbaz

:foo:bar
:foo:bar

- list1
- list1
- list1

>|perl|
test code
||<

ok?
--- expected
<div class="section">
    <h3>This is a head</h3>
    <p>foobar</p>
    <p>barbaz</p>
    <dl>
        <dt>foo</dt>
        <dd>bar</dd>
        <dt>foo</dt>
        <dd>bar</dd>
    </dl>
    <ul>
        <li>list1</li>
        <li>list1</li>
        <li>list1</li>
    </ul>
    <pre class="code lang-perl">test code</pre>
    <p>ok?</p>
</div>

