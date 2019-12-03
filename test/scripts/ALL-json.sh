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


array=( transactionfeeexpenses maxrevisebatchsize successfulreads maxduration index externalacceptingcontracts settingscalls renewcalls workingstatus minsectoraccessprice ProgressDenominator externalnetaddress potentialuploadbandwidthrevenue storagerevenue potentialcontractcompensation remainingstorage revisecalls contractcount loststoragecollateral lostrevenue capacity externalmaxduration maxcollateral errorcalls ProgressNumerator unlockhash mindownloadbandwidthprice netaddress downloadcalls successfulwrites mincontractprice minuploadbandwidthprice failedreads riskedstoragecollateral minbaserpcprice maxdownloadbatchsize failedwrites collateral lockedstoragecollateral contractcompensation path uploadbandwidthrevenue potentialstoragerevenue minstorageprice externalmaxdownloadbatchsize windowsize externalmaxrevisebatchsize acceptingcontracts connectabilitystatus formcontractcalls unrecognizedcalls downloadbandwidthrevenue capacityremaining potentialdownloadbandwidthrevenue sectorsize totalstorage collateralbudget )


#array=( capacityremaining storagerevenue )
for i in "${array[@]}"
do
   :
   # create json matrix from redis cache - currently executed manually server-side
   ./sia-host-info-json.sh $i
done

# update node "graphs" folder
rsync -urpvz --progress --rsh="/usr/bin/sshpass -p $ECC_PASS ssh -o StrictHostKeyChecking=no -l $USERNAME"  $MEM/json $REMOTE_FOLDER

unset USERNAME
unset ECC_PASS
