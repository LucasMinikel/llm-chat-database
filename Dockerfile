FROM php:8.4-fpm AS laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY ./web .
RUN composer install --optimize-autoloader --no-dev
RUN chown -R www-data:www-data /var/www/html

FROM nginx:alpine AS nginx
COPY ./infra/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=laravel /var/www/html/public /var/www/html/public
EXPOSE 80