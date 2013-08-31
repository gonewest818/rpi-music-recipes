#!/bin/sh

set -x

apt-get --yes update
apt-get --yes upgrade
apt-get --yes install libao-dev libgcrypt11-dev libgnutls-dev libjson0-dev libfaad-dev libmad0-dev

# pulse audio really necessary?
#apt-get --yes install pulseaudio

# need this if running pianod from init.d as root
usermod -a -G audio root

# install config files
cp pianod.conf /etc/pianod.conf
cp pianod.startscript /etc/pianod.startscript
cp pianod.init /etc/init.d/pianod
chmod a+x /etc/init.d/pianod
cp wsgw.conf /etc/wsgw.conf
cp wsgw.init /etc/init.d/wsgw
chmod a+x /etc/init.d/wsgw

# install pianod
cd /tmp
curl http://deviousfish.com/Downloads/pianod/pianod-149.tar.gz -o pianod-149.tar.gz
tar xfz pianod-149.tar.gz
cd pianod-149
./configure && make && make install

# pianod init script
update-rc.d pianod defaults

#install wsgw
cd /tmp
curl http://deviousfish.com/Downloads/wsgw/wsgw-24.tar.gz -o wsgw-24.tar.gz
tar xfz wsgw-24.tar.gz
cd wsgw-24
./configure && make && make install

# wsgw init script
update-rc.d wsgw defaults

