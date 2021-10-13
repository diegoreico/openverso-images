FROM debian:stable-slim as builder


ARG version=5.3.8
ENV VERSION=$version

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
	apt-get -y install tcpdump screen tmux ntp ntpdate git-core dkms \
					gcc flex bison libmariadb-dev make libssl-dev libcurl4-openssl-dev \
					libxml2-dev libpcre3-dev bash-completion g++ autoconf libmnl-dev \
					libsctp-dev libradcli-dev libradcli4 iproute2 net-tools \
					iputils-ping wget

# Fetch Kamailio code
RUN	mkdir -p /opt/kamailio && cd /tmp && git clone https://github.com/kamailio/kamailio.git && \
	cd kamailio && \
    if [ "$VERSION" = "dev" ]; then \
      git checkout master; \
      wget https://api.github.com/repos/kamailio/kamailio/git/refs/heads/master -O /kamailio-ver.json; \
    else \
      git checkout $VERSION; \
      wget https://api.github.com/repos/kamailio/kamailio/git/refs/tags/$VERSION -O /kamailio-ver.json; \
    fi 

RUN apt-get install -y pkg-config

RUN cd /tmp/kamailio && make cfg

COPY modules.lst /tmp/kamailio/src

# Build and Install Kamailio
RUN cd /tmp/kamailio && \
	make -j`nproc` Q=0 all | tee make_all.txt && \
	make install | tee make_install.txt && \
	ldconfig

RUN apt-get update
RUN apt-get install -y mariadb-client

RUN mkdir -p /var/run/kamailio && \
    adduser --quiet --system --group --disabled-password \
        --shell /bin/false --gecos "Kamailio" \
        --home /var/run/kamailio kamailio && \
    chown kamailio:kamailio /var/run/kamailio

#COPY kamailio_init.sh /
#CMD /kamailio_init.sh

# FROM debian:buster-slim

# ARG version=5.5.1
# ENV VERSION=$version

# LABEL org.opencontainers.image.authors="Carlos Giraldo <cgiraldo@gradiant.org>" \
#       org.opencontainers.image.vendor="Gradiant" \
#       org.opencontainers.image.licenses="Apache-2.0" \
#       org.opencontainers.image.version="$version"


# COPY --from=builder /usr/local/sbin/* /usr/local/sbin/
# COPY --from=builder /usr/local/share/kamailio/* /usr/local/share/kamailio/

# COPY --from=builder /usr/local/lib64/* /usr/local/lib64/

# # Install runtime dependencies
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
#      mariadb-client
# #    libyaml-0-2 \
# #    libmongoc-1.0-0 \
# #    libsctp1 \
# #    libidn11 \
# #    libcurl4 \
# #    libmicrohttpd12 \
# #    libnghttp2-14 \
# #    iproute2 iputils-ping procps net-tools iptables && \
# #    rm -rf /var/lib/apt/lists/*

# #ENV APP_ROOT=/opt/kamailio
# #COPY --from=builder /opt/kamailio/sbin ${APP_ROOT}/bin/
# #COPY --from=builder /opt/kamailio/etc $kamailio/etc/orig
# #COPY configs/ kamailio/etc/
# #COPY --from=builder /opt/kamailio/lib/ /usr/local/lib/#

# #ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
# #WORKDIR ${APP_ROOT}

# # update /usr/local/lib libraries 
# #RUN ldconfig
# #COPY entrypoint.sh /entrypoint.sh

# # TODO: run with non-root user
# #RUN groupadd -r open5gs && useradd --no-log-init -r -g open5gs open5gs
# #RUN chown -R open5gs:open5gs ${APP_ROOT}
# #USER open5gs

# #Default CONF values
# #ENV DB_URI=mongodb://mongo/open5gs

# #ENV IPV4_TUN_SUBNET="10.45.0.0/16" \
# #    IPV4_TUN_ADDR="10.45.0.1/16" \
# #    IPV6_TUN_ADDR="cafe::1/64" \
# #    ENABLE_NAT=true


# #ENTRYPOINT ["/entrypoint.sh"]
# #CMD ["/bin/bash"]

