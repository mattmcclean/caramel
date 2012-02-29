#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required, $# provided"

echo 'Updating repsoitory files'
sudo apt-get update
sudo apt-get -y upgrade

echo 'Setting up Salt Minion with name: ' $min_name 
echo 'Salt Master IP address is ' $1

[ -f /vagrant/etc/salt/minion.conf ] || die "File: /vagrant/etc/salt/minion.conf does not exist"

sudo sed 's/#master: salt/master: '${1}'/g' /vagrant/etc/salt/minion.conf | sudo tee /etc/salt/minion > /dev/null

if [ ! -d /usr/local/lib/logstash ]; then
    echo 'Creating dir /usr/local/lib/logstash'
    mkdir /usr/local/lib/logstash
fi

LOGSTASH_JAR=logstash-1.1.0-monolithic.jar
if [ -f /vagrant/downloads/$LOGSTASH_JAR ]; then
    echo 'Copying local copy of $LOGSTASH_JAR'
    cp /vagrant/downloads/$LOGSTASH_JAR /usr/local/lib/logstash
fi

ELASTICSEARCH_ZIP=elasticsearch-0.18.7.zip
if [ -f /vagrant/downloads/$ELASTICSEARCH_ZIP ]; then
    echo 'Copying local copy of $ELASTICSEARCH_ZIP'
    cp /vagrant/downloads/$ELASTICSEARCH_ZIP /tmp
fi

echo 'Setting up log permissions for Salt'
[ -d /var/log/salt ] || sudo mkdir /var/log/salt
sudo chgrp -R adm /var/log/salt
sudo chmod -R 750 /var/log/salt

echo 'Starting Salt Minion'
nohup sudo salt-minion > /dev/null 2>&1 &
echo 'Salt Minion started'

# echo 'Call state.highstate command to configure minion'
# sudo salt-call state.highstate
