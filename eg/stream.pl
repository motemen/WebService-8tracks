use strict;
use warnings;
use lib 'lib';
use WebService::8tracks;
use Data::Dumper;

my $api = WebService::8tracks->new;
$api->user_agent->show_progress(1);

my $mix_id = shift or die "usage: $0 mix_id";

if ($mix_id =~ m(^[\w-]+/[\w-]+$)) {
    # Currently, 8tracks API does not provide way to get mix_id from 'user/mix-name'.
    my $res = $api->user_agent->get("http://8tracks.com/$mix_id");
    die $res->message if $res->is_error;
    ($mix_id) = $res->decoded_content =~ /data-mix_id="(\d+)"/ or die 'Could not parse response';
}

my $session  =$api->create_session($mix_id);

while (1) {
    my $track = $session->next;
    die Dumper $track->{errors} if $track->{errors};

    last if $track->{set}->{at_end};

    my $media_url = $track->{set}->{track}->{url} or die 'Media URL not found';
    my $res = $api->user_agent->get($media_url, ':content_cb' => sub { print STDOUT $_[0] });

    # Sleep for some time in order not to write too much
    # my $length = $res->header('Content-Length');
    # my $secs = $length / (64 * 1_000 / 8); # assume 64kbps
    # $secs -= 30;
    # warn "\nWait for $secs secs\n";
    # sleep $secs;
}

__END__

=pod

=head1 NAME

eg/stream.pl - Stream mix to stdout

=head1 SYNOPSIS

Save https://gist.github.com/725025 as httpcat.pl.

  % perl eg/stream.pl [mix_id or id/mix-name] | ffmpeg -i - -f mp3 - | httpcat.pl --content-type audio/mp3 --port 12345

Listen to http://yourhost:12345/ with your stream player say, iTunes.

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=cut
