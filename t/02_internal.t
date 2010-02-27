use strict;
use Test::More tests => 11;
use Text::HatenaX;
use Data::Dumper;

sub p ($) { warn Dumper shift }

my $thx = Text::HatenaX->new;
my $res;
sub same ($$) {
	my ($got, $expected) = @_;
	my $r = is_deeply $got, $expected;
	unless ($r) {
		p $got;
	}
}

$res = $thx->_parse(<<EOS);
foo
bar
EOS

same $res, {
	children => [
		"foo",
		"bar",
	]
};

$res = $thx->_parse(<<EOS);
foo
bar

baz
EOS

same $res, {
	children => [
		"foo",
		"bar",
		"",
		"baz",
	]
};

$res = $thx->_parse(<<EOS);
- foo
- bar
- baz
EOS

same $res, {
	children => [
		{
			children => [
				"- foo",
				"- bar",
				"- baz",
			]
		}
	]
};

$res = $thx->_parse(<<EOS);
- foo
- bar
- baz
piyo
EOS

same $res, {
	children => [
		{
			children => [
				"- foo",
				"- bar",
				"- baz",
			]
		},
		"piyo"
	]
};

$res = $thx->_parse(<<EOS);
- foo
- bar
- baz

piyo
EOS

same $res, {
	children => [
		{
			children => [
				"- foo",
				"- bar",
				"- baz",
			]
		},
		"",
		"piyo"
	]
};

$res = $thx->_parse(<<EOS);
>||

foobar
baz
fooooo
<>&
>>
  baz
<<

||<
EOS

same $res, {
	children => [
		{
			children => [
				q{
foobar
baz
fooooo
<>&
>>
  baz
<<
}
			]
		},
	]
};

$res = $thx->_parse(<<EOS);
>>
quote1
>>
quote2
<<
<<
EOS

same $res, {
	children => [
		{
			beginning => ['>>', 1],
			endofnode => ['<<', 1],
			children => [
				"quote1",
				{
					beginning => ['>>', 1],
					endofnode => ['<<', 1],
					children => [
						"quote2"
					],
				},
			],
		},
	]
};

$res = $thx->_parse(<<EOS);
>>
quote1
>|
pre
foo
|<
<<
EOS

same $res, {
	children => [
		{
			beginning => ['>>', 1],
			endofnode => ['<<', 1],
			children => [
				"quote1",
				{
					children => [
						"pre",
						"foo",
						"",
					],
				},
			],
		},
	]
};
$res = $thx->_parse(<<EOS);
>>
quote1
>|
pre
foo
baz|<
<<
EOS

same $res, {
	children => [
		{
			beginning => ['>>', 1],
			endofnode => ['<<', 1],
			children => [
				"quote1",
				{
					children => [
						"pre",
						"foo",
						"baz",
					],
				},
			],
		},
	]
};

$res = $thx->_parse(<<EOS);
><blockquote>
<p>
foobar<br/>
baz
</p>
<blockquote><
EOS

same $res, {
	children => [
		{
			children => [qw{
				<blockquote>
				<p>
				foobar<br/>
				baz
				</p>
				<blockquote>
			} ],
		},
	]
};

$res = $thx->_parse(<<EOS);
foobar

><ins><
foobar
></ins><
EOS

same $res, {
	children => [
		"foobar",
		"",
		{
			children => [qw{
				<ins>
			} ],
		},
		"foobar",
		{
			children => [qw{
				</ins>
			} ],
		},
	]
};
