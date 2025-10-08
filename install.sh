#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path

[ -f env ] && cp env-sample env
nano env
source $path/env

/bin/bash -c "$(curl -fsSL https://depin.tashi.network/install.sh)" -
