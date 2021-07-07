FROM ran-build

MAINTAINER psanuy <psanuy@gradiant.org>

RUN apt-get update && apt-get upgrade -y && apt-get install iputils-ping net-tools apt-utils -y && git checkout develop && git pull && /bin/sh oaienv && cd cmake_targets && ./build_oai --nrUE -w USRP
