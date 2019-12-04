#!/usr/bin/env bash

# Title: convert ps to svg
# Author: Stefan Crawford

# Requires: rsync jq

# declare script and data locations
CONFIG=test/scripts/config.json

# define RAM
MEM=$( cat $CONFIG | jq -r .DATA.MEM )
USERNAME=$( cat $CONFIG | jq -r .REMOTE.USERNAME )
ECC_PASS=$( cat $CONFIG | jq -r .REMOTE.PASS )
ADDRESS=$( cat $CONFIG | jq -r .REMOTE.ADDRESS )
FOLDER=$( cat $CONFIG | jq -r .REMOTE.FOLDER )
readonly REMOTE_FOLDER=$USERNAME@$ADDRESS:$FOLDER

# redis-server port
REDIS=6380


array=( transactionfeeexpenses maxrevisebatchsize successfulreads maxduration index externalacceptingcontracts settingscalls renewcalls workingstatus minsectoraccessprice ProgressDenominator externalnetaddress potentialuploadbandwidthrevenue storagerevenue potentialcontractcompensation remainingstorage revisecalls contractcount loststoragecollateral lostrevenue capacity externalmaxduration maxcollateral errorcalls ProgressNumerator unlockhash mindownloadbandwidthprice netaddress downloadcalls successfulwrites mincontractprice minuploadbandwidthprice failedreads riskedstoragecollateral minbaserpcprice maxdownloadbatchsize failedwrites collateral lockedstoragecollateral contractcompensation path uploadbandwidthrevenue potentialstoragerevenue minstorageprice externalmaxdownloadbatchsize windowsize externalmaxrevisebatchsize acceptingcontracts connectabilitystatus formcontractcalls unrecognizedcalls downloadbandwidthrevenue capacityremaining potentialdownloadbandwidthrevenue sectorsize totalstorage collateralbudget )

#array=( capacityremaining storagerevenue )
for j in "${array[@]}"
do
   :
   # create json matrix from redis cache - currently executed manually server-side
   ~/node-R-graph/test/scripts/sia-host-info-json.sh "$j" $XINTERVALS
done

# skip unlockhash string
strings=( acceptingcontracts connectabilitystatus externalacceptingcontracts externalnetaddress netaddress path workingstatus )
for k in "${strings[@]}"
do
    :
    # print current string status to svg 
    printf  "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <svg xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\" height=\"575\" width=\"993\"><text x=\"15\" y=\"45\" fill=\"black\">$( redis-cli -p $REDIS --csv LRANGE $k 0 0 )</text></svg>"  > $MEM/json/status-$k.svg  
done

# update node "json" folder
rsync -rpvz --progress --rsh="/usr/bin/sshpass -p $ECC_PASS ssh -o StrictHostKeyChecking=no -l $USERNAME"  $MEM/json $REMOTE_FOLDER

unset USERNAME
unset ECC_PASS
