FROM php:8.0-apache

# Instalar dependências
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libpq-dev \
    libxslt-dev \
    git \
    unzip \
    && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    pgsql \
    zip \
    gd \
    intl \
    soap \
    xsl \
    opcache \
    exif

# Configurar o Apache
RUN a2enmod rewrite
RUN a2enmod ssl

# Copiar o código fonte do Moodle (assumindo que está no diretório atual)
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

# Configurar o PHP
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Aumentar max_input_vars
RUN { \
    echo 'max_input_vars = 5000'; \
} > /usr/local/etc/php/conf.d/max-input-vars.ini

# Criar diretório moodledata
RUN mkdir -p /var/www/moodledata
RUN chown -R www-data:www-data /var/www/moodledata
RUN chmod 777 /var/www/moodledata

WORKDIR /var/www/html