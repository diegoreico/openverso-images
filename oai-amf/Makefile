.PHONY: all build release

REGISTRY ?= docker.io
IMAGE=oai-amf
TAG=v1.1.0


build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . 

release: build
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG} 
	docker push ${REGISTRY}/${IMAGE}:${TAG}