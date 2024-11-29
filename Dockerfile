FROM ubuntu:22.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ENV APP_NAME="Laravel Docker Boilerplate"
# ENV APP_ROOT_DIR="laravel-docker-boilerplate"


# Install base packages
RUN apt-get update
RUN apt-get install sudo
RUN apt-get install nano
RUN apt-get install -y curl


# Install php
ARG DEBIAN_FRONTEND=noninteractive
RUN sudo apt install software-properties-common -y
RUN sudo add-apt-repository ppa:ondrej/php
RUN apt install php8.3 -y

# Install base php extensions
RUN apt-get install -y \
        php8.3-curl \
        php8.3-dom \ 
        php8.3-intl \ 
        php8.3-mysqli \ 
        php8.3-pdo-mysql \ 
        php8.3-sqlite3 \ 
        php8.3-zip \
        php8.3-gd \
        php8.3-mbstring

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install nvm, node && npm
    # nvm environment variables
ENV NVM_DIR="/usr/local/nvm"
ENV NODE_VERSION="18.20.2"
    # install nvm
        # https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
RUN apt install npm -y

# Install apache2
RUN sudo apt update
RUN sudo apt install apache2 -y
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./config/php.ini /etc/php/8.2/cli/php.ini
RUN sudo a2enmod rewrite

# Aliases
RUN echo 'alias pa="php artisan"'  >> ~/.bashrc
RUN echo 'alias pamfs="php artisan migrate:fresh --seed"'  >> ~/.bashrc

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 5173

COPY startup.sh /
RUN chmod +x /startup.sh
CMD ["/startup.sh"]