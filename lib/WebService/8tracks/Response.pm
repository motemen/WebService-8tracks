package WebService::8tracks::Response;
use strict;
use warnings;
use HTTP::Status ();

# thin wrapper of response hash

sub new {
    my ($class, $args) = @_;
    return bless $args, $class;
}

sub _status_code {
    my $self = shift;
    $self->{status} =~ /^(\d+)/ or return undef;
    return $1;
}

sub is_success {
    my $self = shift;
    my $code = $self->_status_code or return 0;
    return HTTP::Status::is_success($code);
}

foreach my $is_error (qw(is_error is_client_error is_server_error)) {
    my $code = sub {
        my $self = shift;
        my $code = $self->_status_code or return 1;
        return HTTP::Status->can($is_error)->($code);
    };
    no strict 'refs';
    *$is_error = $code;
}

1;
