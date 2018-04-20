FROM debian:stable
# https://issues.jenkins-ci.org/browse/JENKINS-44609
# https://issues.jenkins-ci.org/browse/JENKINS-31507
#as phpcli_for_platform

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https lsb-release ca-certificates net-tools lsof postgresql-client wget \
    && apt-get autoremove -y && apt-get clean

RUN apt-get install --no-install-recommends -y vim-nox \
    && apt-get autoremove -y && apt-get clean

ARG PHPMOD=php
ARG PHPVER=7.1
RUN echo "deb http://ftp.debian.org/debian $(lsb_release -sc)-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y apache2 apache2-utils php${PHPVER} \
    && if [ "${PHPMOD}" = "php" ]; then apt-get install -y libapache2-mod-php${PHPVER}; fi \
    && if [ "${PHPMOD}" = "php-fpm" ]; then apt-get install -y php${PHPVER}-fpm; fi \
    && apt-get install --no-install-recommends -y php${PHPVER}-cli php${PHPVER}-pgsql php${PHPVER}-mysql php${PHPVER}-curl php${PHPVER}-json php${PHPVER}-gd php${PHPVER}-intl php${PHPVER}-sqlite3 php${PHPVER}-gmp php${PHPVER}-geoip php${PHPVER}-mbstring php${PHPVER}-redis php${PHPVER}-xml php${PHPVER}-zip \
    && if [ ! '7.2' = $PHPVER ]; then apt-get install --no-install-recommends -y php${PHPVER}-mcrypt; fi \
    && apt-get autoremove -y && apt-get clean

# php${PHPVER}-xdebug

RUN a2enmod headers && a2enmod userdir && a2enmod rewrite
RUN if [ "${PHPMOD}" = "php" ]; then a2dismod mpm_event && a2enmod mpm_prefork && a2enmod php${PHPVER}; fi
RUN if [ "${PHPMOD}" = "php-fpm" ]; then a2enmod proxy_fcgi setenvif; a2dismod php${PHPVER}; a2enconf php${PHPVER}-fpm; fi

RUN if [ "${PHPMOD}" = "php" ]; then echo "memory_limit=-1" >> /etc/php/${PHPVER}/apache2/conf.d/42-memory-limit.ini ; fi\
    && if [ "${PHPMOD}" = "php-fpm" ]; then echo "memory_limit=-1" >> /etc/php/${PHPVER}/fpm/conf.d/42-memory-limit.ini ; fi\
    && echo "memory_limit=-1" >> /etc/php/${PHPVER}/cli/conf.d/42-memory-limit.ini

RUN apache2ctl configtest

RUN echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php && chmod 755 /var/www/html/phpinfo.php && chown www-data:www-data /var/www/html/phpinfo.php

RUN echo /usr/sbin/service apache2 restart > /root/service_start.sh \
    && if [ "${PHPMOD}" = "php-fpm" ]; then echo "/usr/sbin/service php${PHPVER}-fpm start" >> /root/service_start.sh; fi \
    && echo "/bin/bash" >> /root/service_start.sh \
    && chmod 755 /root/service_start.sh


ENV HOME=/home/jenkins
ENV USER=jenkins
ENV GROUP=users

# Uid for system mount
ARG UID
ARG GID
RUN useradd -d $HOME -g ${GID} -u ${UID} -m ${USER} -s /bin/bash \
    && usermod -a -G www-data ${USER}

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Ah Ah debian security : install everything, hide config to user and disable everything ...
RUN if [ "${PHPMOD}" = "php" ]; then sed -i -e s/'php_admin_flag engine Off'/'php_admin_flag engine On'/g /etc/apache2/mods-enabled/php${PHPVER}.conf; fi

COPY Config/apache-config.conf /etc/apache2/mods-available/userdir.conf


EXPOSE 80
CMD /root/service_start.sh

# warning it keep running because /bin/bash does not exit
# to clean exit container "docker attach tst-cnt" and type "exit"