#!/bin/bash

cd /var/www/
rm -fr *
wget wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
rm -f latest.tar.gz
mv wordpress/* ./
rmdir wordpress
chown -R www-data:www-data /var/www