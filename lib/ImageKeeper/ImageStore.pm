package ImageKeeper::ImageStore;
use Moo;
use Path::Class;
use File::Path::Tiny;

has root => (
    is => "rw",
    required => 1,
);

sub _sha1_to_path {
    my ($self, $key) = @_;
    return dir($self->root, grep { $_ } split /(....)/, $key);
}

sub put {
    my ($self, $sha1, $data, $format) = @_;

    my $dir = $self->_sha1_to_path($sha1);

    if (-d $dir) {
        return 1;
    }

    $dir->mkpath();

    my $image_file = $dir->file("original.${format}");
    my $fh = $image_file->openw();
    $fh->syswrite($data);
    $fh->close;

    return 1;
}

sub get {
    my ($self, $sha1, $data, $format) = @_;

    my $dir = $self->_sha1_to_path($sha1);

    unless (-d $dir) {
        return undef;
    }

    return $dir->file("original.${format}");
}

1;
