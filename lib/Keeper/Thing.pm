use v5.14;
package Keeper::Thing {
    use Moose::Role;
    use Keeper::Types;
    use Sereal qw(encode_sereal decode_sereal);

    sub type {
        my $class = $_[0];
        $class = ref($class) if ref($class);

        if ($class =~ m/^Keeper::([^:]+)$/) {
            return lc($1);
        }
        die "Very wrong thing happened.";
    }

    has file_storage_serialization => (
        is => "ro",
        isa => "FileStorageSerialization",
        lazy_build => 1,
        coerce => 1,
    );
    sub _build_serialize_for_storage { return $_[0] }
};
1;
