
SOURCE_DIR := $(shell pwd)

.PHONY: docker
docker:
	docker build --force-rm -t devbox:latest --network host .

.PHONY: up
up:
	docker-compose -f docker-compose.yml up -d --force-recreate

.PHONY: down
down:
	docker-compose -f docker-compose.yml down --remove-orphans
