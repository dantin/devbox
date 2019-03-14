
SOURCE_DIR := $(shell pwd)

.PHONY: docker
docker:
	@docker build --force-rm -t devbox:latest .

.PHONY: up
up:
	@docker-compose -f docker-compose.yml up -d --force-recreate

.PHONY: down
down:
	@docker-compose -f docker-compose.yml down --remove-orphans

.PHONY: save
save:
	@docker save -o devbox.tar devbox:latest

.PHONY: load
load:
	@docker load -i devbox.tar

.PHONY: clean
clean:
	@echo "clean docker system"
	@docker system prune -f
