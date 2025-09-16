# Usa imagem oficial PHP com Apache
FROM php:8.2-apache

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libxml2-dev unzip curl git mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install mysqli pdo pdo_mysql gd intl xml opcache \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /var/www/html

# Baixa versão mais recente do GLPI (10.0.15 no exemplo)
RUN curl -L -o glpi.tgz https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz \
    && tar -xvzf glpi.tgz --strip-components=1 \
    && rm glpi.tgz

# Ajusta permissões para o Apache rodar
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expõe a porta padrão do Apache
EXPOSE 80

# Inicia o Apache no container
CMD ["apache2-foreground"]
