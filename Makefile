
SOURCE_DIR := $(shell pwd)

TMUX_DOWNLOAD_URL := https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz
GIT_DOWNLOAD_URL  := https://github.com/git/git/archive/v2.20.1.tar.gz
VIM_DOWNLOAD_URL  := https://github.com/vim/vim/archive/v8.1.0702.tar.gz
PY3_DOWNLOAD_URL  := https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz

.DEFAULT: docker

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
	@echo "clear docker system"
	@docker system prune -f

.PHONY: code
code:
	@wget -O code/tmux-2.8.tar.gz $(TMUX_DOWNLOAD_URL)
	@wget -O code/git-2.20.1.tar.gz $(GIT_DOWNLOAD_URL)
	@wget -O code/Python-3.7.2.tgz $(PY3_DOWNLOAD_URL)
	@wget -O code/vim-8.1.0702.tar.gz $(VIM_DOWNLOAD_URL)
