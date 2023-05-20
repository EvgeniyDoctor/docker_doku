FROM ubuntu:22.04

RUN apt-get update -y
RUN apt-get install -y wget nginx nano less supervisor
RUN apt-get install -y ca-certificates apt-transport-https software-properties-common
RUN add-apt-repository ppa:ondrej/php --yes
RUN apt-get update -y
RUN apt-get install -y php7.4 php7.4-fpm php7.4-gd php7.4-xml php7.4-json

RUN wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-2020-07-29.tgz -O /d.tgz
RUN mkdir -p /var/www/html/dokuwiki
RUN tar xzf /d.tgz -C /var/www/html/dokuwiki/ --strip-components=1
RUN chown -R www-data:www-data /var/www/html/dokuwiki/
RUN rm -rf /d.tgz

# nginx conf
COPY ./docker/dokuwiki.conf /etc/nginx/conf.d/dokuwiki.conf

# без supervisor php7.4-fpm не запускается при создании контейнера
COPY ./docker/supervisord.conf /etc/supervisord.conf
CMD \
	mkdir -p /run/php/ \
	&& touch /run/php/php7.4-fpm.sock \
	&& /usr/bin/supervisord -c /etc/supervisord.conf
