FROM ubuntu:bionic AS build

ARG version=v1.1.0

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
WORKDIR /openair-nrf
RUN git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-nrf.git /openair-nrf
RUN git checkout $VERSION

# Installing and Building NRF
WORKDIR /openair-nrf/build/scripts
RUN ./build_nrf --install-deps --force
RUN ./build_nrf --clean --Verbose --build-type Release --jobs

#start from scratch for target executable
FROM ubuntu:bionic as oai-nrf
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        psmisc \
        net-tools \
        iputils-ping \
        bc \
        tzdata \
        tshark \
        libasan4 \
        libgoogle-glog0v5 \
        libdouble-conversion1 \
        libconfig++9v5 \
        libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /openair-nrf/bin
COPY --from=build /openair-nrf/build/nrf/build/nrf oai_nrf
COPY --from=build /openair-nrf/scripts/entrypoint.sh entrypoint.sh
COPY --from=build /usr/local/lib/libpistache.so /usr/local/lib/
COPY --from=build /usr/local/lib/libnghttp2_asio.so.1 /usr/local/lib/
COPY --from=build /usr/lib/x86_64-linux-gnu/libboost_system.so.1.65.1 /usr/lib/x86_64-linux-gnu/
COPY --from=build /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.65.1 /usr/lib/x86_64-linux-gnu/

RUN ldconfig

# Copying template configuration files
WORKDIR /openair-nrf/etc
COPY --from=build /openair-nrf/etc/nrf.conf .

WORKDIR /openair-nrf

# expose ports
EXPOSE 80/tcp 9090/tcp

ENTRYPOINT ["/bin/bash","/openair-nrf/bin/entrypoint.sh"]
CMD ["/openair-nrf/bin/oai_nrf", "-c", "/openair-nrf/etc/nrf.conf", "-o"]