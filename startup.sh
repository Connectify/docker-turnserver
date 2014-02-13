#!/bin/bash
LANG=C #needed for perl locale

# Create the directory needed to run the sshd daemon
#[ -d /var/run/switchd ] || mkdir -p /var/run/sshd 

# Add docker user and generate a random password with 12 characters that includes at least one capital letter and number.
DOCKER_PASSWORD=`pwgen -c -n -1 12`
echo User: docker Password: $DOCKER_PASSWORD
DOCKER_ENCRYPYTED_PASSWORD=`perl -e 'print crypt('"$DOCKER_PASSWORD"', "aa"),"\n"'`
useradd -m -d /home/docker -p $DOCKER_ENCRYPYTED_PASSWORD docker
sed -Ei 's/adm:x:4:/docker:x:4:docker/' /etc/group
adduser docker sudo

# Set the default shell as bash for docker user.
chsh -s /bin/bash docker

# Start the turn server
cp /src/turnserver.conf /etc/turnserver.conf
publicIp=`curl ipecho.net/plain`
echo public IP = $publicIp
sed -i "s/^#external-ip=XXX.XXX.XXX.XXX/external-ip=$publicIp/" /etc/turnserver.conf
sed -i 's/^#TURNSERVER_ENABLED.*/TURNSERVER_ENABLED=1/' /etc/default/rfc5766-turn-server
service rfc5766-turn-server start

# start monit and make sure it's always on at boot
cp /src/monitrc /etc/monit/monitrc
service monit start
#sysv-rc-conf monit on

# Start the ssh service
/usr/sbin/sshd -D
