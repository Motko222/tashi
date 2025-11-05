#!/bin/bash
path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

docker stop $CONTAINER
docker rm $CONTAINER

#run original script
#/bin/bash -c "$(curl -fsSL https://depin.tashi.network/install.sh)" -

#run without interactions
wget https://depin.tashi.network/install.sh -O script
chmod +x script

sed -i '/prompt/ { /choice/ c\
choice=y
}' script

./script
