# docker-bluetooth-presence-monitor

[![build and publish docker image](https://github.com/dotWee/docker-bluetooth-presence-monitor/actions/workflows/main.yml/badge.svg)](https://github.com/dotWee/docker-bluetooth-presence-monitor/actions/workflows/main.yml)

**unprivileged** docker image that wraps [andrewjfreyer/monitor](https://github.com/andrewjfreyer/monitor), with support on running on arm platforms like a raspberry pi.

## tags

- `linux/arm/v6`
- `linux/arm/v7`
- `linux/arm64`
- `linux/amd64`

## running

```bash
$ docker run \
    --name bluetooth-presence-monitor \
    -v "${PWD}":/config \
    --net=host \
    --restart always \
    --cap-add NET_ADMIN \
    dotwee/bluetooth-presence-monitor:latest
```

using [docker-compose](./docker-compose.yml):

```yaml
version: '2.2'

services:
  bluetooth-presence-monitor:
    image: dotwee/bluetooth-presence-monitor:latest
    container_name: bluetooth-presence-monitor
    volumes:
      - ./config:/config:rw
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    network_mode: host # bluetooth
    restart: always
    cap_add:
      - NET_ADMIN
```

