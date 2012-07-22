package ImageKeeper::Images;
use Mojo::Base 'Mojolicious::Controller';

use Digest::SHA1 qw(sha1_hex);
use ImageKeeper::ImageStore;

sub upload {
    my $self = shift;

    my $claimed_sha1 = $self->stash("sha1");
    my $claimed_format = $self->stash("format");

    my $body = $self->req->body;
    my $body_sha1 = sha1_hex($body);

    if ($body_sha1 ne $claimed_sha1) {
        $self->render_text("SHA1 MISMATCH", status => 400);
        return;
    }

    my $store = ImageKeeper::ImageStore->new( root => $self->app->home->rel_dir("images") );
    $store->put($body_sha1, $body, $claimed_format);

    $self->render_text("OK");
}

sub download {
    my $self = shift;

    my $sha1 = $self->stash("sha1");
    my $format = $self->stash("format");

    my $store = ImageKeeper::ImageStore->new( root => $self->app->home->rel_dir("images") );
    my $data = $store->get($sha1, $format);

    unless (defined($data)) {
        $self->render_text("NOT FOUND", status => 404);
    }

    $self->render_data($data, format => $format);
}

1;
