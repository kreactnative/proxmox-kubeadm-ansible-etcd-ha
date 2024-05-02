#!/bin/bash

echo $1

MAX_RETRIES=30
RETRY_INTERVAL=20
IP_REGEX='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

#echo "1234" | sudo -S -v
for ((i = 1; i <= MAX_RETRIES; i++)); do
  address=$(ip -6 neigh show | grep "$1" | awk ' { printf $1 } ')
  echo $i
  if [[ -n "$address" && "$address" =~ $IP_REGEX ]]; then
    jq -n --arg address "$address" '{"address":$address}'
    exit 0
  fi
  
  if [ $i -lt $MAX_RETRIES ]; then
    sleep $RETRY_INTERVAL
  else
    echo "Maximum retries reached. Address not found."
    exit 1
  fi
done