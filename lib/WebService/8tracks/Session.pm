package WebService::8tracks::Session;
use Any::Moose;

has 'api', (
    is  => 'rw',
    isa => 'WebService::8tracks',
    required => 1,
);

has 'mix_id', (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);

has 'play_token', (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);

has 'started', (
    is  => 'rw',
    isa => 'Bool',
    default => sub { 0 },
);

__PACKAGE__->meta->make_immutable;

no Any::Moose;

sub execute {
    my ($self, $command) = @_;
    return $self->api->request_api(GET => "/sets/$self->{play_token}/$command.json", { mix_id => $self->mix_id });
}

sub play {
    my $self = shift;
    $self->execute('play');
}

sub next {
    my $self = shift;
    if ($self->started) {
        return $self->execute('next');
    } else {
        $self->started(1);
        return $self->execute('play');
    }
}

sub skip {
    my $self = shift;
    $self->execute('skip');
}

1;
