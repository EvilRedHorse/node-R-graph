#!/usr/bin/env bash
# Author: Stefan Crawford
# Description: Take timestamped host information into redis, intervals set using crontab

# Requires: jq redis 
### To install on Fedora ###
# sudo dnf -y install jq redis

# set to exit on error 
set -o errexit

### function to print multiple blank lines: instead of /n/n/n/n/n -> lines 5 
function lines { yes '' | sed ${1}q ; }

# define RAM
readonly MEM=$( cat config.json | jq .DATA )
# HOST address
readonly HOST=$( cat config.json | jq .HOST )
# burst/rate-limit
readonly CURL=$( cat config.json | jq .TOOLS.CURL )
# redis-server port
readonly REDIS=6380

# seconds since the epoch, 1970-01-01 00:00:00 UTC
SIA_HOST_DATE=$( date +"%s" )

# cache atomic date & print dates from cached linked-list
printf "\nCaching date... " && redis-cli -p $REDIS -n 0 LPUSH SIA_HOST_DATE "$SIA_HOST_DATE" && redis-cli -p $REDIS LRANGE SIA_HOST_DATE 0 -1

# load initial host info into MEM
$CURL -i -A "SiaPrime-Agent" -u "":foobar $HOST/host | grep { > $MEM/SIA_HOST_INFO
# load initial host storage info into MEM
$CURL -i -A "SiaPrime-Agent" -u "":foobar $HOST/host/storage | grep { > $MEM/SIA_HOST_STORAGE_INFO
lines 2
####### External Settings - Start #######
printf "External Settings:"
lines 1
printf "\nCaching external maxdownloadbatchsize... " && redis-cli -p $REDIS -n 0 LPUSH externalmaxdownloadbatchsize $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .maxdownloadbatchsize ) && redis-cli -p $REDIS LRANGE externalmaxdownloadbatchsize 0 -1
printf "\nCaching external maxduration... " && redis-cli -p $REDIS -n 0 LPUSH externalmaxduration $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .maxduration ) && redis-cli -p $REDIS LRANGE externalmaxduration 0 -1
printf "\nCaching external maxrevisebatchsize... " && redis-cli -p $REDIS -n 0 LPUSH externalmaxrevisebatchsize $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .maxrevisebatchsize ) && redis-cli -p $REDIS LRANGE externalmaxrevisebatchsize 0 -1
array=( remainingstorage sectorsize totalstorage unlockhash )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
printf "\nCaching external netaddress... " && redis-cli -p $REDIS -n 0 LPUSH externalnetaddress $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .netaddress ) && redis-cli -p $REDIS LRANGE externalnetaddress 0 -1
printf "\nCaching external acceptingcontracts... " && redis-cli -p $REDIS -n 0 LPUSH externalacceptingcontracts $( cat $MEM/SIA_HOST_INFO | jq .externalsettings | jq -r .acceptingcontracts ) && redis-cli -p $REDIS LRANGE externalacceptingcontracts 0 -1
lines 2
####### External Settings - End #######

####### Financial Metrics - Start #######
printf "Financial Metrics:"
lines 1
array=( contractcount contractcompensation potentialcontractcompensation  lockedstoragecollateral lostrevenue loststoragecollateral potentialstoragerevenue riskedstoragecollateral storagerevenue transactionfeeexpenses downloadbandwidthrevenue potentialdownloadbandwidthrevenue potentialuploadbandwidthrevenue uploadbandwidthrevenue )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_INFO | jq .financialmetrics | jq -r .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
lines 2
####### Financial Metrics - End #######

####### Internal Settings - Start #######
printf "Internal Settings:"
lines 1
array=( acceptingcontracts maxdownloadbatchsize maxduration maxrevisebatchsize netaddress windowsize collateral collateralbudget maxcollateral minbaserpcprice mincontractprice mindownloadbandwidthprice minsectoraccessprice minstorageprice minuploadbandwidthprice )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_INFO | jq .internalsettings | jq -r .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
lines 2
####### Internal Settings - End #######

####### RPC Stats aka netmetrics - Start #######
printf "RPC State aka netmetrics:"
lines 1
array=( downloadcalls errorcalls formcontractcalls renewcalls revisecalls settingscalls unrecognizedcalls )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_INFO | jq .networkmetrics | jq .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
array=( connectabilitystatus workingstatus )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_INFO | jq -r .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
lines 2
####### RPC Stats aka netmetrics - End #######

####### Storage  #######
printf "Storage:"
lines 1
array=( capacity capacityremaining index path failedreads failedwrites successfulreads successfulwrites ProgressNumerator ProgressDenominator )
for i in "${array[@]}"
do
   : 
   printf "\nCaching $i... Total: " && redis-cli -p $REDIS -n 0 LPUSH $i $( cat $MEM/SIA_HOST_STORAGE_INFO | jq .folders[-1] | jq -r .$i ) && redis-cli -p $REDIS LRANGE $i 0 -1
done
####### Storage Folders - End #######
