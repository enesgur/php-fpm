FROM debian:stretch

MAINTAINER Enes Gür

# Install Packages
RUN apt-get update -y
RUN apt-get install vim wget curl supervisor -y
RUN wget -O - https://packages.sury.org/php/README.txt | bash
RUN apt-get install nginx php7.0 php7.0-fpm php7.0-curl php7.0-json php7.0-xml php7.0-gd php7.0-soap php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-mysql php-redis php7.0-xml php7.0-zip php-yaml php-xdebug php-memcache -y

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
