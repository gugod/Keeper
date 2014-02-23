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

    coerce 'Keeper::Blob'
    => from 'HashRef',    via { Keeper::Blob->new(%$_) }
    => from 'Str',        via { Keeper::Blob->new( content => $_[0] ) };

    coerce 'Keeper::Name'
    => from 'HashRef', via { Keeper::Name->new(%$_) }
    => from 'Str', via { Keeper::Name->new( content => $_[0] ) };

    coerce 'Keeper::File'
    => from 'FileStorageSerialization', via {

    };

    coerce 'FileStorageSerialization'
    => from 'Keeper::Blob', via { $_[0]->content },
    => from 'Keeper::Name', via { $_[0]->content },
    => from 'Keeper::File', via {
        $JSON->encode({
            name_id => $_->name->id,
            blob_id => $_->blob->id,
        });
    };


};

1;
