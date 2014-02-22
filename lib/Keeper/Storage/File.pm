use v5.14;
package Keeper::Storage::File {
    use Moose;
    use Keeper::Thing ();
    use IO::All;

    has base => (
        is => "ro",
        isa => "Str",
    );

    sub put {
        my ($self, $thing) = @_;

        io->catfile(
            $self->base,
            $thing->type,
            $thing->id
        )->assert->binary->print( $thing->serialize );

        return $self;
    }

    sub get {
        my ($self, $thing_type, $thing_id) = @_;
        my $io = io->catfile($self->base, $thing_type, $thing_id);
        if ($io->exists) {
            return Keeper::Thing->deserialize( $thing_type, $io->all );
        }
        return undef;
    }
};
1;