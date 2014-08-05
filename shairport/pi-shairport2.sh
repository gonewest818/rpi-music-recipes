#!/bin/sh

apt-get --yes update
apt-get --yes upgrade
apt-get install libao-dev libssl-dev libavahi-client-dev libasound2-dev avahi-daemon

# configuration
cp shairport2.default /etc/default/shairport
cp logrotate.shairport /etc/logrotate.d/shairport

# alsa
amixer cset numid=3 1
# may need to edit alsa.conf also

# shairport package
cd /tmp
git clone https://github.com/abrasive/shairport.git
cd shairport
./configure
PREFIX=/usr make install

# init scripts
cp scripts/debian/init.d/shairport /etc/init.d/shairport
chmod a+x /etc/init.d/shairport
update-rc.d shairport defaults
update-rc.d avahi-daemon defaults


