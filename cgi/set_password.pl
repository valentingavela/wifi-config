#!/usr/bin/perl
use strict ;
use warnings ;
use CGI;
use utf8;

my $cgi = new CGI ;

my $wifi = $cgi->param('ssid') ;
my $pwd =  $cgi->param('pwd') ;

if (length($pwd) > 7)
{
  system("wpa_passphrase $wifi $pwd >> /home/pi/wifi-config/cli/wpa_supplicant.conf") ;
  print $cgi->header();
  print("ok");
  system("echo 1 > /tmp/configure_wifi") ;
}
else
{
  print $cgi->header();
  print("La contraseña debe tener 8 caracteres como mínimo");
}
