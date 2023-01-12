#!/usr/bin/env bash

# Title: convert ps to svg
# Author: Stefan Crawford

# Requires: inkscape rsync parallel jq R R-jsonlite

# declare script and data locations
CONFIG=scripts/config.json

MEM=$( cat $CONFIG | jq -r .DATA.MEM )
NODE=$( cat $CONFIG | jq -r .DATA.NODE )
SCRIPTS=$( cat $CONFIG | jq -r .DATA.SCRIPTS )
MATRIX=$( cat $CONFIG | jq -r .DATA.MATRIX )

# create folder to hold graphs
mkdir -p $MEM/graphs

# set array
array="$1"

# check if array is set and run
if [ -z "$array" ]
then
      array=( transactionfeeexpenses maxrevisebatchsize successfulreads maxduration index settingscalls renewcalls minsectoraccessprice ProgressDenominator potentialuploadbandwidthrevenue storagerevenue potentialcontractcompensation remainingstorage revisecalls contractcount loststoragecollateral lostrevenue capacity externalmaxduration maxcollateral errorcalls ProgressNumerator mindownloadbandwidthprice  downloadcalls successfulwrites mincontractprice minuploadbandwidthprice failedreads riskedstoragecollateral minbaserpcprice maxdownloadbatchsize failedwrites collateral lockedstoragecollateral contractcompensation uploadbandwidthrevenue potentialstoragerevenue minstorageprice externalmaxdownloadbatchsize windowsize externalmaxrevisebatchsize formcontractcalls unrecognizedcalls downloadbandwidthrevenue capacityremaining potentialdownloadbandwidthrevenue sectorsize totalstorage collateralbudget )
else
      echo "\$array is set"
fi

#array=( transactionfeeexpenses maxrevisebatchsize successfulreads maxduration index settingscalls renewcalls minsectoraccessprice ProgressDenominator potentialuploadbandwidthrevenue storagerevenue potentialcontractcompensation remainingstorage revisecalls contractcount loststoragecollateral lostrevenue capacity externalmaxduration maxcollateral errorcalls ProgressNumerator mindownloadbandwidthprice  downloadcalls successfulwrites mincontractprice minuploadbandwidthprice failedreads riskedstoragecollateral minbaserpcprice maxdownloadbatchsize failedwrites collateral lockedstoragecollateral contractcompensation uploadbandwidthrevenue potentialstoragerevenue minstorageprice externalmaxdownloadbatchsize windowsize externalmaxrevisebatchsize formcontractcalls unrecognizedcalls downloadbandwidthrevenue capacityremaining potentialdownloadbandwidthrevenue sectorsize totalstorage collateralbudget )
#array="$1"

# parallel - run R plot() function to produce a line graph from .json matrix
# R/runXY.r [folder/file_name.ps] [XY_matrix.json]
parallel --eta $SCRIPTS/R/runXY.r $MEM/graphs/graph-{}.ps $MATRIX/matrix-{}.json ::: ${array[*]}

# parallel - convert ps to svg with inkscape
parallel --eta inkscape -z $MEM/graphs/graph-{}.ps --export-plain-svg=$MEM/graphs/graph-{}.svg ::: ${array[*]}

#strings=( acceptingcontracts connectabilitystatus externalacceptingcontracts externalnetaddress netaddress path unlockhash workingstatus )

# parallel - rm used .ps
parallel --eta rm $MEM/graphs/graph-{}.ps ::: ${array[*]}

# rsync status & graph svg to $NODE/graphs folder
rsync -urpv --progress $MATRIX/status-*.svg $NODE/graphs/
rsync -urpvz --progress $MEM/graphs $NODE



exit 0

