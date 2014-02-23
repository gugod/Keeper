use v5.14;
package Keeper::File {
    use Moose; with 'Keeper::Thing';
    use Keeper::Tools qw(sha1_base64url);

    has name_id => (
        is => "ro",
        isa => 'Str',
        required => 1,
    );

    has blob_id => (
        is => "ro",
        isa => 'Str',
        required => 1,
    );

    sub id {
        my $self = shift;
        return sha1_base64url( $self->name_id . $self->blob_id );
    }
};

1;
