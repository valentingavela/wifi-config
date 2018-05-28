#!/usr/local/bin/perl
#https://thepi.io/how-to-use-your-raspberry-pi-as-a-wireless-access-point/
#NOTE: DONT TURN OFF WIFI IN DESKTOP BAR MENU!!!
use strict ;
use warnings ;

my $random = int(rand(1000)) ;
my $command = $ARGV[0] ;

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

sub setFirstTimeConfigurationStatus
{
  my $filename = '/var/www/html/firstTimeConfiguration';
  my $status = read_file($filename) ;

  if($status eq 'WIFI_CONFIGURATION')
  {
    system("echo -n > /var/lib/misc/dnsmasq.leases") ;
    system("echo -n SYNCHRO > $filename") ;
  }
}

sub stopServices
{
  system("systemctl stop hostapd") ;
  system("systemctl stop dnsmasq") ;
  # system("service dhcpcd stop") ;
  # system("service systemd-sysctl stop") ;
  # system("service networking stop") ;
}

sub startServicesAp
{
  # system("service systemd-sysctl restart") ;
  system("service dhcpcd restart") ;
  system("service hostapd start") ;
  system("service dnsmasq start") ;
  # system("service networking start") ;
}

sub startServicesCli
{
  # system("service systemd-sysctl restart") ;
  system("service dhcpcd restart") ;
  # system("service networking start") ;
}

my $iptables = "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" ;
my $iptables_flush = "sudo iptables -F" ;

#####
#####
if ($command eq "AP")
{
  #1 Stop services
  stopServices() ;
  #2 Configuring a static IP
  system("cp /home/pi/wifi-config/ap/dhcpcd.conf /etc/dhcpcd.conf") ;
  #3 Configure the DHCP server (dnsmasq)
  system("cp /home/pi/wifi-config/ap/dnsmasq.conf /etc/dnsmasq.conf") ;
  # Step 5: Configure the access point host software (hostapd)
  system("cp /home/pi/wifi-config/ap/hostapd.conf /etc/hostapd/hostapd.conf") ;
  # Step 6: Set up traffic forwarding
  system("cp /home/pi/wifi-config/ap/hosts /etc/hosts") ;
  # Step 7: Set up wpa supplicant without password
  system("cp /home/pi/wifi-config/ap/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf") ;
  # Step 8: Add a new iptables rule
  system($iptables) ;

  startServicesAp() ;
  system("dhclient -r wlan0") ;
  system("dhclient -r eth0") ;
  #system("dhclient -v eth0") ;
}
elsif ($command eq "CLI")
{
  stopServices() ;
  system("cp /home/pi/wifi-config/cli/dhcpcd.conf /etc/dhcpcd.conf") ;
  system("cp /home/pi/wifi-config/cli/hosts /etc/hosts") ;
  system("cp /home/pi/wifi-config/cli/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf") ;
  system($iptables_flush) ;
  startServicesCli() ;
  system("dhclient -r wlan0") ;
  system("dhclient -r eth0") ;
  system("dhclient -v eth0") ;
  setFirstTimeConfigurationStatus() ;
  # system("dhclient -r wlan0") ;
  # system("dhclient -v wlan0") ;
  # system("dhclient -r eth0") ;
  # system("dhclient -v eth0") ;
}

exit ;
