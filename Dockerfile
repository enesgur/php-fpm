FROM enesgur/php-fpm:7.0

MAINTAINER Enes Gür

# Install Packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install php-dev gcc make git curl -y

# Install Phalcon
WORKDIR /tmp
RUN git clone git://github.com/phalcon/cphalcon.git && cd cphalcon/build && ./install && rm -rf /tmp/cphalcon
RUN echo "extension=phalcon.so" >/etc/php/7.0/mods-available/phalcon.ini
RUN phpenmod phalcon;

CMD ["supervisord"]
