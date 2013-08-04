package Keeper::Blobs;
use Mojo::Base 'Mojolicious::Controller';
use Digest::SHA1 qw(sha1_hex);
use Keeper::ImageStore;

sub upload {
    my $self = shift;

    my $claimed_format = $self->stash("format");

    my $body = $self->req->body;
    my $body_sha1 = sha1_hex($body);

    my $store = Keeper::ImageStore->new(root => $self->stash("image_store_root") );
    $store->put($body_sha1, $body, $claimed_format);

    $self->render_text("OK");
}

sub download {
    my $self = shift;

    my $sha1 = $self->stash("sha1");
    my $format = $self->stash("format");
    my $image_store_root = $self->stash("image_store_root");

    my $store = Keeper::ImageStore->new(root => $image_store_root);
    my $path  = $store->get_path($sha1, $format);

    unless (defined($path)) {
        $self->render_text("NOT FOUND", status => 404);
    }

    $path =~ s{^$image_store_root}{/image_store};
    $self->res->headers->header("X-Accel-Redirect" => $path);
    $self->render_text("");
}

1;
