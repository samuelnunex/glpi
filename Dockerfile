FROM php:8.1-apache

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    unzip \
    curl \
    git \
    mariadb-client \
    locales \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql gd intl xml opcache \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Define a localidade para evitar warnings
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Baixa e instala o GLPI
WORKDIR /var/www/html
RUN curl -L -o glpi.tgz https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz \
    && tar -xvzf glpi.tgz --strip-components=1 \
    && rm glpi.tgz

# Permissões
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expor a porta do Apache
EXPOSE 80

CMD ["apache2-foreground"]
