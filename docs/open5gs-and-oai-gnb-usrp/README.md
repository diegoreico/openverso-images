# 5G SA: open5gs and openairinterface gnodeb

5G SA end to end communication demo with open5gs and openairinterface gnodeb.

## Configuration

- edit open5gs-config/amf.yaml to set your MCC and MNC codes.

- edit oai-gnb.yaml to set your MCC and MNC codes.


## Deployment NGC and register subscribers

deploy the NGC core (open5gs) with:

```
docker-compose -f ngc.yaml up -d
```

Register subscribers in ngc using webui at [http://localhost:3000](http://localhost:3000). 

User: admin, Password: 1423


## Deployment RAN (gnodeB)

Deploy with

```
docker-compose -f oai-gnb.yaml up -d
```

Undeploy with:

```
docker-compose -f oai-gnb.yaml down
```
