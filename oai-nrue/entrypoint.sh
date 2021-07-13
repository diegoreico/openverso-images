#!/bin/bash

set -ex

# Resolve IP ADDRESS if hostname is provided
if [[ ! -z "$GNB_HOSTNAME" ]] ; then 
    export GNB_ADDR="$(host -4 $GNB_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi


echo "Launching oai nr-ue"

if [ $MODE == "SA" ]; then
  RFSIMULATOR=$GNB_ADDR /opt/oai/bin/nr-uesoftmodem -r 106 --numerology 1 --band 78 -C 3619200000 --rfsim --sa
elif [ $MODE == "NSA" ]; then
  /opt/oai/bin/nr-softmodem -O gnb.conf -E
else
  echo "unknown MODE $MODE. Must be SA or NSA"
fi
