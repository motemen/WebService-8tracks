use strict;
use warnings;
use Test::More;

use WebService::8tracks;

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
    plan skip_all => 'configure Config::Pit or set TEST_8TRACKS_ACCESSKEY, TEST_8TRACKS_SECRETKEY to test';
}

my $api = WebService::8tracks->new($config);
$api->user_agent->show_progress(1);

my $result = $api->mixes({ sort => 'random' });
my $mix = $result->{mixes}->[0];
diag explain $mix;

my $session = $api->create_session($mix->{id});
diag explain $session;

diag explain $session->play;
diag explain $session->skip;

pass;

done_testing;
