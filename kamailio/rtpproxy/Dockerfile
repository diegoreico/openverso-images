FROM ubuntu:20.04

# Install runtime dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
     rtpproxy

RUN mkdir -p /var/run/rtpproxy && chown rtpproxy:rtpproxy /var/run/rtpproxy
USER rtpproxy
ENV LISTEN_IP=0.0.0.0
ENV CONTROL_SOCK=udp:*
ENV LOG_LEVEL=DBUG

ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "rtpproxy -l ${LISTEN_IP} -s ${CONTROL_SOCK} -u rtpproxy:rtpproxy -p /var/run/rtpproxy/rtpproxy.pid -f -d ${LOG_LEVEL}"]
#CMD ["rtpproxy","-l", "${LISTEN_IP}","-s","${CONTROL_SOCK}","-u","rtpproxy:rtpproxy","-p","/var/run/rtpproxy/rtpproxy.pid","-f","-d","${LOG_LEVEL}"]

#CMD ["rtpproxy -s $CONTROL_SOCK -u rtpproxy:rtpproxy -p /var/run/rtpproxy/rtpproxy.pid"]
#CMD ["rtpproxy","-s", "$CONTROL_SOCK","-u","rtpproxy:rtpproxy","-p","/var/run/rtpproxy/rtpproxy.pid"]
