use v5.14;
package Keeper::Types {
    use strict;
    use Moose::Util::TypeConstraints;
    use JSON;
    my $JSON = JSON->new->utf8;

    role_type  'Keeper::Thing';
    class_type 'Keeper::Blob';
    class_type 'Keeper::File';

    subtype FileStorageSerialization => as 'Str';
    subtype FileStorageHashRef => as 'HashRef';

    coerce 'Keeper::Blob'
    => from 'HashRef',    via { Keeper::Blob->new(%$_) }
    => from 'Str',        via { Keeper::Blob->new( content => $_[0] ) };

    coerce 'Keeper::File'
    => from 'HashRef', via { Keeper::File->new(%$_) };

    coerce 'FileStorageSerialization'
    => from 'Keeper::Blob', via { $_->content },
    => from 'Keeper::Thing', via {
        my $x = {};
        my $thing = $_[0];
        for my $attr ($thing->meta->get_all_attributes) {
            if ($attr->is_required && $attr->has_type_constraint ) {
                my $v = $attr->get_value($thing);
                if (ref($v) && $v->does("Keeper::Thing")) {
                    $x->{'$ref'}{ $attr->name } = $v->id;
                }
                else {
                    $x->{ $attr->name } = $v;
                }
            }
        }
        return $JSON->encode($x);
    };


};

1;
