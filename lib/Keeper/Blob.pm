use v5.14;
package Keeper::Blob {
    use Moose;
    with 'Keeper::Thing';

    use Digest::SHA1 qw(sha1_base64);

    has content => (
        is => "ro",
        isa => "Str",
        lazy_build => 1
    );

    has id => (
        is => "ro",
        isa => "Str",
        lazy_build => 1,
    );

    sub _build_id {
        return scalar sha1_base64($_[0]->content) =~ y!+/!-_!r;
    }

    sub serialize {
        return $_[0]->content;
    }

    sub deserialize {
        return $_[0]->new( content => $_[1] );
    }
};
1;
