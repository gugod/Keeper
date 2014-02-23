use v5.14;
package Keeper::Types {
    use Moose::Util::TypeConstraints;
    use Keeper::Blob;
    use Keeper::Name;

    subtype Blob => as class_type 'Keeper::Blob';
    coerce Blob
    => from 'HashRef', via { Keeper::Blob->new(%$_) }
    => from 'Str', via { Keeper::Blob->new( content => $_[0] ) };

    subtype Name => as class_type 'Keeper::Name';
    coerce Name =>
    => from 'HashRef', via { Keeper::Name->new(%$_) }
    => from 'Str', via { Keeper::Name->new( content => $_[0] ) };
};
1;
