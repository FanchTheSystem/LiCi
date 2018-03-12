FROM debian:stable
# https://issues.jenkins-ci.org/browse/JENKINS-44609
# https://issues.jenkins-ci.org/browse/JENKINS-31507
#as phpcli_for_platform

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof wget \
    && apt-get install --no-install-recommends -y default-jre xvfb dnsutils vim-nox\
    && apt-get autoremove -y && apt-get clean

RUN echo "deb http://http.debian.net/debian unstable main" > /etc/apt/sources.list.d/firefox.list && apt-get update && apt-get install --no-install-recommends -y firefox\
    && apt-get autoremove -y && apt-get clean

ARG GECKOVERSION=v0.19.1

RUN wget -q https://github.com/mozilla/geckodriver/releases/download/${GECKOVERSION}/geckodriver-${GECKOVERSION}-linux64.tar.gz \
    && gunzip -f geckodriver-${GECKOVERSION}-linux64.tar.gz \
    && tar -xvf geckodriver-${GECKOVERSION}-linux64.tar \
    && mv geckodriver /usr/local/bin/\
    && rm -rf gecko* \
    && geckodriver --version


ARG SELENIUMVERSION=3.7

RUN wget -q https://selenium-release.storage.googleapis.com/${SELENIUMVERSION}/selenium-server-standalone-${SELENIUMVERSION}.0.jar --output-document=/usr/local/bin/selenium-server-standalone.jar


ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# Uid for system mount
ARG UID=1004
RUN useradd -d $HOME -g $GROUP -u ${UID} -m $USER

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DISPLAY=:99

CMD /sbin/start-stop-daemon --start --pidfile /tmp/xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1680x1050x16 && java -jar /usr/local/bin/selenium-server-standalone.jar -debug -enablePassThrough false
