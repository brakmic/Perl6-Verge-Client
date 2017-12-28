unit module Verge::RPC;

our $VERSION = '1.0';

use v6;
use WWW;
use JSON::Fast;
use URI::Escape;
use LWP::Simple;
use Base64::Native;
use Verge::Helpers::Config;

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
  has Config $!config;

  submethod BUILD(Str :$url, Bool :$secure) {
    $!config = Config.new;
    $!url = $url;
    $!user = $!config.get-value-for('rpcuser');
    $!password = $!config.get-value-for('rpcpassword');
    $!port = $!config.get-value-for('rpcport');
    $!proto = $secure == True ?? 'https' !! 'http';
    $!auth_header = base64-encode($!user ~ ':' ~ $!password, :str);
    $!api = $!proto ~ '://' ~ $!url ~ ':' ~ $!port ~ '/';
  }
  # execute API command
  method execute(Str $api, *@params) returns Str {
    given self!get-command($api) {
      when 'gettransaction' {
        return $.get-transaction(@params[0]);
      }
      when 'backupwallet' {
        return $.backup-wallet(@params[0]);
      }
      when 'getblock' {
        return $.get-block(@params);
      }
      when 'getinfo' {
        return $.get-info();
      }
    };
  }
  # API: get transaction information
  method get-transaction(Str $tx-hash) returns Str {
    my @params = $tx-hash;
    return LWP::Simple.new.post($!api, self!get-request-headers(),
              to-json(self!get-request-parameters('gettransaction', @params)));
  }
  # API: creates a wallet backup (path can either be a full path or just a dir)
  method backup-wallet(Str $backup_path) returns Str {
    my @params = $backup_path;
    return LWP::Simple.new.post($!api, self!get-request-headers(),
                to-json(self!get-request-parameters('backupwallet', @params)));
  }
  method get-block(*@params) returns Str {
    return LWP::Simple.new.post($!api, self!get-request-headers(),
                    to-json(self!get-request-parameters('getblock', @params)));
  }
  method get-info() returns Str {
    return LWP::Simple.new.post($!api, self!get-request-headers(),
                    to-json(self!get-request-parameters('getinfo')));
  }
  method !get-request-parameters(Str $method, *@method_params) {
    my %params =
     'version' => '1.1',
     'method' => $method,
     'params' => @method_params,
     'id' => $!call_counter++
    ;
    return %params;
  }
  # componses HTTP call headers
  method !get-request-headers() {
     my %headers =
      'Host' => 'localhost',
      'User-Agent' => 'Perl6Client/0.1',
      'Authorization' => 'Basic ' ~ $!auth_header,
      'Content-Type' => 'application/json'
     ;
     return %headers;
  }
  method !get_config() {

  }
  # returns API command
  method !get-command($name) returns Str {
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
