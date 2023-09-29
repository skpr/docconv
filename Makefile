#!/usr/bin/make -f

IMAGE=docker.io/skpr/docconv

define buildimage
  docker build --build-arg alpine_version=$(1) -t $(IMAGE):alpine$(1) .
endef

define pushimage
	docker push $(IMAGE):alpine$(1)
endef

build:
	$(call buildimage,3.17)
	$(call buildimage,3.18)

push:
	$(call pushimage,3.17)
	$(call pushimage,3.18)
