use inc::Module::Install;

name 'WebService-8tracks';
all_from 'lib/WebService/8tracks.pm';

requires 'Any::Moose';
requires 'Carp';
requires 'Encode';
requires 'JSON::XS';
requires 'LWP::UserAgent';
requires 'URI::Escape';
requires 'HTTP::Request';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_set_repository;
auto_include;

WriteAll;
