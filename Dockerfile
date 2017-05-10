FROM ubuntu:17.04

MAINTAINER Enes Gür

# Install Packages
RUN apt-get update
RUN apt-get upgrade -y
#RUN apt-get install --no-install-recommends software-properties-common python-software-properties -y
#RUN add-apt-repository ppa:ondrej/php -y
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu zesty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu zesty main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install nginx php7.1 supervisor php7.1-fpm php7.1-xdebug php7.1-json php7.1-curl php7.1-redis php7.1-memcache php7.1-mysql php7.1-curl php7.1-mcrypt php7.1-soap php7.1-gd php7.1-gmp php7.1-intl php7.1-mbstring -y --allow-unauthenticated

# Remove Apache2 Dependency 
RUN apt-get remove apache2 -y && apt-get autoremove -y

# Enable PHP Extension Settings Before Run PHP-FPM
RUN phpenmod redis json curl memcache mysqli opcache pdo pdo_mysql readline xdebug intl mbstring

RUN echo "[supervisord]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:php7-fpm]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/etc/init.d/php7.1-fpm start" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stderr_logfile=/var/log/php-fpm.err.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stdout_logfile=/var/log/php-fpm.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:nginx]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/etc/init.d/nginx start" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stderr_logfile=/var/log/nginx.err.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stdout_logfile=/var/log/nginx.log" >> /etc/supervisor/conf.d/supervisord.conf

# Permissions
RUN chown www-data:www-data -R /var/www/html 

CMD ["supervisord"]
