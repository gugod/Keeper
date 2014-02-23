use v5.14;
package Keeper::Blob {
    use Moose;
    with 'Keeper::Thing';
    use Keeper::Tools 'sha1_base64url';

    has content => (
        is => "ro",
        isa => "Str",
        required => 1,
    );

    has id => (
        is => "ro",
        isa => "Str",
        lazy_build => 1,
    );

    sub _build_id {
        return sha1_base64url( $_[0]->content )
    }
};

1;
