package Keeper::BlobStore;
use Moo;
use Digest::SHA qw(sha512);
use Convert::Base32::Crockford qw(encode_base32);
use IO::All;

has root => (
    is => "rw",
    required => 1,
);

sub put {
    my ($self, $data) = @_;
    my $digest = encode_base32 sha512 $data;

    my $o = io->catfile($self->root, $digest);
    $o->print($data) unless $o->exists;

    return $digest;
}

sub get {
    my ($self, $digest) = @_;
    my $o = io->catfile($self->root, $digest);
    return undef unless $o->exists;
    return $o->all;
}

1;
