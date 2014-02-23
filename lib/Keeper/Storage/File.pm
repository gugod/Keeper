use v5.14;
package Keeper::Storage::File {
    use Moose;
    use Keeper::Types;
    use Keeper::Thing ();
    use IO::All;

    has base => (
        is => "ro",
        isa => "Str",
    );

    sub put {
        my ($self, $thing) = @_;
        my $type = Keeper::Types::find_type_constraint("FileStorageSerialization");
        io->catfile(
            $self->base,
            $thing->type,
            $thing->id
        )->assert->binary->print( $type->coerce($thing) );
        return join "/", $thing->type, $thing->id;
    }

    sub get {
        my ($self, $thing_key) = @_;
        my ($thing_type, $thing_id) = split("/", $thing_key, 2);
        my $io = io->catfile($self->base, $thing_type, $thing_id);
        if ($io->exists) {
            my $stored = $io->all;
            my $type = Keeper::Types::find_type_constraint( "Keeper::" . ucfirst(lc($thing_type)) );
            return $type->coerce($stored);
        }
        return undef;
    }
};
1;
