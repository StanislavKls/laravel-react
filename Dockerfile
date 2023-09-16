FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    nodejs npm \
    curl \
    zip \
    unzip \
    libpq-dev && \
    docker-php-ext-install pdo pdo_pgsql pgsql



RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . .

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN composer install
RUN npm install

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY --chown=www:www . /var/www

USER www

EXPOSE 9000

CMD ["php-fpm"]
