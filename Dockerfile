FROM ubuntu:16.10

MAINTAINER Enes Gür

# Install Packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install nginx php supervisor php-fpm php-xdebug php-json php-curl php-redis php-memcache php-mysql php-curl php-mcrypt php-soap php-gd php-gmp php-intl php-mbstring -y

# Remove Apache2 Dependency 
RUN apt-get remove apache2 -y && apt-get autoremove -y

# Enable PHP Extension Settings Before Run PHP-FPM
RUN phpenmod redis json curl memcache mysql mysqli opcache pdo pdo_mysql readline xdebug intl mbstring

RUN echo "[supervisord]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:php7-fpm]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/etc/init.d/php7.0-fpm start" >> /etc/supervisor/conf.d/supervisord.conf
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
