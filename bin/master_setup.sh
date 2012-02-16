#!/bin/bash

echo 'Update repository files'
sudo apt-get update
sudo apt-get -y upgrade

echo 'Setting up Salt Master'
echo 'Copying Salt Master config file to VM'
sudo cp /vagrant/etc/master.conf /etc/salt/master
#sudo cp /vagrant/etc/master/mincheck.json /etc/salt/

#echo 'Setup the Runner and Returner scripts'
#PYTHON_INSTALL_DIR=/usr/local/lib/python2.7/dist-packages
#cd $PYTHON_INSTALL_DIR/salt/returners
#sudo ln -s /vagrant/caramel/returners/zeromq_return.py zeromq_return.py
#cd $PYTHON_INSTALL_DIR/salt/runners
#sudo ln -s /vagrant/caramel/runners/minstatus.py minstatus.py

echo 'Setup Logstash scripts'
LOGSTASH_JAR=logstash-1.1.0-monolithic.jar
mkdir /usr/local/logstash
mkdir /etc/logstash
mkdir /var/log/logstash
cd /usr/local/logstash
wget http://semicomplete.com/files/logstash/logstash-1.1.0-monolithic.jar
cp /vagrant/etc/logstash/master.conf /etc/logstash 

echo 'Install Java'
sudo apt-get -y install openjdk-6-jre

echo 'Starting Salt Master process'
nohup sudo salt-master > /dev/null 2>&1 &
echo 'Salt Master process started'

echo 'Start Logstash process'
cd /usr/local/logstash
nohup java -jar $LOGSTASH_JAR agent -f /etc/logstash/master.conf > /var/log/logstash/logstash.out 2>&1 &
echo 'Logstash process started'
