#!/usr/bin/env perl

use v5.14;
use strict;
use warnings;
use Test::More;
use File::Path qw(remove_tree);

use Keeper::Blob;
use Keeper::Thing;
use Keeper::Storage::File;

my $base = "/tmp/keeper-test";
remove_tree($base);

my $storage = Keeper::Storage::File->new( base => $base );

subtest "Store a blob" => sub {
    my $blob = Keeper::Blob->new( content => "123" );

    my $blob_key = $storage->put($blob);

    my $file = $storage->path_for($blob);
    ok -f $file;

    my $blob2 = $storage->get($blob_key);
    is $blob2->id, $blob->id;
    is $blob2->content, $blob->content;
};

subtest "Store multiple identical blob" => sub {
    my $blob1 = Keeper::Blob->new( content => "123" );
    my $blob2 = Keeper::Blob->new( content => "123" );

    my $blob1_key = $storage->put($blob1);
    my $blob2_key = $storage->put($blob1);

    is $blob1_key, $blob2_key, "key should be identical";

    my $blob1_file = $storage->path_for($blob1);
    my $blob2_file = $storage->path_for($blob2);

    is $blob1_file, $blob2_file, "file path should be identical";
};

subtest "Store a blob that looks like a valid piece of JSON" => sub {
    my $blob = Keeper::Blob->new( content => '{"a":1}' );
    my $blob_key = $storage->put($blob);

    ok $blob_key, $blob_key;

    my $blob2 = $storage->get($blob_key);
    is $blob2->id, $blob->id;
    is $blob2->content, $blob->content;
};

subtest "Store a thing" => sub {
    my $file = Keeper::Thing->new(
        type => "file",
        attributes => {
            name => "numbers.txt",
        },
        blob => "31337",
    );
    my $file_key = $storage->put( $file );

    ok -f $storage->path_for($file), "the file object itself";
    ok -f $storage->path_for($file->blob), "referenced blob object";

    subtest "retriving the thing" => sub {
        my $file2 = $storage->get( $file_key );
        is $file2->id, $file->id, "file id matches";
        is $file2->attributes->{name}, $file->attributes->{name}, "attribute content matches";
        is $file2->blob->id, $file->blob->id, "referenced blob id matches";
    };
};

done_testing;
