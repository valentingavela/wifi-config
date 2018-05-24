#!/usr/local/bin/perl
use File::Slurp;
sleep(40) ;

while (true) 
{
  sleep(15) ;
  #clearScn() ;
  my $net_status = networkStatus() ;
  my $process_status = read_file( '/tmp/process_status' ) ;
			
  print("NET STAT: $net_status \n");
  print("PROCESS STATUS: $process_status \n");

  #Status 0 is internet connected
  #Status 256 no internet connected
  if($net_status == 0)
  {
	  #DO NOTHING
	  system("echo -n CONNECTED > /tmp/process_status") ;
  }
  elsif($net_status == 256 && $process_status ne "AP_IS_SET" && $process_status ne "WAIT_FOR_CLIENT" && $process_status ne "CLIENT_SET_PASSWORD")
  {
	  #SET AP MODE
	  print("SETTING AP MODE \n") ;
  	  system("echo -n AP_IS_SET > /tmp/process_status") ;  
      system("perl /home/pi/wifi-config/wifi-config.pl AP") ;
      system("echo -n WAIT_FOR_CLIENT > /tmp/process_status") ;  
  }
  elsif($process_status eq "CLIENT_SET_PASSWORD")
  #($net_status == 256 && $process_status ne "CLI_IS_SET" && $process_status ne "WAIT_FOR_CLIENT")
  {
	  print("SETTING CLI MODE \n") ;
	  system("echo -n CLI_IS_SET > /tmp/process_status") ;
	  system("perl /home/pi/wifi-config/wifi-config.pl CLI") ;
	  
	  sleep(1) ;
	  
	  if(waitForInternet() == 0) #IF NO INTERNET
	  {
		system("echo -n CANT_CONNECT > /tmp/process_status") ;		  
	  }
  }
}

sub clearScn
{
	print "\033[2J";    #clear the screen
	print "\033[0;0H"; #jump to 0,0
}

sub networkStatus
{
	#0 is internet
	#256 NO INTERNET
	return system('echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1') ;
}

sub waitForInternet
{
	my $status = 0 ;
	foreach my $i (0..5)
	{
		if(networkStatus() == 0)
		{
			$status = 1 ;	
			print("CONNECTED TO INTERNET. Try $i \n") ;
			sleep(1) ;
			last ;
		}
		else
		{
			print("Wainting For internet. Try $i \n") ;
			sleep(3) ;
		}
	}
	return $status ;
}
