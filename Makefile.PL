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
requires 'Encode';

test_requires 'Test::More';
test_requires 'HTML::Parser';
test_requires 'Cache::MemoryCache';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t';
author_tests 'xt';

auto_set_repository;

use_test_base;
# auto_include;
WriteAll;
