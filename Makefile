
SOURCE_DIR := $(shell pwd)

.PHONY: docker
docker:
	docker build --force-rm -t devbox:latest .

.PHONY: up
up:
	docker-compose -f docker-compose.yml up -d --force-recreate

.PHONY: down
down:
	docker-compose -f docker-compose.yml down --remove-orphans

.PHONY: clean
clean:
	docker system prune --all -f
	@docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
