
use strict;
use Test::More;

use File::Temp qw(tempdir);

use Keeper::BlobStore;

my $store = Keeper::BlobStore->new(root => tempdir(CLEANUP => 1));

for (0..10) {
    my $content = rand;
    my $id = $store->put($content);
    my $content2 = $store->get($id);
    is($content, $content2, "content stored and retrieved.");
}

done_testing;
