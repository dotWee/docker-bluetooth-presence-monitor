FROM alpine:3.11
RUN apk add --no-cache git
LABEL org.opencontainers.image.source=https://github.com/dotWee/docker-bluetooth-presence-monitor
RUN git clone https://github.com/andrewjfreyer/monitor /monitor

WORKDIR /monitor

RUN chmod a+rX -R -c .
RUN apk add --no-cache \
    bash \
    bluez \
    bluez-btmon \
    bluez-deprecated \
    mosquitto-clients \
    bc \
    coreutils \
    curl \
    gawk \
    tini

RUN find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \; \
    && mkdir /config \
    && chmod a+rwxt /config `# .public_name_cache`

ENTRYPOINT ["/sbin/tini", "--"]
VOLUME /config
RUN chmod a+rwxt /monitor `# mkfifo main_pipe|log_pipe|packet_pipe`
CMD ["bash", "monitor.sh", "-D", "/config", "-V"]
