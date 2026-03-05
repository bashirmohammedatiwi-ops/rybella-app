FROM php:8.1-fpm-alpine

# تثبيت الامتدادات المطلوبة لـ Laravel
RUN apk add --no-cache \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    libpng-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl \
        bcmath \
        gd \
        intl

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# نسخ الملفات
COPY . .

# تثبيت الاعتماديات (بدون dev)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# صلاحيات التخزين
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
