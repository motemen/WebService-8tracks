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

has '_started', (
    is  => 'rw',
    isa => 'Bool',
    default => 0,
);

has 'at_beginning', (
    is  => 'rw',
    isa => 'Bool',
    default => 0,
);

has 'at_end', (
    is  => 'rw',
    isa => 'Bool',
    default => 0,
);

__PACKAGE__->meta->make_immutable;

no Any::Moose;

sub update_status {
    my ($self, $res) = @_;

    foreach (qw(at_beginning at_end)) {
        $self->$_(!!$res->{set}->{$_}) if defined $res->{set}->{$_};
    }
}

sub execute {
    my ($self, $command) = @_;

    my $res = $self->api->request_api(
        GET => "sets/$self->{play_token}/$command",
        { mix_id => $self->mix_id },
    );
    $self->update_status($res);
    return $res;
}

sub play {
    my $self = shift;
    $self->_started(1);
    return $self->execute('play');
}

sub next {
    my $self = shift;
    if ($self->_started) {
        return $self->execute('next');
    } else {
        $self->_started(1);
        return $self->execute('play');
    }
}

sub skip {
    my $self = shift;
    return $self->execute('skip');
}

1;
