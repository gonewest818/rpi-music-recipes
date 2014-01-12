#!/bin/sh

apt-get --yes update
apt-get --yes upgrade
apt-get install libao-dev libssl-dev libavahi-client-dev libasound2-dev

#package
cd /tmp
git clone https://github.com/abrasive/shairport.git
cd shairport
./configure
make install
chmod a+x /etc/init.d/shairport

# init scripts
cp scripts/debian/default/shairport /etc/default/shairport
cp scripts/debian/init.d/shairport /etc/init.d/shairport
cp scripts/debian/logrotate.d/shairport /etc/logrotate.d/shairport
update-rc.d shairport defaults

