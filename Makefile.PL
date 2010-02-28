use inc::Module::Install;
name 'Text-HatenaX';
all_from 'lib/Text/HatenaX.pm';

requires $_ for (qw/ URI::Escape Exporter::Lite /);

build_requires 'Test::More';
build_requires 'HTML::Parser';

use_test_base;
auto_include;
WriteAll;
