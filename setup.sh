#!/bin/bash

reset

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

scriptName=$(basename $0)

function error() {
    jobName="$0"
    lastLine="$1"
    lastErr="$2"
    echo "${scriptName} - ERROR in ${jobName} : line ${lastLine} with exit code ${lastErr}"
    exit 1
}
trap 'error ${LINENO} ${?}' ERR

function installPackage() {
    packageName="$1"

}

echo "\t##############################################################"
echo "\t#                Drupal Installation                         #"
echo "\t##############################################################"

echo "Installing Pre-requisites...."
echo ""
echo "Installing ansible"
yum install -y ansible 

echo "Installing git"
yum install -y git

echo "Download ansible playbook from git and place in /etc/ansible folder"
git clone https://github.com/vinayku5/ansible-playbook /tmp
rm -rf /etc/ansible/*
cp -r /tmp/ansible-playbook/* /etc/ansible/

echo "Installing Apache2,PHP,Mysql"
echo "Installation through ansible playbook"
echo "Playbook installs webserver and setups drupal"

ansible-playbook /etc/ansible/webserver.yml

if [$? -ne 0 ]; then
    ansible-playbook /etc/ansible/roles/rollback/tasks/main.yml
fi






