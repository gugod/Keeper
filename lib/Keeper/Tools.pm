package Keeper::Tools;
use Moose ();
use Moose::Exporter;
use Digest::SHA1;

Moose::Exporter->setup_import_methods(
    as_is => [ 'sha1_base64url' ]
);

sub sha1_base64url {
    return scalar Digest::SHA1::sha1_base64( join("", @_ ) ) =~ y!+/!-_!r
}

1;
