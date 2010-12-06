use strict;
use warnings;
use lib 't/lib';
use Test::Most;
use Text::Xatena::Test;

plan tests => 1 * blocks() + 1;

run_html;

like thx('- foo'), qr{<ul>\s*<li>foo</li>\s*</ul>}, 'check whitespaces';

__END__

=== test
--- input
- 1
- 2
- 3
--- expected
<ul>
    <li>1</li>
    <li>2</li>
    <li>3</li>
</ul>

=== test
--- input
- 1
- 2
-- 2.1
-- 2.2
--+ 2.2.3
- 3
--- expected
<ul>
    <li>1</li>
    <li>2
        <ul>
            <li>2.1</li>
            <li>2.2
                <ol>
                    <li>2.2.3</li>
                </ol>
            </li>
        </ul>
    </li>
    <li>3</li>
</ul>

=== test
--- input
- http://www.lowreal.net/
- 2
-+ 2.1
-+ 2.2
- 3
--- expected
<ul>
    <li><a href="http://www.lowreal.net/">http://www.lowreal.net/</a></li>
    <li>2
        <ol>
            <li>2.1</li>
            <li>2.2</li>
        </ol>
    </li>
    <li>3</li>
</ul>

=== test
--- input
:foo:bar
:baz:piyo
--- expected
<dl>
    <dt>foo</dt>
    <dd>bar</dd>
    <dt>baz</dt>
    <dd>piyo</dd>
</dl>

=== test
--- input
:foo:http://www.lowreal.net/
:baz:piyo
--- expected
<dl>
    <dt>foo</dt>
    <dd><a href="http://www.lowreal.net/">http://www.lowreal.net/</a></dd>
    <dt>baz</dt>
    <dd>piyo</dd>
</dl>

=== test
--- input
:foo:http://www.lowreal.net/
:baz:piyo
--- expected
<dl>
    <dt>foo</dt>
    <dd><a href="http://www.lowreal.net/">http://www.lowreal.net/</a></dd>
    <dt>baz</dt>
    <dd>piyo</dd>
</dl>

=== test
--- input
:foo:
::http://www.lowreal.net/
:baz:
::piyo
::piyo
--- expected
<dl>
    <dt>foo</dt>
    <dd><a href="http://www.lowreal.net/">http://www.lowreal.net/</a></dd>
    <dt>baz</dt>
    <dd>piyo</dd>
    <dd>piyo</dd>
</dl>

=== test
--- input
:foo
--- expected
<p>:foo</p>

=== test
--- input
 -foo
--- expected
<p>-foo</p>

=== test
--- input
- 1
- 2
- 3
test
--- expected
<ul>
    <li>1</li>
    <li>2</li>
    <li>3</li>
</ul>
<p>test</p>

=== test
--- input
:foo:bar
:baz:piyo
test
--- expected
<dl>
    <dt>foo</dt>
    <dd>bar</dd>
    <dt>baz</dt>
    <dd>piyo</dd>
</dl>
<p>test</p>

