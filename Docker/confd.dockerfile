FROM debian:stable
# https://issues.jenkins-ci.org/browse/JENKINS-44609
# https://issues.jenkins-ci.org/browse/JENKINS-31507
#as phpcli_for_platform

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof wget vim-nox \
    && apt-get autoremove -y && apt-get clean

ARG CONFDVER=0.15.0
RUN wget -q https://github.com/kelseyhightower/confd/releases/download/v${CONFDVER}/confd-${CONFDVER}-linux-amd64 -O /usr/local/bin/confd \
    && chmod 755 /usr/local/bin/confd \
    && mkdir -p /etc/confd/conf.d \
    && mkdir -p /etc/confd/templates

ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# Uid for system mount
ARG UID
ARG GID
RUN useradd -d $HOME -g ${GID} -u ${UID} -m ${USER} -s /bin/bash \
    && usermod -a -G www-data ${USER}

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD /bin/bash
