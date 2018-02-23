FROM debian:stable
# https://issues.jenkins-ci.org/browse/JENKINS-44609
# https://issues.jenkins-ci.org/browse/JENKINS-31507
#as phpcli_for_platform

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof postgresql-client wget \
    && apt-get autoremove -y && apt-get clean

RUN apt-get install --no-install-recommends -y vim-nox \
    && apt-get autoremove -y && apt-get clean


ARG PHPVER=7.1
RUN echo "deb http://ftp.debian.org/debian $(lsb_release -sc)-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y apache2 libapache2-mod-php${PHPVER} \
    && apt-get install --no-install-recommends -y php${PHPVER} php${PHPVER}-cli php${PHPVER}-pgsql php${PHPVER}-mysql php${PHPVER}-curl php${PHPVER}-json php${PHPVER}-gd php${PHPVER}-intl php${PHPVER}-sqlite3 php${PHPVER}-gmp php${PHPVER}-geoip php${PHPVER}-mbstring php${PHPVER}-redis php${PHPVER}-xml php${PHPVER}-zip php${PHPVER}-xdebug \
    && if [ ! '7.2' = $PHPVER ]; then apt-get install --no-install-recommends -y php${PHPVER}-mcrypt; fi \
    && apt-get autoremove -y && apt-get clean

RUN a2enmod headers && a2enmod userdir && a2enmod rewrite && a2dismod mpm_event && a2enmod mpm_prefork && a2enmod php${PHPVER}


RUN echo "memory_limit=-1" >> /etc/php/${PHPVER}/apache2/conf.d/42-memory-limit.ini \
    && echo "memory_limit=-1" >> /etc/php/${PHPVER}/cli/conf.d/42-memory-limit.ini

ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# Uid for system mount
ARG UID=1004
RUN useradd -d $HOME -g $GROUP -u ${UID} -m $USER \
    && usermod -a -G www-data jenkins

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Ah Ah debian security : install everything, hide config to user and disable everything ...
RUN sed -i -e s/'php_admin_flag engine Off'/'php_admin_flag engine On'/g /etc/apache2/mods-enabled/php${PHPVER}.conf

COPY apache-config.conf /etc/apache2/mods-available/userdir.conf

EXPOSE 80
CMD /usr/sbin/service apache2 restart && /bin/bash

# warning it keep running because /bin/bash does not exit
# to clean exit container "docker attach tst-cnt" and type "exit"