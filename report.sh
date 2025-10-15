#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=/root/logs/report-$folder
source /root/.bash_profile
source $path/env

version=$()
docker_status=$(docker inspect $CONTAINER | jq -r .[].State.Status)

bond=$(docker logs $CONTAINER | grep "resource node successfully bonded" | tail -1 | awk '{print $1}' | sed 's/\x1B\[[0-9;]*[A-Za-z]//g')
diff=$(( $(date +%s) - $(date -d "$bond" +%s) ))
if [ $diff -lt 60 ]; then ago="now";
elif [ $diff -lt 3600 ]; then ago="$(( diff / 60 ))m ago";
elif [ $diff -lt 86400 ]; then ago="$(( diff / 3600 ))h ago";
else ago="$(( diff / 86400 ))d ago";
fi

status="ok";message="bonded $ago"
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
        "m1":"bond=$ago",
        "m2":"$m2",
        "m3":"$m3",
        "url":"$url",
        "url2":"$url2",
        "url3":"$url3"
  }
}
EOF
cat $json | jq
