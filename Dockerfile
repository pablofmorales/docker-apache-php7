FROM php:7.2.0-apache

MAINTAINER Pablo Morales <pablofmorales@gmail.com>

RUN apt-get -y update
# essentials
RUN apt-get install -y build-essential
RUN apt-get install -y git zip wget g++
RUN apt-get install -y vim

RUN apt-get install -y autoconf g++ make
RUN apt-get install -y pkg-config libsasl2-dev zlib1g-dev libpng-dev  --fix-missing
RUN apt-get install -y libjpeg62-turbo-dev libpango1.0-dev libgif-dev  --fix-missing

RUN apt-get install -y libicu-dev python-pip

#RUN pecl install intl
RUN docker-php-ext-install intl mbstring gd bcmath
RUN docker-php-ext-install pdo_mysql zip

RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring bcmath
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

#COPY php.ini /usr/local/etc/php

RUN a2enmod rewrite
RUN a2enmod ssl

RUN curl -O https://getcomposer.org/composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN chmod a+x /usr/local/bin/composer

RUN mkdir /root/.composer

RUN echo "\n<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" >> /etc/apache2/apache2.conf

EXPOSE 80

ENV APP_ENV=dev
ENV TERM=xterm

RUN service apache2 restart
