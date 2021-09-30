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
WORKDIR /openair-smf
RUN git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-smf.git /openair-smf
RUN git checkout $VERSION

# Installing and Building SMF
WORKDIR /openair-smf/build/scripts
RUN ./build_smf --install-deps --force
RUN ./build_smf --clean --Verbose --build-type Release --jobs

#start from scratch for target executable
FROM ubuntu:bionic as oai-smf
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        psmisc \
        net-tools \
        tzdata \
        bc \
        tshark \
        perl \
        openssl \
        libasan4 \
        libldap-2.4-2 \
        libgoogle-glog0v5 \
        libdouble-conversion1 \
        libconfig++9v5 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /openair-smf/bin
COPY --from=build /openair-smf/build/smf/build/smf oai_smf
COPY --from=build /openair-smf/scripts/entrypoint.sh .

WORKDIR /usr/local/lib/
COPY --from=build /usr/local/lib/libpistache.so .
COPY --from=build /usr/local/lib/libnghttp2_asio.so.1 .
COPY --from=build /usr/lib/libboost_system.so.1.67.0 .
COPY --from=build /usr/lib/libboost_thread.so.1.67.0 .
COPY --from=build /usr/lib/libboost_chrono.so.1.67.0 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4 .
COPY --from=build /usr/lib/x86_64-linux-gnu/librtmp.so.1 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libpsl.so.5 .
COPY --from=build /openair-smf/build/smf/build/nas/libNAS.so .

RUN ldconfig

# Copying template configuration files
WORKDIR /openair-smf/etc
COPY --from=build /openair-smf/etc/smf.conf .

WORKDIR /openair-smf

# expose ports
EXPOSE 80/tcp 9090/tcp 8805/udp

ENTRYPOINT ["/bin/bash","/openair-smf/bin/entrypoint.sh"]
CMD ["/openair-smf/bin/oai_smf", "-c", "/openair-smf/etc/smf.conf", "-o"]