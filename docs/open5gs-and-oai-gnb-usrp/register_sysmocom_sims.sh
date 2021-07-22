#!/bin/bash

CONTAINER_NAME=open5gs-and-oai-gnb-usrp_mongo_1

IMSI="901700000039226"
KI=491BB1C6E1179AED538028AE7AD525B3
OPC=3B7FB099B3A6D16873B33F023B1679E9

docker exec $CONTAINER_NAME mongo --eval "db.subscribers.update({\"imsi\" : \"$IMSI\"}, { \$setOnInsert: {\"imsi\" : \"$IMSI\",\"subscribed_rau_tau_timer\": NumberInt(12),\"network_access_mode\": NumberInt(2),\"subscriber_status\": NumberInt(0),\"access_restriction_data\": NumberInt(32),\"slice\":[{\"sst\": NumberInt(1),\"default_indicator\":true,\"session\":[{\"name\":\"internet\",\"type\":NumberInt(3),\"pcc_rule\":[],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"qos\":{\"index\":NumberInt(9),\"arp\":{\"priority_level\":NumberInt(8),\"pre_emption_capability\":NumberInt(1),\"pre_emption_vulnerability\":NumberInt(1)}}}]}],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"security\":{\"k\":\"$KI\",\"amf\":\"8000\",\"op\":null,\"opc\":\"$OPC\"}}}, upsert=true);" open5gs


IMSI="901700000039225"
KI=5AFD6C1613AEA3444B7995ABA09158BD
OPC=8B1C882709FFC01AC4120F7577428E2A

docker exec $CONTAINER_NAME mongo --eval "db.subscribers.update({\"imsi\" : \"$IMSI\"}, { \$setOnInsert: {\"imsi\" : \"$IMSI\",\"subscribed_rau_tau_timer\": NumberInt(12),\"network_access_mode\": NumberInt(2),\"subscriber_status\": NumberInt(0),\"access_restriction_data\": NumberInt(32),\"slice\":[{\"sst\": NumberInt(1),\"default_indicator\":true,\"session\":[{\"name\":\"internet\",\"type\":NumberInt(3),\"pcc_rule\":[],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"qos\":{\"index\":NumberInt(9),\"arp\":{\"priority_level\":NumberInt(8),\"pre_emption_capability\":NumberInt(1),\"pre_emption_vulnerability\":NumberInt(1)}}}]}],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"security\":{\"k\":\"$KI\",\"amf\":\"8000\",\"op\":null,\"opc\":\"$OPC\"}}}, upsert=true);" open5gs

