package Keeper;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    if ($ENV{KEEPER_BLOB_STORE_ROOT}) {
        $self->defaults( "blob_store_root" => $ENV{KEEPER_BLOB_STORE_ROOT} );
    }
    else {
        $self->defaults( "blob_store_root" => $self->app->home->rel_dir("store/blobs") );
    }

    # Routes
    my $r = $self->routes;
    my $blobs = $r->route("/blobs")->to(controller => "blobs");
    $blobs->get("/_exists/:digest")->to("#exists");
    $blobs->post("/")->to("#upload");
    $blobs->get("/:digest/:filename")->to("#download");
    $blobs->get("/:digest")->to("#download");
}

1;
