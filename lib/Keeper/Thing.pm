use v5.14;
package Keeper::Thing {
    use Moose::Role;

    sub type {
        my $class = $_[0];
        if ($class =~ m/^Keeper::([^:]+)$/) {
            return $1;
        }
        die "Very wrong thing happened.";
    }

    sub deserialize {
        my ($class, $thing_type, $bits) = @_;
        my $thing_class = "Keeper::" . ucfirst(lc($thing_type));
        return $thing_class->deserialize( $bits );
    }
};
1;
