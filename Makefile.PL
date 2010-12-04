BEGIN {
	my @mip = qw(
		Module::Install::AuthorTests
		Module::Install::Repository
		Module::Install::ReadmeFromPod
		Module::Install::TestBase
	);
	for (@mip) {
		eval "require $_";
		if ($@) {
			eval "require inc::$_";
			if ($@) {
				warn $@;
				printf("# Install following (perl Makefile.PL | cpanm):\n%s", join("\n", @mip));
				exit 1;
			}
		}
	}
};

use inc::Module::Install;
name 'Text-Xatena';
all_from 'lib/Text/Xatena.pm';
readme_from 'lib/Text/Xatena.pm';

requires 'URI::Escape';
requires 'Exporter::Lite';
requires 'HTML::Entities';
requires 'LWP::Simple';
requires 'UNIVERSAL::require';
requires 'List::MoreUtils';

test_requires 'Encode';
test_requires 'LWP::UserAgent';
test_requires 'Test::More';
test_requires 'Test::Base';
test_requires 'Test::Most';
test_requires 'HTML::Parser';
test_requires 'Cache::MemoryCache';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t';
author_tests 'xt';

auto_set_repository;

use_test_base;
# auto_include;
WriteAll;
