use strict;
use warnings;
use lib 'lib';
use WebService::8tracks;
use Data::Dumper;

local $Data::Dumper::Indent = 1;

my $api = WebService::8tracks->new;
my $session;

while (1) {
    local $| = 1;

    my $prompt = '8tracks';
    $prompt .= " [$session->{play_token}]" if $session;
    print "$prompt> ";

    my $line = <STDIN>;
    last unless defined $line;
    chomp $line;

    my ($method, @args) = split /\s+/, $line;

    my $result = eval { ($session || $api)->$method(@args) };
    if ($@) {
        warn $@;
        next;
    }

    print +Dumper $result;

    if (ref $result eq 'WebService::8tracks::Session') {
        $session = $result;
    }
    if ($session && $session->at_end) {
        undef $session;
    }
}
