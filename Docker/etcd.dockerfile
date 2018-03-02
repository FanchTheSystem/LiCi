FROM debian:stable
# https://issues.jenkins-ci.org/browse/JENKINS-44609
# https://issues.jenkins-ci.org/browse/JENKINS-31507
#as phpcli_for_platform

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof postgresql-client wget \
    && apt-get autoremove -y && apt-get clean

RUN apt-get install --no-install-recommends -y vim-nox \
    && apt-get autoremove -y && apt-get clean

ARG ETCDVER=3.3.1
RUN wget -q https://github.com/coreos/etcd/releases/download/v${ETCDVER}/etcd-v${ETCDVER}-linux-amd64.tar.gz -O /tmp/etcd.tar.gz \
    && tar -xvzf /tmp/etcd.tar.gz -C /tmp \
    && mv /tmp/etcd-v${ETCDVER}-linux-amd64/etcd* /usr/local/bin/ \
    && chmod 755 /usr/local/bin/etcd* \
    && rm -rf /tmp/*


ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# Uid for system mount
ARG UID=1004
RUN useradd -d $HOME -g $GROUP -u ${UID} -m $USER

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#EXPOSE 80
CMD /bin/bash
