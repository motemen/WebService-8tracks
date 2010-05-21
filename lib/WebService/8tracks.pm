package WebService::8tracks;
use Any::Moose;

has 'accesskey', (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);

has 'secretkey', (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);

has 'user_agent', (
    is  => 'rw',
    isa => 'LWP::UserAgent',
    default => sub { LWP::UserAgent->new },
);

__PACKAGE__->meta->make_immutable;

no Any::Moose;

our $VERSION = '0.01';

use WebService::8tracks::Session;

use Carp;
use Encode qw(is_utf8);
use JSON::XS qw(decode_json);
use LWP::UserAgent;
use URI::Escape qw(uri_escape);
use HTTP::Request;

sub api_url {
    my ($self, $path, $qparam) = @_;
    my $url = "http://api.8tracks.com$path";
    if ($qparam && scalar keys %$qparam) {
        my @pairs;
        while (my ($key, $value) = each %$qparam) {
            my $pair = $key . '=';
            if (is_utf8 $value) {
                $pair .= uri_escape_utf8 $value;
            } else {
                $pair .= uri_escape $value;
            }
            push @pairs, $pair;
        }
        $url .= '?' . join '&', @pairs;
    }
    return $url;
}

sub request_api {
    my ($self, $method, $path, $qparam) = @_;

    my $url = $self->api_url($path, $qparam);
    my $req = HTTP::Request->new($method, $url);
    $req->authorization_basic($self->accesskey, $self->secretkey);

    my $res = $self->user_agent->request($req);
    if ($res->is_error) {
        croak $res->message;
    }

    decode_json $res->content;
}

sub mixes {
    my ($self, $qparam) = @_;
    return $self->request_api(GET => '/mixes.json', $qparam);
}

sub mix_by_dj {
    my ($self, $dj_name) = @_;
    return $self->request_api(GET => "/$dj_name.json");
}

sub create_play_token {
    my $self = shift;
    my $result = $self->request_api(GET => '/sets/new.json');
    return $result->{play_token};
}

sub create_session {
    my ($self, $mix_id) = @_;
    my $play_token = $self->create_play_token;
    return WebService::8tracks::Session->new(
        api => $self,
        play_token => $play_token,
        mix_id => $mix_id,
    );
}

1;

__END__

=head1 NAME

WebService::8tracks -

=head1 SYNOPSIS

  use WebService::8tracks;

=head1 DESCRIPTION

WebService::8tracks is

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
