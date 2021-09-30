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
WORKDIR /openair-amf/
RUN git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-amf.git /openair-amf
RUN git checkout $VERSION

# Installing all the needed libraries/packages to build and run AMF
WORKDIR /openair-amf/build/scripts
RUN ./build_amf --install-deps --force

# Building AMF
WORKDIR /openair-amf/build/scripts
RUN ./build_amf --clean --Verbose --build-type Release --jobs

#start from scratch for target executable
FROM ubuntu:bionic as oai-amf
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        tzdata \
      psmisc \
      net-tools \
      bc \
      openssl \
      perl \
      tshark \
      libasan4 \
      libldap-2.4-2 \
      libconfig++9v5 \
      libsctp1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /openair-amf/bin
COPY --from=build /openair-amf/build/amf/build/amf oai_amf
COPY --from=build /openair-amf/scripts/entrypoint.sh entrypoint.sh

WORKDIR /usr/lib/x86_64-linux-gnu
COPY --from=build /usr/lib/x86_64-linux-gnu/libmysqlclient.so.20 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4 .
COPY --from=build /usr/lib/x86_64-linux-gnu/librtmp.so.1 .
COPY --from=build /usr/lib/x86_64-linux-gnu/libpsl.so.5 .

WORKDIR /usr/local/lib
COPY --from=build /usr/lib/libboost_system.so.1.67.0 .
COPY --from=build /usr/lib/libboost_thread.so.1.67.0 .
COPY --from=build /usr/lib/libboost_chrono.so.1.67.0 .
COPY --from=build /usr/local/lib/libpistache.so  .


RUN ldconfig

# Copying template configuration files
WORKDIR /openair-amf/etc
COPY --from=build /openair-amf/etc/amf.conf .

WORKDIR /openair-amf

# expose ports
EXPOSE 80/tcp 9090/tcp 38412/sctp

ENTRYPOINT ["/bin/bash","/openair-amf/bin/entrypoint.sh"]
CMD ["/openair-amf/bin/oai_amf", "-c", "/openair-amf/etc/amf.conf", "-o"]