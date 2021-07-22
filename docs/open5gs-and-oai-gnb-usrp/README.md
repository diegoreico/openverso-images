# open5gs and openairinterface enodeb 

5G end to end communication demo with open5gs and openairinterface enodeb.

# Deployment NGC and register subscribers

deploy the NGC core (open5gs) with:

```
docker-compose -f ngc.yaml up -d
```

Register subscriber in epc with `/register_subscriber.sh`.


# Deployment RAN (gnodeB)

Deploy with

```
docker-compose -f oai-gnb.yaml up -d
```

Undeploy with:

```
docker-compose -f oai-gnb.yaml down
```
