FROM php:7.4-fpm
LABEL maintainer="Martin"

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Installing dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    libpng-dev \
    locales \
    zip \
    unzip \
    nano \
    libcurl4-openssl-dev  \
    libssl-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    gd \
    bcmath \
    mbstring \
    zip \
    exif \
    pcntl \
    posix \
    opcache
RUN pecl install mcrypt-1.0.4

RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-enable exif

# Setup Redis
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Setting locales
#RUN echo fr_FR.UTF-8 UTF-8 > /etc/locale.gen && locale-gen

# Setting timezone
# RUN echo "Asia/Kuala_Lumpur" > /etc/timezone

# Setup supervisor
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    supervisor \
  && rm -rf /var/lib/apt/lists/*
COPY ./.docker/supervisor/ /etc/supervisor/conf.d/

RUN mkdir -p /var/run/supervisor/
RUN mkdir -p /var/log/supervisor/

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# User Permission
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN chown -R $user:$user /var/www/
RUN chown -R $user:$user /var/log/supervisor/
RUN chown -R $user:$user /var/run/

# Set working directory
WORKDIR /application

USER $user

CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
