#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required, $# provided"

if [ -f /etc/apt/sources.list.d/oab.list ]; then
  echo 'Removing unnecessry apt repository file'
  rm /etc/apt/sources.list.d/oab.list
fi

echo 'Updating repsoitory files'
sudo apt-get update
sudo apt-get -y upgrade

echo 'Setting up Salt Minion with name: ' $min_name 
echo 'Salt Master IP address is ' $1

[ -f /vagrant/etc/salt/minion.conf ] || die "File: /vagrant/etc/salt/minion.conf does not exist"

sudo sed 's/#master: salt/master: '${1}'/g' /vagrant/etc/salt/minion.conf | sudo tee /etc/salt/minion > /dev/null

echo 'Starting Salt Minion'
nohup sudo salt-minion > /dev/null 2>&1 &
echo 'Salt Minion started'

# echo 'Call state.highstate command to configure minion'
# sudo salt-call state.highstate
