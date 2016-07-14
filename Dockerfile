FROM php:7.0.4-apache

MAINTAINER Pablo Morales <pablofmorales@gmail.com>

RUN apt-get -y update
# essentials
RUN apt-get install -y git zip wget g++
# nice-to-haves
RUN apt-get install -y vim silversearcher-ag


RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring bcmath

# for mongodb pecl package
# (http://stackoverflow.com/questions/34086590/error-installing-php-mongo-driver-after-php5-upgrade):
RUN apt-get install -y libsndfile1 --no-install-recommends
RUN apt-get install -y ant --fix-missing
RUN apt-get install -y autoconf g++ make
RUN apt-get install -y openssl libssl-dev libcurl4-openssl-dev
RUN apt-get install -y pkg-config libsasl2-dev

RUN apt-get install -y libicu-dev
RUN pecl install intl
RUN docker-php-ext-install intl

RUN pecl install mongodb

COPY php.ini /usr/local/etc/php

RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear

ENV XDEBUGINI_PATH
RUN echo "zend_extension="`find /usr/local/lib/php/extensions/ -iname 'xdebug.so'` > $XDEBUGINI_PATH
RUN cat xdebug.ini >> $XDEBUGINI_PATH
RUN echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> $XDEBUGINI_PATH

RUN a2enmod rewrite
#RUN apache2-foreground
RUN curl -O https://getcomposer.org/composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN chmod a+x /usr/local/bin/composer

RUN wget https://phar.phpunit.de/phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit
RUN chmod a+x /usr/local/bin/phpunit

RUN curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept
RUN chmod a+x /usr/local/bin/codecept

#ADD . /var/www
#RUN composer install
# Update the default apache site with the config we created.
#RUN mkdir /www && mkdir /www/public
RUN echo "\n<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" >> /etc/apache2/apache2.conf

EXPOSE 80

ENV APP_ENV=dev
ENV TERM=xterm

RUN service apache2 restart
