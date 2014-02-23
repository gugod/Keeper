use v5.14;
package Keeper::File {
    use Moose;
    with 'Keeper::Thing';
    use Keeper::Types;
    use Keeper::Blob;
    use Keeper::Tools qw(sha1_base64url);

    has name => (
        is => "ro",
        isa => 'Str',
        required => 1,
    );

    has blob => (
        is => "ro",
        isa => 'Keeper::Blob',
        required => 1,
        coerce => 1,
    );

    has id => (
        is => "ro",
        isa => "Str",
        lazy_build => 1,
    );

    sub _build_id {
        my $self = shift;
        return sha1_base64url( $self->name . $self->blob->id );
    }
};

1;
