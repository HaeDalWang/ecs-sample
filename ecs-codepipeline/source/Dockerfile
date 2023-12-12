FROM ubuntu:16.04

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y \
	php7.0 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-dev \
	php7.0-fpm \
	php7.0-json \
    apache2 \
    libapache2-mod-php7.0

COPY index.html index.php /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apachectl","-D","FOREGROUND"]