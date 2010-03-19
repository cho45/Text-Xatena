use inc::Module::Install;
name 'Text-Xatena';
all_from 'lib/Text/Xatena.pm';

requires 'URI::Escape';
requires 'Exporter::Lite';
requires 'HTML::Entities';
requires 'LWP::Simple';
requires 'UNIVERSAL::require';
requires 'List::MoreUtils';

build_requires 'Test::More';
build_requires 'HTML::Parser';
build_requires 'Cache::MemoryCache';

use_test_base;
auto_include;
WriteAll;
