#!/usr/bin/env perl6

use v6;
use Verge::RPC::Client;
use Data::Dump;
use JSON::Tiny;

my $client = Verge::RPC::Client.new(url => 'localhost', port => '20102',
                                    proto => 'http',
                                    user => 'username',
                                    password => 'password');

my $result = $client.execute('gettransaction', Array[Str].new('bfecd267306825a2fe24fcb266a316385491533ed1f2528ff77392fda6966ca9'));
# my $result = $client.execute('backupwallet', Array[Str].new('C:\\tmp\\wallet.dat'));
say Dump from-json($result);
