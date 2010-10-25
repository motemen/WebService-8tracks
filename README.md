WebService::8tracks
===================

SYNOPSIS
--------

    use WebService::8tracks;

    my $api = WebService::8tracks->new;
    
    # explore
    my $mixes = $api->mixes({ sort => 'recent' }); # response is simply a HASH

    # listen
    my $session = $api->create_session($mixes->{mixes}->[0]->{id}); # returns a WebService::8tracks::Session
    my $res = $session->play;
    ...
    $session->next;
    $session->skip;

SEE ALSO
--------

8tracks Playback API. <http://docs.google.com/Doc?docid=0AQstf4NcmkGwZGdia2c5ZjNfNDNjbW01Y2dmZw>

TODO
----

- test
- follow
- fav

LICENSE
-------

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
