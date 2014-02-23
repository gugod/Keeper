
use v5.14;
use strict;
use warnings;
use Test::More;
use File::Path qw(remove_tree);

use Keeper::Blob;
use Keeper::Name;
use Keeper::File;
use Keeper::Storage::File;

my $base = "/tmp/keeper-test";
remove_tree($base);

my $storage = Keeper::Storage::File->new( base => $base );

subtest "Store a blob" => sub {
    my $blob = Keeper::Blob->new( content => "123" );

    my $blob_key = $storage->put($blob);

    my $file = join("/", $base, "blob", $blob->id);
    ok -f $file;

    my $blob2 = $storage->get($blob_key);

    is $blob2->id, $blob->id;
    is $blob2->content, $blob->content;
};

subtest "Store a name" => sub {
    my $name = Keeper::Name->new( content => "espresso" );
    my $name_key = $storage->put( $name );

    ok -f join("/", $base, "name", $name->id);

    my $name2 = $storage->get( $name_key );
    is $name2->id, $name->id;
    is $name2->content, $name->content;
};

# subtest "Store a file" => sub {
#     my $blob = Keeper::Blob->new( content => "313" );
#     my $name = Keeper::Name->new( content => "numbers.txt" );
#     my $file = Keeper::File->new(
#         blob_id => $blob->id,
#         name_id => $name->id,
#     );
#     my $file_key = $storage->put( $file );
#     ok -f join("/", $base, "file", $file->id);
#     my $file2 = $storage->get( $file_key );
#     is $file2->id, $file->id;
#     is $file2->blob_id, $file->blob_id;
#     is $file2->name_id, $file->name_id;
# };

done_testing;
