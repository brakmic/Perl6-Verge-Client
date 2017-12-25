unit module Verge::RPC;

our $VERSION = '1.0';

use v6;
use WWW;
use JSON::Fast;
use URI::Escape;
use LWP::Simple;
use Base64::Native;

# client for querying the public Verge REST API
# https://vergecurrency.com/langs/en/#developers
class Client is export {
  has Str $!url;
  has Str $!port;
  has Str $!proto;
  has Str $!user;
  has Str $!password;
  has Str $!auth_header;
  has Str $!api;
  has Bool $.debug is rw = False;
  has UInt $!call_counter = 0;

  multi method new(Str :$url, Str :$port = '20102', :$proto = 'http',
                   Str :$user = 'user', Str :$password = 'password') {
      return self.bless(:url($url), :port($port),
                 :proto($proto), :user($user),
                 :password($password));
  }
  submethod BUILD(:$!url, :$!port, :$!proto, :$!user, :$!password) {
    $!auth_header = base64-encode($!user ~ ':' ~ $!password, :str);
    $!api = $!proto ~ '://' ~ $!url ~ ':' ~ $!port ~ '/';
  }
  # execute API command
  method execute(Str $api, Str @params) returns Str {
    given self!get_command($api) {
      when 'gettransaction' {
        return $.gettransaction(@params[0]);
      }
      when 'backupwallet' {
        return $.backupwallet(@params[0]);
      }
      when 'getblock' {
        return $.getblock(@params);
      }
    };
  }
  # API: get transaction information
  method gettransaction(Str $tx-hash) returns Str {
    my @params = $tx-hash;
    return LWP::Simple.new.post($!api, self!get_request_headers(),
              to-json(self!get_request_parameters('gettransaction', @params)));
  }
  # API: creates a wallet backup (path can either be a full path or just a dir)
  method backupwallet(Str $backup_path) returns Str {
    my @params = $backup_path;
    return LWP::Simple.new.post($!api, self!get_request_headers(),
                to-json(self!get_request_parameters('backupwallet', @params)));
  }
  method getblock(Str @params) returns Str {
    return LWP::Simple.new.post($!api, self!get_request_headers(),
                    to-json(self!get_request_parameters('getblock', @params)));
  }
  method !get_request_parameters(Str $method, Str @method_params) {
    my %params =
     'version' => '1.1',
     'method' => $method,
     'params' => @method_params,
     'id' => $!call_counter++
    ;
    say %params;
    return %params;
  }
  # componses HTTP call headers
  method !get_request_headers() {
     my %headers =
      'Host' => 'localhost',
      'User-Agent' => 'Perl6Client/0.1',
      'Authorization' => 'Basic ' ~ $!auth_header,
      'Content-Type' => 'application/json'
     ;
     return %headers;
  }
  # returns API command
  method !get_command($name) returns Str {
    my %commands = <addmultisigaddress
                    addmultisigaddress
                    backupwallet
                    backupwallet
                    createrawtransaction
                    createrawtransaction
                    decoderawtransaction
                    decoderawtransaction
                    dumpprivkey
                    dumpprivkey
                    encryptwallet
                    encryptwallet
                    getaccount
                    getaccount
                    getaccountaddress
                    getaccountaddress
                    getaddressesbyaccount
                    getaddressesbyaccount
                    getbalance
                    getbalance
                    getblock
                    getblock
                    getblockcount
                    getblockcount
                    getblockhash
                    getblockhash
                    getconnectioncount
                    getconnectioncount
                    getdifficulty
                    getdifficulty
                    getgenerate
                    getgenerate
                    gethashespersec
                    gethashespersec
                    getinfo
                    getinfo
                    getmemorypool
                    getmemorypool
                    getmininginfo
                    getmininginfo
                    getnewaddress
                    getnewaddress
                    getrawtransaction
                    getrawtransaction
                    getreceivedbyaccount
                    getreceivedbyaccount
                    getreceivedbyaddress
                    getreceivedbyaddress
                    gettransaction
                    gettransaction
                    getwork
                    getwork
                    help
                    help
                    importprivkey
                    importprivkey
                    importaddress
                    importaddress
                    keypoolrefill
                    keypoolrefill
                    listaccounts
                    listaccounts
                    listreceivedbyaccount
                    listreceivedbyaccount
                    listreceivedbyaddress
                    listreceivedbyaddress
                    listsinceblock
                    listsinceblock
                    listtransactions
                    listtransactions
                    listunspent
                    listunspent
                    move
                    move
                    sendfrom
                    sendfrom
                    sendmany
                    sendmany
                    sendrawtransaction
                    sendrawtransaction
                    sendtoaddress
                    sendtoaddress
                    setaccount
                    setaccount
                    setgenerate
                    setgenerate
                    settxfee
                    settxfee
                    signmessage
                    signmessage
                    signrawtransaction
                    signrawtransaction
                    stop
                    stop
                    validateaddress
                    validateaddress
                    verifymessage
                    verifymessage
                    walletlock
                    walletlock
                    walletpassphrase
                    walletpassphrase
                    walletpassphrasechange
                    walletpassphrasechange>;
      return %commands{$name};
  }

}

=begin pod
=TITLE Module for querying the Verge REST interface
=AUTHOR Harris Brakmic
This module helps to make queries against the Verge REST interface.
=end pod
