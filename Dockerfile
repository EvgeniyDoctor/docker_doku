FROM alpine:3.15
MAINTAINER Evgeniy Doctor

RUN apk add --no-cache nano nginx supervisor php7 php7-cgi php7-fpm php7-curl php7-gd php7-json php7-session php7-openssl php7-xml php7-zlib

# download dokuwiki and unpack it
RUN wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-2020-07-29.tgz -O /d.tgz
RUN mkdir -p /var/www/html/dokuwiki
RUN tar xzf /d.tgz -C /var/www/html/dokuwiki/ --strip-components=1
RUN adduser -u 82 -D -S -G www-data www-data
RUN chown -R www-data:www-data /var/www/html/dokuwiki/
RUN rm -rf /d.tgz

# nginx conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./dokuwiki.conf /etc/nginx/conf.d/dokuwiki.conf

# php-fpm conf
COPY ./www.conf /etc/php7/php-fpm.d/www.conf

# php will crash without it, bcos it is starting via supervisord, so php should not be daemonized
RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php7/php-fpm.conf

# without supervisor php7-fpm won't start with the container start
COPY ./supervisord.conf /etc/supervisord.conf
CMD \
	mkdir -p /run/php/ && \
	touch /run/php/php7-fpm.sock && \
	chown -R www-data:www-data /var/lib/nginx && \
	/usr/bin/supervisord -c /etc/supervisord.conf
