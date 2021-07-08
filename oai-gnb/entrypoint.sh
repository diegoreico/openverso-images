#!/bin/bash

set -ex

#If not provided get IP_ADDR from interfaces
if [[ -z "${GNB_BIND_ADDR}" ]] ; then
    export GNB_BIND_ADDR=$(ip addr show $GNB_BIND_INTERFACE | grep -Po 'inet \K[\d.]+/\d+')
fi


# Resolve IP ADDRESS if hostname is provided
if [[ ! -z "$AMF_HOSTNAME" ]] ; then 
    export AMF_ADDR="$(host -4 $AMF_HOSTNAME |awk '/has.*address/{print $NF; exit}')"
fi


echo "Launching oai enb"
envsubst < $GNB_TEMPLATE_PATH > gnb.conf

if [ $MODE == "SA" ]; then
  /opt/oai/bin/nr-softmodem -O gnb.conf -E --sa
elif [ $MODE == "NSA" ]; then
  /opt/oai/bin/nr-softmodem -O gnb.conf -E
else
  echo "unknown MODE $MODE. Must be SA or NSA"
fi
