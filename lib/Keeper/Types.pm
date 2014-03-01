use v5.14;
package Keeper::Types {
    use strict;
    use Moose::Util::TypeConstraints;
    use JSON;
    my $JSON = JSON->new->utf8;

    class_type  'Keeper::Thing';
    class_type 'Keeper::Blob';

    subtype FileStorageSerialization => as 'Str';
    subtype FileStorageHashRef => as 'HashRef';

    coerce 'Keeper::Blob'
    => from 'FileStorageHashRef', via { Keeper::Blob->new(%$_) }
    => from 'Str', via { Keeper::Blob->new( content => $_[0] ) };

    coerce 'Keeper::Thing'
    => from 'FileStorageHashRef',    via { Keeper::Thing->new(%$_) };

    coerce 'FileStorageSerialization'
    => from 'Keeper::Blob', via { $_->content },
    => from 'Keeper::Thing', via {
        my $thing = $_[0];
        my $attrs = $thing->attributes;
        my $x = {
            type => $thing->type,
            attributes => { map { ($_, "".$attrs->{$_}) } keys %$attrs },
            '$ref' => { blob => $thing->blob->id }
        };
        return $JSON->encode($x);
    };


};

1;
