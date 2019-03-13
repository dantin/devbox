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
#&& yum-config-manager -q --save --setopt=\*.skip_if_unavailable=1 \
#&& rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#&& yum clean all && yum makecache fast --nogpgcheck \
RUN rm -fr /etc/yum.repos.d/*.repo \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo \
    http://mirrors.aliyun.com/repo/Centos-7.repo \
    && yum clean all && yum makecache fast --nogpgcheck \
    && yum -y install epel-release \
    && yum -y install openssh-server \
    && yum -y clean all \
    && ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key

#    yum -y groupinstall "Development Tools" && \
#    yum -y install gcc gcc-c++ && \
#    yum -y install inetutils-ping iproute net-tools && \

#COPY entrypoint.sh /

VOLUME /home/dantin

EXPOSE 22
#CMD ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
