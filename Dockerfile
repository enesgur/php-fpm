FROM debian:8

MAINTAINER Enes Gür

# Install Packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install nginx php5 supervisor php5-fpm php5-xdebug php5-json php5-curl php5-redis php5-memcache php5-mysql php5-curl php5-mcrypt php-soap php5-gd php5-gmp -y

# Enable PHP Extension Settings Before Run PHP-FPM
RUN php5enmod redis json curl memcache mysql mysqli opcache pdo pdo_mysql readline xdebug

RUN echo "[supervisord]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:php5-fpm]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/etc/init.d/php5-fpm start" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stderr_logfile=/var/log/php5-fpm.err.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stdout_logfile=/var/log/php5-fpm.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:nginx]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/etc/init.d/nginx start" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stderr_logfile=/var/log/nginx.err.log" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "stdout_logfile=/var/log/nginx.log" >> /etc/supervisor/conf.d/supervisord.conf

CMD ["supervisord"]
