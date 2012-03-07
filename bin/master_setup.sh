#!/bin/bash

if [ -f /etc/apt/sources.list.d/oab.list ]; then
  echo 'Removing unnecessry apt repository file'
  rm /etc/apt/sources.list.d/oab.list
fi

echo 'Update repository files'
sudo apt-get update
sudo apt-get -y upgrade

echo 'Setting up Salt Master'
echo 'Copying Salt Master config file to VM'
sudo cp /vagrant/etc/salt/master.conf /etc/salt/master

echo 'Setup Logstash scripts'
LOGSTASH_JAR=logstash-1.1.0-monolithic.jar
[ -d /usr/local/lib/logstash ] || mkdir /usr/local/lib/logstash
[ -d /etc/logstash ] || mkdir /etc/logstash

if [ -f /vagrant/etc/srv/salt/logstash/$LOGSTASH_JAR ]; then
    echo 'Copying from local dir'
    cp /vagrant/etc/srv/salt/logstash/$LOGSTASH_JAR /usr/local/lib/logstash
else
    echo 'Downloading from remote site'
    cd /usr/local/lib/logstash
    wget http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar    
fi
cp /vagrant/etc/logstash/master.conf /etc/logstash 

echo 'Setting up log permissions for Salt'
[ -d /var/log/salt ] || sudo mkdir /var/log/salt
sudo chgrp -R adm /var/log/salt
sudo chmod -R 750 /var/log/salt

echo 'Starting Salt Master process'
nohup sudo salt-master > /dev/null 2>&1 &
echo 'Salt Master process started'

echo 'Start Logstash process'
cd /usr/local/lib/logstash
nohup java -jar $LOGSTASH_JAR agent -f /etc/logstash/master.conf > /var/log/logstash.log 2>&1 &
echo 'Logstash process started'
