package Keeper;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    $self->defaults( "blob_store_root" => $self->app->home->rel_dir("store/blobs") );
    $self->defaults( "image_store_root" => $self->app->home->rel_dir("store/images") );

    # Routes
    my $r = $self->routes;

    my $blobs = $r->route("/")->to(controller => "blobs");
    $blobs->post->to("#upload");
    $blobs->get("/:digest")->to("#download");
    $blobs->get("/:digest/:filename")->to("#download");
}

1;
