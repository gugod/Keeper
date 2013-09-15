use v5.14;
use strict;
use warnings;

package Keeper::Blobs;
use Mojo::Base 'Mojolicious::Controller';
use Keeper::BlobStore;

sub upload {
    my $self = $_[0];
    my $body = $self->req->body;

    my $filename = $self->param("filename");

    if ($filename) {
        $filename =~ s![^a-zA-Z0-9-_]!!g;
    }
    if (!$filename) {
        $filename = "blob";
    }

    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );
    my $digest = $store->put($body);

    my $url = $self->req->url->path("/$digest/$filename")->query("")->fragment("")->to_abs;
    $self->render(text => "$url");
}

sub download {
    my $self = $_[0];
    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );

    my $digest = $self->stash("digest");
    my $path = $store->get_path($digest);

    if (!$path) {
        $self->render_not_found;
    }
    else {
        $self->res->headers->header("X-Accel-Redirect" => "/blobs_store/$digest");
        $self->render(text => "");
    }
}

1;
