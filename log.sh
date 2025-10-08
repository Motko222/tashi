#!/bin/bash
path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

docker logs -f --tail 200 $CONTAINER
