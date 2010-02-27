use strict;
use warnings;
use lib 't/lib';
use Text::HatenaX::Test;

plan tests => 1 * blocks;

run_html;


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
- 1
- 2
-+ 2.1
-+ 2.2
- 3
--- expected
<ul>
    <li>1</li>
    <li>2
        <ol>
            <li>2.1</li>
            <li>2.2</li>
        </ol>
    </li>
    <li>3</li>
</ul>
