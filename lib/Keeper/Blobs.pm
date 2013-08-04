use strict;
use warnings;

package Keeper::Blobs;
use Mojo::Base 'Mojolicious::Controller';
use Keeper::BlobStore;

sub upload {
    my $self = $_[0];
    my $body = $self->req->body;
    my $store = Keeper::BlobStore->new( root => $self->stash("blob_store_root") );
    my $digest = $store->put($body);
    my $url = $self->req->url->to_abs;
    $url =~ s!/+$!!;

    $self->render(text => "$url/$digest");
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
        $self->render( text => "");
    }
}

1;
