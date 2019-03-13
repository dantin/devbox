#
# Developement tier Dockerfile for CentOS.
#

FROM centos:centos7
MAINTAINER david chengjie.ding@gmail.com

# add user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r developers && useradd -r -g developers dantin \
    && echo 'dantin:change1t' | chpasswd

#
# CentOS Package Setup
#
# Replace CentOS repository source to aliyun.
#
# rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#
# Development Tools:
#   gcc, gcc-c++, etc.
#
#&& yum -y groupinstall "Development Tools"          \
#&& yum clean all \
#
RUN rm -rf /etc/yum.repos.d/*.repo                      \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo        \
    http://mirrors.aliyun.com/repo/Centos-7.repo        \
    && yum clean all && yum makecache fast --nogpgcheck \
    && yum install -y epel-release                      \
    && yum clean all && yum makecache fast --nogpgcheck \
    && yum install -y inetutils-ping iproute net-tools  \
    && yum install -y wget sudo zip unzip               \
    && yum install -y gcc gcc-c++  make gdb             \
    && yum install -y openssh-server                    \
    && ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key \
    && sed -i '/^root/ a\dantin ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

# third-party software dependency
RUN yum install -y libevent libevent-devel ncurses-devel \
    && yum install -y autoconf zlib-devel perl-devel openssh-devel gettext-devel expat-devel curl-devel \
    && yum install -y openssl openssl-devel libffi-devel

#COPY entrypoint.sh /
ADD code/tmux-2.8.tar.gz /root/code
COPY scripts/tmux.sh /root/code/tmux.sh
ADD code/git-2.20.1.tar.gz /root/code
COPY scripts/git.sh /root/code/git.sh
ADD code/Python-3.7.2.tgz /root/code
COPY scripts/python.sh /root/code/python.sh
RUN chmod u+x /root/code/tmux.sh && /root/code/tmux.sh && rm -rf /root/code/tmux-2.8 \
    && chmod u+x /root/code/git.sh && /root/code/git.sh && rm -rf /root/code/git-2.20.1 \
    && chmod u+x /root/code/python.sh && /root/code/python.sh && rm -rf /root/code/Python-3.7.2

VOLUME /home/dantin

EXPOSE 22
#CMD ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
