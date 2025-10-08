#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$()
docker_status=$(docker inspect $CONTAINER | jq -r .[].State.Status)

status="ok"
[ $errors -gt 100 ] && status="warning" && message="too many errors ($errors/h)"
[ "$docker_status" != "running" ] && status="error" && message="docker not running ($docker_status)"

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
         "id":"$folder-$ID",
         "machine":"$MACHINE",
         "grp":"node",
         "owner":"$OWNER"
  },
  "fields": {
        "network":"testnet",
        "chain":"solana-dev",
        "status":"$status",
        "message":"$message",
        "version":"$version",
        "height":"$height",
        "errors":"$errors",
        "m1":"$m1",
        "m2":"$m2",
        "m3":"$m3",
        "url":"$url",
        "url2":"$url2",
        "url3":"$url3"
  }
}
EOF
cat $json | jq
