#! /bin/sh

#sudo su
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
sudo echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install mongodb-10gen