#!/bin/bash

apt update && apt upgrade -y
apt install wget unzip curl openssl build-essential libgd-dev libssl-dev libapache2-mod-php php-gd php apache2 -y
mkdir nagios
cd nagios
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
tar -zxvf nagios-4.4.6.tar.gz
cd nagios-4.4.6
./configure 
make all
make install-groups-users
usermod -aG nagios www-data
make install
make install-init
make install-commandmode
make install-config
make install web-conf
a2enmod rewrite cgi
a2enmod cgi
ufw allow apache
ufw enable
ufw reload
systemctl restart apache2
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar -zxvf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make install
/usr/local/nagios/bin/nagios -v


