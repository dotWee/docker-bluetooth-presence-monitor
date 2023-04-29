# [`dotwee/bluetooth-presence-monitor`](https://hub.docker.com/r/dotwee/bluetooth-presence-monitor)

![github status](https://img.shields.io/github/actions/workflow/status/dotwee/docker-bluetooth-presence-monitor/main.yml?branch=master&logo=GitHub)
![github activity](https://img.shields.io/github/last-commit/dotwee/docker-bluetooth-presence-monitor?logo=github)
![github open issues](https://badgen.net/github/open-issues/dotwee/docker-bluetooth-presence-monitor?icon=github)
![docker pulls](https://badgen.net/docker/pulls/dotwee/bluetooth-presence-monitor?icon=docker&label=pulls)

**Unprivileged** docker image that wraps [andrewjfreyer/monitor](https://github.com/andrewjfreyer/monitor), with support on running on arm platforms like a raspberry pi.

## pulling

### from [**docker hub**](https://hub.docker.com/r/dotwee/bluetooth-presence-monitor)

```bash
$ docker pull dotwee/bluetooth-presence-monitor:latest
```

### from [**github packages**](https://github.com/dotWee/docker-bluetooth-presence-monitor/pkgs/container/bluetooth-presence-monitor)

```bash
$ docker pull ghcr.io/dotwee/bluetooth-presence-monitor:latest
```

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
      # optionally bind your host's time config readonly
      # or use the TZ environment variable
      #- /etc/timezone:/etc/timezone:ro
      #- /etc/localtime:/etc/localtime:ro
    network_mode: host # bluetooth
    restart: always
    cap_add:
      - NET_ADMIN
    # optionally set your timezone (UTC is used by default)
    # environment:
    #   - TZ="Europe/Berlin"
```
