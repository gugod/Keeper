use v5.14;
package Keeper::Storage::File {
    use Moose;
    use Keeper::Types;
    use Keeper::Thing ();
    use IO::All;
    use JSON;
    my $JSON = JSON->new;

    has base => (
        is => "ro",
        isa => "Str",
    );

    sub put {
        my ($self, $thing) = @_;

        if ($thing->isa("Keeper::Thing")) {
            $self->put($thing->blob);
        }
        elsif (! $thing->isa("Keeper::Blob") ) {
            die "I have no clue how to store " . ref($thing);
        }

        my $type = Keeper::Types::find_type_constraint("FileStorageSerialization");
        my $io = $self->io_for($thing);
        if ( !$io->exists ) {
            $io->assert->binary->print( $type->coerce($thing) );
        }
        return join "/", $thing->type, $thing->id;
    }

    sub get {
        my ($self, $thing_key) = @_;
        my ($thing_type, $thing_id) = split("/", $thing_key, 2);
        my $thing_class = "Keeper::" . (($thing_type eq "blob") ? "Blob" : "Thing");
        my $type = Keeper::Types::find_type_constraint( $thing_class );
        my $io = io->catfile($self->base, $thing_type, $thing_id);

        if ($io->exists && $type) {
            my $stored = $io->all;

            if ($thing_class eq 'Keeper::Blob') {
                return $type->coerce($stored);
            }

            my $hashref;
            eval { $hashref = $JSON->decode($stored) };
            if ($hashref) {
                if (exists $hashref->{'$ref'}) {
                    my $ref = delete $hashref->{'$ref'};
                    for my $attr_name (keys %$ref) {
                        my $attr_thing_id = $ref->{$attr_name};
                        my $attr = $thing_class->meta->get_attribute( $attr_name ) or next;
                        my $attr_thing_type = lc((split(/::/, $attr->type_constraint->name))[-1]);
                        $hashref->{$attr_name} = $self->get( $attr_thing_type . "/" . $attr_thing_id );
                    }
                }
                return $type->coerce($hashref)
            }
        }

        return undef;
    }

    sub path_for {
        my ($self, $thing) = @_;
        return $self->io_for($thing)->name;
    }

    sub io_for {
        my ($self, $thing) = @_;
        return io->catfile(
            $self->base,
            $thing->type,
            $thing->id
        );
    }
};
1;
