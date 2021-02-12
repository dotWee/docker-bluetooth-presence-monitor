# sync with https://github.com/fphammerle/docker-onion-service/blob/master/Makefile

DOCKER_IMAGE_NAME := docker.io/fphammerle/andrewjfreyer-mqtt-bluetooth-presence-monitor
DOCKER_TAG_VERSION := $(shell git describe --match=v* --abbrev=0 --dirty | sed -e 's/^v//')
# https://github.com/andrewjfreyer/monitor/blob/1deec402b9b6323a964381819b199300259bb58/monitor.sh#L28
MONITOR_VERSION := 0.2.200
ARCH := $(shell arch)
DOCKER_TAG_ARCH_SUFFIX_aarch64 := arm64
DOCKER_TAG_ARCH_SUFFIX_armv6l := armv6
DOCKER_TAG_ARCH_SUFFIX_armv7l := armv7
DOCKER_TAG_ARCH_SUFFIX_x86_64 := amd64
DOCKER_TAG_ARCH_SUFFIX = ${DOCKER_TAG_ARCH_SUFFIX_${ARCH}}
DOCKER_TAG = ${DOCKER_TAG_VERSION}-monitor${MONITOR_VERSION}-${DOCKER_TAG_ARCH_SUFFIX}

.PHONY: docker-build podman-build docker-push

docker-build:
	git diff --exit-code
	git diff --staged --exit-code
	sudo docker build --tag="${DOCKER_IMAGE_NAME}:${DOCKER_TAG}" .

podman-build:
	# --format=oci (default) not fully supported by hub.docker.com
	# https://github.com/docker/hub-feedback/issues/1871#issuecomment-748924149
	podman build --format=docker --tag="${DOCKER_IMAGE_NAME}:${DOCKER_TAG}" .

docker-push: docker-build
	sudo docker push "${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
	@echo git tag --sign --message '$(shell sudo docker image inspect --format '{{join .RepoDigests "\n"}}' "${DOCKER_IMAGE_NAME}:${DOCKER_TAG}")' docker/${DOCKER_TAG} $(shell git rev-parse HEAD)
