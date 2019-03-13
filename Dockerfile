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
RUN rm -fr /etc/yum.repos.d/*.repo                      \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo        \
    http://mirrors.aliyun.com/repo/Centos-7.repo        \
    && yum clean all && yum makecache fast --nogpgcheck \
    && yum -y install epel-release                      \
    && yum clean all && yum makecache fast --nogpgcheck \
    && yum -y install inetutils-ping iproute net-tools  \
    && yum -y install wget sudo zip unzip               \
    && yum install -y gcc gcc-c++  make gdb             \
    && yum -y install openssh-server                    \
    && ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key \
    && sed -i '/^root/ a\dantin ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

# tmux dependency
RUN yum -y install libevent libevent-devel ncurses-devel 


#COPY entrypoint.sh /
ADD code/tmux-2.8.tar.gz /root/code
COPY scripts/tmux.sh /root/code/tmux.sh
RUN chmod u+x /root/code/tmux.sh && /root/code/tmux.sh

VOLUME /home/dantin

EXPOSE 22
#CMD ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
