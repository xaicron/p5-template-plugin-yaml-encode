use inc::Module::Install;
name 'Template-Plugin-YAML-Encode';
all_from 'lib/Template/Plugin/YAML/Encode.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
