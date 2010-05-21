use strict;
use warnings;
use Test::More;
use Test::Exception;

use_ok 'WebService::8tracks';

{
    my $dummy = new_ok 'WebService::8tracks', [ accesskey => '', secretkey => '' ];
    dies_ok { $dummy->mixes };
}

my $config;
if ($ENV{TEST_8TRACKS_ACCESSKEY} && $ENV{TEST_8TRACKS_SECRETKEY}) {
    $config->{accesskey} = $ENV{TEST_8TRACKS_ACCESSKEY};
    $config->{secretkey} = $ENV{TEST_8TRACKS_SECRETKEY};
}

if (!$config->{accesskey} &&
    !$config->{secretkey} &&
    eval 'require Config::Pit; 1'
) {
    $config = Config::Pit::get('api.8tracks.com');
}

if (!$config->{accesskey} || !$config->{secretkey}) {
    diag 'configure Config::Pit or set TEST_8TRACKS_ACCESSKEY, TEST_8TRACKS_SECRETKEY to test';
} else {
    my $api = new_ok 'WebService::8tracks', [ $config ];
    my $mixes = $api->mixes;
    isa_ok $mixes, 'HASH';
    isa_ok $mixes->{mixes}, 'ARRAY';
}

done_testing;
