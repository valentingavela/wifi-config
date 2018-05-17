#!/usr/local/bin/perl
use File::Slurp;

while (true) 
{
  sleep(1) ;
  clearScn() ;
  my $net_status = system('echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1') ;
  my $process_status = read_file( '/tmp/process_status' ) ;
			
  print("NET STAT: $net_status \n");
  print("PROCESS STATUS: $process_status \n");
 
  #Status 0 is internet connected
  #Status 256 no internet connected
  if($net_status != 0 && $process_status ne "AP") # check if ap actually configured
  {
      print("AP MODE \n") ;
      system("perl /home/pi/wifi-config/wifi-config.pl AP") ;
      system("echo -n AP > /tmp/actual_wifi_mode") ;
  }
  elsif($process_status ne "CLI")
  {
	  print("CLI MODE \n") ;
	  system("perl /home/pi/wifi-config/wifi-config.pl CLI") ;
	  system("echo -n CLI > /tmp/actual_wifi_mode") ;
  }
  else
  {
    print("do nothing") ;
  }
}

sub clearScn
{
	print "\033[2J";    #clear the screen
	print "\033[0;0H"; #jump to 0,0
}
