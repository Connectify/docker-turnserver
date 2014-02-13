# Connectify Switchboard
#
# VERSION               0.0.1

FROM      stackbrew/ubuntu:13.10
MAINTAINER Connectify <dlewanda@connectify.me>

RUN mkdir -p /var/run/sshd

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y monit openssh-server pwgen curl rfc5766-turn-server #libcurses-ui-perl sysv-rc-conf

# Setup sshd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# install monit and get it running
RUN echo "startup=1" >> /etc/default/monit

# Copy the files into the container
ADD . /src

# expose the necessary ports
EXPOSE 3478 22

# set the working directory 
WORKDIR /tmp

# Start ssh services.
CMD ["/bin/bash", "/src/startup.sh"]
