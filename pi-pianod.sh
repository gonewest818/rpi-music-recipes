#!/bin/sh

set -x

apt-get --yes update
apt-get --yes upgrade
apt-get --yes install libao-dev libgcrypt11-dev libgnutls-dev libjson0-dev libfaad-dev libmad0-dev

# pulse audio really necessary?
#apt-get --yes install pulseaudio

# need this if running pianod from init.d as root
usermod -a -G audio root


cd /tmp
curl http://deviousfish.com/Downloads/pianod/pianod-137.tar.gz -o pianod-137.tar.gz
tar xfz pianod-137.tar.gz
cd pianod-137
./configure && make && make install

cp contrib/pianod.raspbian.init /etc/init.d/pianod
chmod a+x /etc/init.d/pianod

cat > /etc/pianod.conf << EOF
#!/bin/sh
DAEMON=/usr/local/bin/pianod
STARTSCRIPT=/etc/pianod.startscript
USERFILE=/etc/pianod.passwd
# default port 4445
PORT=
# LOGGING=-Z/dev/stderr
LOGGING=
# run as user pi
ARGS="-n pi"
EOF

cat > /etc/pianod.startscript << EOF
pandora user USERNAME PASSWORD
play mix
EOF

update-rc.d pianod defaults

cd /tmp
curl http://deviousfish.com/Downloads/wsgw/wsgw-21.tar.gz -o wsgw-21.tar.gz
tar xfz wsgw-21.tar.gz
cd wsgw-21
./configure && make && make install

cp contrib/wsgw.raspbian.init /etc/init.d/wsgw
chmod a+x /etc/init.d/wsgw

cat > /etc/wsgw.conf << EOF
#!/bin/sh
DAEMON=/usr/local/bin/wsgw
PORT=
# LOGGING='-l -h'
LOGGING=
SERVICES=
SERVICES="\$SERVICES pianod,localhost,4445,text"
EOF

update-rc.d wsgw defaults

