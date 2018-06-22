#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use HTML::Template;

use CGI;
my $cgi = CGI->new() ;

my $status = read_file('../firstTimeConfiguration') ;

if($status eq 'PRODUCTION')
{
  print $cgi->redirect('/cgi-bin/play3.pl');
  exit ;
}
else
{
  #Checkeo las leases en el servidor dhcdp para determinar si estoy en
  #status WIFI_CONFIGURATION
  print $cgi->header() ;
  my $template = HTML::Template->new(filename => "/var/www/html/templates/messages/messages-T.html") ; #$pth path del template
  my $message ;
  # print qq {
  #   <head>
  #     <meta http-equiv="refresh" content="5">
  #   </head>
  # }
  # ;
  my $process_status = read_file( '/tmp/process_status' ) ;
  if($process_status eq 'CONNECTED')
  {
	system("echo -n SYNCHRO > ../firstTimeConfiguration") ;
  }

  if($status eq 'FIRST_TIME')
  {
    $message = "1. Conectate a la red siguit-ap-conf con cualquier dispositivo." ;
    $message .= "<br>" ;
    $message .= "2. Aceptá la conexión aunque el teléfono advierta que no tiene internet." ;

    checkLeasesAndSetStatus() ;
  }
  elsif($status eq 'WIFI_CONFIGURATION')
  {
    $message = "3. Abrí el navegador y escribí este número en el campo de dirección:" ;
    $message .= "<br>" ;
    $message .= "192.168.4.1" ;
    $message .= "<br>" ;
    $message .= "4. Elegí tu red wifi dentro de la lista y conectate."
  }
  elsif($status eq 'CLI_IS_SET')
  {
    $message = "Intentando conectarse a la red" ;
  }
  elsif($status eq 'SYNCHRO')
  {
    $message = "5. ¡Listo! Siguit comenzará su proceso de instalación." ;
    $message .= "<br>" ;
    $message .= "Espere por favor. Este proceso puede tardar unos minutos." ;
  }
  elsif($status eq 'CANT_CONNECT')
  {
    $message = " IMPOSIBLE CONECTARSE REPITA ESTOS PASOS " ;
    $message = "1. Conectate a la red siguit-ap-conf con cualquier dispositivo." ;
    $message .= "<br>" ;
    $message .= "Aceptá la conexión aunque el teléfono advierta que no tiene internet." ;
  }

  $template->param(message => $message );
  print $template->output() ;
  # elsif($status eq 'SYNCHRONIZED')
  # {
  # }

}
exit ;
########


sub read_file
{
  my $filename = shift ;
  open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
    return <$fh> ;
}

sub file_write
{
  my $filename = shift ;
  my $text = shift ;
  open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
  print $fh $text ;
  close $fh;
}

sub checkLeasesAndSetStatus
{
  my $leases = qx(cat /var/lib/misc/dnsmasq.leases | wc -l);
  my $filename = '/var/www/html/firstTimeConfiguration';

  if ($leases > '0')
  {
    system("echo -n WIFI_CONFIGURATION > $filename") ;
    print "WIFI_CONFIGURATION" ;
  }
}
