#
# Developement tier Dockerfile for CentOS.
#

FROM centos:centos7
MAINTAINER david chengjie.ding@gmail.com

ENV DEV_VERSION=0.10 \
    DEV_USER=dantin

# add user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN set -ex \
        && mkdir -p /home/dantin \
        && groupadd -r developers && useradd -r -g developers dantin \
        && echo 'dantin:change1t' | chpasswd \
        && chown -R dantin:developers /home/dantin
VOLUME /home/dantin

#
# CentOS Package Setup
#
# Replace CentOS repository source to aliyun.
#
# EPEL rpm
#   rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#
# Development Tools:
#   yum -y groupinstall "Development Tools"
#
# third-party software dependency
#   tmux:   libevent libevent-devel ncurses-devel
#   git:    autoconf zlib-devel perl-devel openssh-devel gettext-devel expat-devel curl-devel \
#   python: openssl openssl-devel libffi-devel \
#   vim:    perl-ExtUtils-Embed \
#   ycm:    cmake python-devel
#
RUN set -ex; \
        rm -rf /etc/yum.repos.d/*.repo; \
        curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo; \
        yum clean all; \
        yum makecache fast --nogpgcheck; \
        \
        epelRepo=" \
            epel-release \
        "; \
        yum install -y $epelRepo; \
        yum clean all; \
        yum makecache fast --nogpgcheck; \
        \
        buildDeps=" \
            inetutils-ping \
            iproute \
            net-tools \
            wget \
            sudo \
            zip \
            unzip \
            zsh \
            gcc \
            gcc-c++ \
            make \
            gdb \
            openssh-server \
            libevent libevent-devel \
            ncurses-devel \
            autoconf \
            zlib-devel \
            perl-devel \
            openssh openssh-devel \
            gettext-devel \
            expat-devel \
            curl-devel \
            openssl openssl-devel \
            libffi-devel \
            perl-ExtUtils-Embed \
            cmake \
            python-devel \
            dpkg \
        "; \
    yum install -y $buildDeps; \
    yum clean all;

# Install gosu
ARG GOSU_VERSION="1.10"
RUN set -ex; \
        dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF  }')"; \
        wget -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
        wget -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
        gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu; \
        rm -r "$GNUPGHOME" /tmp/gosu.asc; \
        yum -y remove dpkg; \
        chmod +x /usr/bin/gosu; \
        rm -rf /var/cache/yum; \
        rm -rf /var/log/yum.log

# set up environment
RUN set -ex; \
        cat '/usr/bin/zsh' >> /etc/shells; \
        ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key; \
        ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key; \
        sed -i '/^root/ a\dantin ALL=(ALL) NOPASSWD:ALL' /etc/sudoers; \
        sed -i '/^dantin/s#/bin/bash#/usr/bin/zsh#' /etc/passwd;

# build customized packages
RUN mkdir /data && chown -R dantin:developers /data
VOLUME /data
WORKDIR /data

ADD code/tmux-2.8.tar.gz code
ADD code/git-2.20.1.tar.gz code
ADD code/Python-3.7.2.tgz code
ADD code/vim-8.1.0702.tar.gz code
COPY scripts/tmux.sh code/tmux.sh
COPY scripts/git.sh code/git.sh
COPY scripts/python.sh code/python.sh
COPY scripts/vim.sh code/vim.sh

RUN set -ex; \
        chmod u+x code/*.sh; \
        code/tmux.sh; \
        code/git.sh; \
        code/python.sh; \
        code/vim.sh; \
        rm -rf code;

COPY entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
