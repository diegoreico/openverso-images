.PHONY: all build release

REGISTRY ?= docker.io
IMAGE=oai-spgwu-tiny
TAG=v1.1.2


build:
	docker build -t ${IMAGE}:${TAG} --build-arg version=${TAG} . 

release: build
	docker tag ${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:${TAG} 
	docker push ${REGISTRY}/${IMAGE}:${TAG}