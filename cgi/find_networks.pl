#!/usr/bin/perl
use strict ;
use warnings ;
use CGI;
use Encode qw(decode encode);

my $cgi = new CGI ;

print $cgi->header('text/html');

my $finder = qx(sudo iw dev wlan0 scan | grep SSID);
my @networks = split(/\n/,$finder) ;

my $first = qq{<li id="find_networks" class="refresh"><button type="button" onclick="findNetworks()">Buscar redes <svg aria-hidden="true" class="inline"><use xlink:href="img/constant.svg#refresh" /></svg></button></li>};
print($first) ;

foreach my $rec (@networks)
{
  $rec =~ s/SSID: //;
  $rec =~ s/\s//g;
  $rec = encode('UTF-8', $rec);
  print (qq{<li><button type="button" data-modal="wifi" onclick="showForm('$rec')" >$rec</button></li>});
}
