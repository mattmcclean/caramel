#!/bin/bash

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

if [ -f /vagrant/downloads/$LOGSTASH_JAR ]; then
    echo 'Copying from local dir'
    cp /vagrant/downloads/$LOGSTASH_JAR /usr/local/lib/logstash
else
    echo 'Downloading from remote site'
    cd /usr/local/lib/logstash
    wget http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar    
fi
cp /vagrant/etc/logstash/master.conf /etc/logstash 

echo 'Install Java'
sudo apt-get -y install openjdk-6-jre

echo 'Starting Salt Master process'
nohup sudo salt-master > /dev/null 2>&1 &
echo 'Salt Master process started'

echo 'Start Logstash process'
cd /usr/local/lib/logstash
nohup java -jar $LOGSTASH_JAR agent -f /etc/logstash/master.conf > /var/log/logstash.log 2>&1 &
echo 'Logstash process started'
