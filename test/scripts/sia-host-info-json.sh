#!/usr/bin/env bash
# Author: Stefan Crawford
# Description: Take timestamped host information from redis to json

# Requires: jq redis 
### To install on Fedora ###
# sudo dnf -y install jq redis

# set to exit on error 
set -o errexit

# define RAM
readonly MEM=/dev/shm
readonly BACKUP=/home/smc/Documents

YAXIS="$1"

# nanoseconds since the epoch, 1970-01-01 00:00:00 UTC
readonly SIA_HOST_JSON_DATE=$( date +"%s%N" )

printf "[ [""$( redis-cli --csv LRANGE SIA_HOST_DATE 0 -1 )""], [""$( redis-cli --csv LRANGE $YAXIS 0 -1 )""] ]" | jq -cM '.' > $MEM/matrix-$1.json

rsync -pAv --append --progress --no-whole-file $MEM/matrix-$1.json $BACKUP 
