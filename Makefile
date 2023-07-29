.DEFAULT_GOAL := run

DUCKDB_VERSION=v0.8.1
#DUCKDB_ARCH=amd64
DUCKDB_ARCH=aarch64
PRQL_VERSION=latest
EXTENSIONS="fts httpfs icu json parquet postgres_scanner sqlite_scanner substrait"
#DOCKER_REPO_OWNER=duckerlabs
DOCKER_REPO_OWNER=donsez
IMAGE_NAME := ${DOCKER_REPO_OWNER}/ducker:$(DUCKDB_VERSION)-$(DUCKDB_ARCH)
LATEST_IMAGE_NAME := ${DOCKER_REPO_OWNER}/ducker:latest-$(DUCKDB_ARCH)

build:
	docker build \
		--build-arg DUCKDB_VERSION=$(DUCKDB_VERSION) \
		--build-arg DUCKDB_ARCH=$(DUCKDB_ARCH) \
		--build-arg PRQL_VERSION=$(PRQL_VERSION) \
		--build-arg EXTENSIONS=$(EXTENSIONS) \
		--build-arg LOAD_EXTENSIONS=$(LOAD_EXTENSIONS) \
		-t $(IMAGE_NAME) \
		-t $(LATEST_IMAGE_NAME) \
		.

run:
	docker run --rm -it $(IMAGE_NAME)

push: build
	docker push $(IMAGE_NAME)
	docker push $(LATEST_IMAGE_NAME)
