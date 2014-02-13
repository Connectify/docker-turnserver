docker-turnserver
=================

A Docker container running the rfc5766-turn-server

This project provides the necessary steps to build a Docker container based on Ubuntu 13.10 running the baseline turnserver package for the rfc5766-turn-server application that is present in the default repository. The Docker file will install rfc5766-turn-server as well as monit to monitor the turnserver process and openssh-server to provide an SSH server so that the container can be accessed remotely.

After the container is started up the startup.sh script that is run sets up a user named "docker" and autogenerates a password that can be retrieved via the docker log command on the host. It retrieves the public IP address from the hsot that would be expected to be used by external STUN and TURN clients and sets up a basic rfc5766-turn-server configuration. It then configures and starts monit and sshd.

The project provides default rfc5766-turn-server and monitrc configuration files that can be configured prior to the build. Once built, you will need to expose the proper ports from the command line or by modifying the Dockerfile to include an EXPOSE directive. Don't forget to specify /udp to expose UDP ports!
