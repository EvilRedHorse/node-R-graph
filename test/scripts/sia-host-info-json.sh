#!/usr/bin/bash
# Author: Stefan Crawford
# Description: Take timestamped host information from redis to json

# Requires: jq redis 
### To install on Fedora ###
# sudo dnf -y install jq redis

# set to exit on error 
set -o errexit

# define RAM
MEM=/dev/shm
mkdir -p $MEM/json
# redis-server port
REDIS=6380

#YAXIS="$1"
#INTERVALS="$2"

# nanoseconds since the epoch, 1970-01-01 00:00:00 UTC
# readonly SIA_HOST_JSON_DATE=$( date +"%s%N" )
# seconds since the epoch, 1970-01-01 00:00:00 UTC
SIA_HOST_JSON_DATE=$( date +"%s" )

printf "[ [""$( redis-cli -p $REDIS --csv LRANGE SIA_HOST_DATE 0 $2 )""], [""$( redis-cli -p $REDIS --csv LRANGE $1 0 $2 )""] ]" | jq -c '.' > $MEM/json/matrix-$1.json
