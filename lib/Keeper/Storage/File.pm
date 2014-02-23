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

        for my $other_thing ( $thing->get_all_storage_dependecies ) {
            $self->put($other_thing);
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
        my $thing_class = "Keeper::" . ucfirst(lc($thing_type));
        my $type = Keeper::Types::find_type_constraint( $thing_class );
        my $io = io->catfile($self->base, $thing_type, $thing_id);

        if ($io->exists && $type) {
            my $stored = $io->all;
            my $hashref;

            if ($thing_class ne 'Keeper::Blob' && substr($stored, 0, 1) eq '{' && substr($stored, -1, 1) eq '}') {
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
                }
            }

            return $type->coerce($hashref || $stored);
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
