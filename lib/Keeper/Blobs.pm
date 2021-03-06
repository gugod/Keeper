use v5.14;
use strict;
use warnings;

package Keeper::Blobs;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Asset::File;

use Keeper::BlobStore;

sub upload {
    my $self = $_[0];
    my ($filename, $body);

    my $file = $self->req->upload("file");

    if ($file) {
        $filename = $file->filename;
        $body = $file->asset->slurp;
    }
    else {
        $filename = $self->param("filename");
        $body = $self->req->body;
    }

    my $suffix = "";
    if ($filename) {
        if ($filename =~ s!(\.[^\.]+)\z!!) {
            $suffix = $1;
        }
        $filename =~ s![^a-zA-Z0-9-_]!!g;
    }
    $filename ||= "blob";
    $filename .= $suffix;
    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );
    my $digest = $store->put($body);
    $self->res->code(302);

    my $loc = $self->req->url->to_abs->clone;
    $loc->path("/blobs/$digest/$filename");
    $self->res->headers->location("$loc");
}

sub download {
    my $self = $_[0];
    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );

    my $digest = $self->stash("digest");
    my $path = $store->get_path($digest);

    if (!$path) {
        return $self->helpers->reply->not_found;
    }

    if (defined($ENV{KEEPER_FILE_SERVE_MODE})) {
        if (lc($ENV{KEEPER_FILE_SERVE_MODE}) eq 'x-accel-redirect') {
            $self->res->headers->header("X-Accel-Redirect" => "/blobs_store/$digest");
            $self->render(text => "");
            return;
        }
    }

    return $self->helpers->reply->asset(Mojo::Asset::File->new(path => $path));
}

sub exists {
    my $self = shift;
    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );
    my $digest = $self->stash("digest");

    my $path = $store->get_path($digest);
    if (!$path) {
        $self->res->code(404);
        $self->render(text => "");
    }
    else {
        $self->render(text => "");
    }
}

1;
