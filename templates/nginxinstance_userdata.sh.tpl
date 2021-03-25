#!/usr/bin/env bash

#Setup hostname and fqdn resolved to private ip
apt-get update
apt-get install awscli -y
aws configure set region ap-south-1

apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce=5:18.09.2~3-0~ubuntu-xenial
usermod -aG docker ubuntu

sudo service docker stop
sudo service docker start


