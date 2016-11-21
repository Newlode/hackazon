FROM php:5-apache

ADD https://github.com/rapid7/hackazon/archive/master.zip /tmp/
RUN apt update && apt install sendmail unzip -y \
    && cd /tmp/ && unzip master.zip && cp -R hackazon-master/* /var/www/html/ \
    && a2enmod rewrite \
    && cd /var/www/html/ && php composer.phar install -o --prefer-dist  && php composer.phar self-update  \
    && docker-php-source extract && docker-php-ext-install -j$(nproc) bcmath pdo_mysql \
    && rm -R /tmp/* && docker-php-source delete && apt-get autoremove -y && apt-get autoclean

RUN chown -R www-data:www-data /var/www/html/

ADD config/db.sample.php /var/www/html/assets/config/db.php
ADD config/000-default.conf /etc/apache2/sites-available/000-default.conf
