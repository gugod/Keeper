use v5.14;
package Keeper::Thing {
    use Moose;
    use Keeper::Types;
    use Keeper::Tools 'sha1_base64url';

    has type => (
        is => "ro",
        isa => "Str",
        required => 1,
    );

    has blob => (
        is => "ro",
        isa => 'Keeper::Blob',
        required => 1,
        coerce => 1,
    );

    has attributes => (
        is => "ro",
        isa => "HashRef",
        default => sub { {} }
    );

    has id => (
        is => "ro",
        isa => "Str",
        lazy_build => 1
    );

    sub _build_id {
        my $self = shift;
        my $attrs = $self->attributes;
        return sha1_base64url(join(
            "\n",
            (map { ($_, $attrs->{$_}) } (sort keys %$attrs)),
            $self->blob->id,
        ));
    }
};
1;
