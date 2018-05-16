#!/bin/bash

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Online"
else
    perl /home/pi/wifi-config.pl AP
fi

if [ `cat /tmp/configure_wifi` -eq 1 ]; then
  echo "configure wifi" &&
  perl /home/pi/wifi-config.pl CLI &&
  echo 0 > /tmp/configure_wifi
else
  echo "not configure wifi"
fi
