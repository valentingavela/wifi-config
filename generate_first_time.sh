#!/bin/bash
echo -n FIRST_TIME > /var/www/html/firstTimeConfiguration
echo -n > /var/lib/misc/dnsmasq.leases
echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" > /etc/wpa_supplicant/wpa_supplicant.conf
echo "update_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "country=AR" >> /etc/wpa_supplicant/wpa_supplicant.conf
cd  /var/www/html/siguitds/inmobiliarias/images/ &&
ls | head -n 1 | xargs rm
