package Keeper;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes
    my $r = $self->routes;

    my $images = $r->route("/images/:sha1")->to(controller => "images");
    $images->get->to("#download");
    $images->put->to("#upload");

}

1;
