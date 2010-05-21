use inc::Module::Install;

name 'WebService-8tracks';
all_from 'lib/WebService/8tracks.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_include;
WriteAll;
