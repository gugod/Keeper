package ImageKeeper;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes
    my $r = $self->routes;
    $r->get("/images/:sha1")->to("images#download");
    $r->put("/images/:sha1")->to("images#upload");

}

1;
