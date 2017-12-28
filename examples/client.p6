#!/usr/bin/env perl6

use v6;
use Verge::RPC::Client;
use Data::Dump;
use JSON::Tiny;

my $client = Verge::RPC::Client.new(url => 'localhost', secure => False);

# my $result = $client.execute('gettransaction', Array[Str].new('bfecd267306825a2fe24fcb266a316385491533ed1f2528ff77392fda6966ca9'));
# my $result = $client.execute('backupwallet', Array[Str].new('C:\\tmp\\wallet.dat'));
# my $result = $client.execute('getblock', Array[Str].new("5e82506dc3d0f13d9c9a864a23b40f2d15ac1b8e0f227e3d26a9ef7b2be31522"));
my $result = $client.execute('getinfo');
say Dump from-json($result);
