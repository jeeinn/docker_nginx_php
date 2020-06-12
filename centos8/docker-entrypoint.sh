#!/bin/sh
echo 'starting php...'
/usr/local/php7/sbin/php-fpm
echo 'finished php-fpm!'
echo 'starting nginx...'
/usr/local/nginx/sbin/nginx -g "daemon off;"