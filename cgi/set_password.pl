#!/usr/bin/perl
use strict ;
use warnings ;
use CGI;

my $cgi = new CGI ;

my $wifi = $cgi->param('wifi') ;
my $pwd =  $cgi->param('pwd') ;

if (length($pwd) > 7)
{
  system("wpa_passphrase $wifi $pwd >> /home/pi/wifi-config/cli/wpa_supplicant.conf") ;
}
else
{
  print("pwd must 8 char min \n");
}
