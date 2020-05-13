FROM alpine:3.11 as download
RUN apk add --no-cache git
USER nobody
# 0.2.200
ARG MONITOR_VERSION=1deec402b9b6323a964381819b199300259bb584
RUN git clone https://github.com/andrewjfreyer/monitor /tmp/monitor \
    && git -C /tmp/monitor checkout $MONITOR_VERSION
# workaround for broken multi-stage copy
# > failed to copy files: failed to copy directory: Error processing tar file(exit status 1): Container ID ... cannot be mapped to a host ID
USER 0
RUN chown -R 0:0 /tmp/monitor \
    && chmod a+rX -R -c /tmp/monitor

FROM alpine:3.11
# > ./support/init: line 60: /monitor-config/.public_name_cache: Permission denied
RUN apk add --no-cache \
        bash \
        bluez-btmon \
        bluez-deprecated `# hcidump` \
        mosquitto-clients \
        tini \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \; \
    && mkdir /monitor-config \
    && chmod a+rwxt /monitor-config
ENTRYPOINT ["/sbin/tini", "--"]
VOLUME /monitor-config
# still using rwxt on $CONFIG_DIR_PATH to support arbitrary uids
USER nobody
COPY --from=download /tmp/monitor /monitor
# > line 1986: main_pipe: No such file or directory
WORKDIR /monitor
CMD ["bash", "monitor.sh", "-D", "/monitor-config"]
