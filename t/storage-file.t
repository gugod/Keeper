
use v5.14;
use strict;
use warnings;
use Test::More;
use File::Path qw(remove_tree);

use Keeper::Blob;
use Keeper::Name;
use Keeper::Storage::File;

my $base = "/tmp/keeper-test";
remove_tree($base);

my $storage = Keeper::Storage::File->new( base => $base );

subtest "Store a blob" => sub {
    my $blob = Keeper::Blob->new( content => "123" );

    $storage->put($blob);

    my $file = join("/", $base, "blob", $blob->id);
    ok -f $file;

    my $blob2 = $storage->get("blob", $blob->id);

    is $blob2->id, $blob->id;
    is $blob2->content, $blob->content;
};

subtest "Store a name" => sub {
    my $name = Keeper::Name->new( content => "espresso" );
    $storage->put( $name );

    ok -f join("/", $base, "name", $name->id);

    my $name2 = $storage->get( name => $name->id);
    is $name2->id, $name->id;
    is $name2->content, $name->content;
};


done_testing;
