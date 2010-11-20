use inc::Module::Install;
name 'Text-Xatena';
all_from 'lib/Text/Xatena.pm';

requires 'Exporter::Lite';
requires 'URI::Escape';
requires 'Encode';

build_requires 'Test::More';
build_requires 'HTML::Parser';

use_test_base;
auto_include;
WriteAll;
