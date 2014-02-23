use v5.14;
package Keeper::Types {
    use strict;
    use Moose::Util::TypeConstraints;
    use JSON;
    my $JSON = JSON->new->utf8;

    class_type 'Keeper::Blob';
    class_type 'Keeper::Name';
    class_type 'Keeper::File';

    subtype FileStorageSerialization => as 'Str';
    subtype FileStorageHashRef => as 'HashRef';

    coerce 'Keeper::Blob'
    => from 'HashRef',    via { Keeper::Blob->new(%$_) }
    => from 'Str',        via { Keeper::Blob->new( content => $_[0] ) };

    coerce 'Keeper::Name'
    => from 'HashRef', via { Keeper::Name->new(%$_) }
    => from 'Str', via { Keeper::Name->new( content => $_[0] ) };

    coerce 'Keeper::File'
    => from 'HashRef', via { Keeper::File->new(%$_) };

    coerce 'FileStorageSerialization'
    => from 'Keeper::Blob', via { $_->content },
    => from 'Keeper::Name', via { $_->content },
    => from 'Keeper::File', via {
        $JSON->encode({
            '$ref' => {
                name => $_->name->id,
                blob => $_->blob->id
            }
        });
    };


};

1;
