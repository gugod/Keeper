use v5.14;
package Keeper::Thing {
    use Moose::Role;
    use Sereal qw(encode_sereal decode_sereal);

    requires 'hashref';

    sub type {
        my $class = $_[0];
        $class = ref($class) if ref($class);

        if ($class =~ m/^Keeper::([^:]+)$/) {
            return lc($1);
        }
        die "Very wrong thing happened.";
    }

    sub serialize {
        my $self = shift;
        return encode_sereal( $self->hashref )
    }

    sub deserialize {
        my ($class, $thing_type, $bits) = @_;

        my $thing_class = "Keeper::" . ucfirst(lc($thing_type));
        if ( $thing_class->can("deserialize") != Keeper::Thing->can("deserialize") ) {
            return $thing_class->deserialize( $bits );
        }

        my $thing_hashref = decode_sereal( $bits );
        return $thing_class->new( %$thing_hashref );
    }
};
1;
