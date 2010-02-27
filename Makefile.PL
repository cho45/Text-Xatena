use inc::Module::Install;
name 'Text-HatenaX';
all_from 'lib/Text/HatenaX.pm';

requires $_ for (qw/ /);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
