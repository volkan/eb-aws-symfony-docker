#!/bin/bash


ln -f -s /usr/share/zoneinfo/Turkey /etc/localtime

cd /var/www/html

rm -rf var/cache/*
rm -rf var/logs/*

usermod -u 1000 www-data

mkdir -p var/cache var/logs

chmod 777 var/cache
chmod 777 var/logs

php composer.phar install --optimize-autoloader

php bin/console cache:warmup --env=prod --no-debug

chown -R www-data:www-data var/cache
chown -R www-data:www-data var/logs

echo newrelic.appname="$HOSTNAME" >> /usr/local/etc/php/conf.d/newrelic.ini
echo newrelic.license="license" >> /usr/local/etc/php/conf.d/newrelic.ini

php-fpm