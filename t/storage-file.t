
use v5.14;
use strict;
use warnings;
use Test::More;

use Keeper::Blob;
use Keeper::Storage::File;

subtest "Store a blob" => sub {
    my $base = "/tmp/keeper-test";
    my $storage = Keeper::Storage::File->new( base => $base );

    my $blob = Keeper::Blob->new( content => "123" );

    $storage->put($blob);

    my $file = join("/", $base, "blob", $blob->id);
    ok -f $file;

    my $blob2 = $storage->get("blob", $blob->id);

    is $blob2->id, $blob->id;
    is $blob2->content, $blob->content;
};

done_testing;
