#!/usr/bin/perl
use strict ;
use warnings ;
use CGI;

my $cgi = new CGI ;

print $cgi->header('text/html');

my $finder = qx(sudo iw dev wlan0 scan | grep SSID);
my @networks = split(/\n/,$finder) ;

# my $first = qq{<li class="refresh rotate"><button type="button">Buscar redes <svg aria-hidden="true" class="inline"><use xlink:href="img/constant.svg#refresh" /></svg></button></li>};
# print($first) ;
foreach my $rec (@networks)
{
  $rec =~ s/SSID: //;
  print (qq{<li><button type="button" data-modal="wifi">$rec</button></li>});
}
