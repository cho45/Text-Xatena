use inc::Module::Install;
name 'Text-Xatena';
all_from 'lib/Text/Xatena.pm';

requires 'URI::Escape';
requires 'Exporter::Lite';
requires 'HTML::Entities';
requires 'LWP::Simple';
requires 'UNIVERSAL::require';
requires 'List::MoreUtils';

test_requires 'Test::More';
test_requires 'HTML::Parser';
test_requires 'Cache::MemoryCache';

use_test_base;
# auto_include;
WriteAll;
