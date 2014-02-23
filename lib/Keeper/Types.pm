use v5.14;
package Keeper::Types {
    use strict;
    use Moose::Util::TypeConstraints;

    subtype Blob => as class_type 'Keeper::Blob';
    subtype Stored => as 'Str';

    coerce 'Blob'
    => from 'HashRef',    via { Keeper::Blob->new(%$_) }
    => from 'Str',        via { Keeper::Blob->new( content => $_[0] ) };

    subtype 'Name' => as class_type 'Keeper::Name';
    coerce 'Name'
    => from 'HashRef', via { Keeper::Name->new(%$_) }
    => from 'Str', via { Keeper::Name->new( content => $_[0] ) };

    coerce 'Stored'
    => from 'Blob', via { $_[0]->content },
    => from 'Name', via { $_[0]->content };

};

1;
