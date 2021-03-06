#!/bin/bash
set -x
testapp_IP=$(yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=reddit-app-net-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key ~/.ssh/appuser.pub | grep 'address'| tail -1 | awk '{print $2}')

echo "testapp_IP = $testapp_IP" >> README.md
echo "testapp_port = 9292" >> README.md
