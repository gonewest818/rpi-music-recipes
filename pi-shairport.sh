#!/bin/sh

apt-get --yes update
apt-get --yes upgrade
#apt-get --yes install pulseaudio
sudo apt-get install git libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils libmodule-build-perl

# init scripts
cp shairport.init /etc/init.d/shairport

cd /tmp
git clone https://github.com/njh/perl-net-sdp.git perl-net-sdp
cd perl-net-sdp
perl Build.PL
sudo ./Build
sudo ./Build test
sudo ./Build install

cd /tmp
git clone https://github.com/hendrikw82/shairport.git
cd shairport
make install
chmod a+x /etc/init.d/shairport
update-rc.d shairport defaults

