
use v5.14;
use strict;
use warnings;
use Test::More;
use File::Path qw(remove_tree);

use Keeper::Blob;
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

subtest "Store a file" => sub {
    my $file = Keeper::File->new(
        name => "numbers.txt",
        blob => "31337",
    );
    my $file_key = $storage->put( $file );

    ok -f $storage->path_for($file), "the file object itself";
    # ok -f $storage->path_for($file->name), "referenced name object";
    ok -f $storage->path_for($file->blob), "referenced blob object";

    subtest "retriving the file" => sub {
        my $file2 = $storage->get( $file_key );
        is $file2->id, $file->id, "file id matches";
        is $file2->name, $file->name, "file name matches";
        is $file2->blob->id, $file->blob->id, "referenced blob id matches";
    };
};

done_testing;
