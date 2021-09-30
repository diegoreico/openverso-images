FROM ubuntu:bionic AS build

ARG version=v1.1.2

ENV VERSION=$version

ARG NEEDED_GIT_PROXY
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#install developers pkg/repo
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
       #gcc needed for build_oai
       build-essential \
       psmisc \
       software-properties-common \
       gnupg \
       git \
       vim \
       xxd \
       #unzip is needed for protobuf
       unzip \
    && rm -rf /var/lib/apt/lists/*

# In some network environments, GIT proxy is required
RUN /bin/bash -c "if [[ -v NEEDED_GIT_PROXY ]]; then git config --global http.proxy $NEEDED_GIT_PROXY; fi"

RUN apt-get update && apt-get install git
#create the WORKDIR
WORKDIR /openair-spgwu-tiny
RUN git clone https://github.com/OPENAIRINTERFACE/openair-spgwu-tiny.git /openair-spgwu-tiny
RUN git checkout $VERSION

# Installing and Building SPGW-U-TINY
WORKDIR /openair-spgwu-tiny/build/scripts
RUN ./build_spgwu --install-deps --force
RUN ./build_spgwu --clean --build-type Release --jobs --Verbose

#start from scratch for target executable
FROM ubuntu:bionic as oai-spgwu-tiny
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        tzdata \
        psmisc \
        net-tools \
        iproute2 \
        ethtool \
        iptables \
        tshark \
        perl \
        libldap-2.4-2 \
        libgoogle-glog0v5 \
        libdouble-conversion1 \
        libconfig++9v5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /openair-spgwu-tiny/bin
COPY --from=build /openair-spgwu-tiny/build/spgw_u/build/spgwu oai_spgwu
COPY --from=build /openair-spgwu-tiny/scripts/entrypoint.sh .

WORKDIR /usr/local/lib
COPY --from=build /usr/lib/libboost_system.so.1.67.0 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4 .
COPY --from=build /usr/lib/x86_64-linux-gnu/librtmp.so.1 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libpsl.so.5 .

RUN ldconfig

# Copying template configuration files
WORKDIR /openair-spgwu-tiny/etc
COPY --from=build /openair-spgwu-tiny/etc/spgw_u.conf .

WORKDIR /openair-spgwu-tiny

# expose ports
EXPOSE 2152/udp 8805/udp

CMD ["/openair-spgwu-tiny/bin/oai_spgwu", "-c", "/openair-spgwu-tiny/etc/spgw_u.conf", "-o"]
ENTRYPOINT ["/openair-spgwu-tiny/bin/entrypoint.sh"]