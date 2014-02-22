use v5.14;
package Keeper::Name {
    use Moose;
    with 'Keeper::Thing';

    has content => (
        is => "ro",
        isa => "Str",
        required => 1,
    );

    sub id { $_[0]->content }

    sub serialize {
        return $_[0]->content;
    }

    sub deserialize {
        return $_[0]->new( content => $_[1] );
    }

    sub hashref {
        return { content => $_[0]->content }
    }
};

1;
