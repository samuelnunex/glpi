FROM php:8.1-apache

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    unzip \
    curl \
    git \
    mariadb-client \
    locales \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl mysqli pdo_mysql opcache zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Configura locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Pasta de trabalho
WORKDIR /var/www/html

# Baixa e instala GLPI
RUN curl -L -o glpi.tgz https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz \
    && tar -xvzf glpi.tgz --strip-components=1 \
    && rm glpi.tgz

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
