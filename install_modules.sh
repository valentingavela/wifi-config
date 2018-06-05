#!/bin/bash
echo "RUN AS SUDO!"
apt update &&
apt install dnsmask hostapd &&
ln -s /home/pi/wifi-config/web/css/   /var/www/html/css
ln -s /home/pi/wifi-config/web/img/   /var/www/html/img
ln -s /home/pi/wifi-config/web/index2.html  /var/www/html/index2.html
ln -s /home/pi/wifi-config/web/index.html   /var/www/html/index.html
ln -s /home/pi/wifi-config/web/js   /var/www/html/js
ln -s /home/pi/wifi-config/cgi/find_networks.pl   /var/www/html/cgi-bin/find_networks.pl
ln -s /home/pi/wifi-config/cgi/set_password.pl    /var/www/html/cgi-bin/set_password.pl

chmod o+w /var/lib/misc/dnsmasq.leases

cp sudo/sudoers /etc/sudoers
touch /home/pi/cfile
echo "* * * * * perl /home/pi/wifi-config/check-internet.pl >/dev/null 2>/dev/null" >> /home/pi/cfile
crontab /home/pi/cfiletouch /home/pi/cfile
