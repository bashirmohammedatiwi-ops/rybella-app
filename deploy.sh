#!/bin/bash
# Rybella - سكربت النشر
set -e

cd "$(dirname "$0")"

echo "=== Rybella Deployment ==="

# 1. التحقق من .env
if [ ! -f .env ]; then
    cp .env.docker.example .env
    echo ""
    echo "⚠️  عدّل .env ثم شغّل ./deploy.sh مرة أخرى"
    echo "   nano .env"
    echo ""
    exit 1
fi

if grep -q "CHANGE_THIS_STRONG_PASSWORD\|CHANGE_ROOT_PASSWORD" .env 2>/dev/null; then
    echo "❌ غيّر DB_PASSWORD و DB_ROOT_PASSWORD في .env"
    exit 1
fi

# 2. Composer (مطلوب قبل تشغيل الحاويات)
if [ ! -d backend/vendor ]; then
    echo ">>> Installing Composer dependencies..."
    docker run --rm -v "$(pwd)/backend:/app" -w /app php:8.1-cli sh -c "\
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
        composer install --no-dev --optimize-autoloader --no-interaction"
fi

# 3. مجلدات التخزين
mkdir -p backend/storage/app/public \
         backend/storage/framework/{sessions,views,cache} \
         backend/storage/logs \
         backend/bootstrap/cache

# 4. إيقاف الحاويات القديمة وإعادة البناء
echo ">>> Building and starting containers..."
docker compose down 2>/dev/null || true
docker compose build --no-cache app 2>/dev/null || true
docker compose up -d

# 5. انتظار MySQL
echo ">>> Waiting for MySQL (up to 90s)..."
for i in $(seq 1 30); do
    if docker compose exec -T db sh -c 'mysqladmin ping -h localhost -uroot -p"$MYSQL_ROOT_PASSWORD" 2>/dev/null' 2>/dev/null; then
        echo "MySQL ready."
        break
    fi
    [ $i -eq 30 ] && { echo "❌ MySQL timeout"; exit 1; }
    sleep 3
done

# 6. إعداد Laravel
echo ">>> Setting up Laravel..."
docker compose exec -T app php artisan config:clear
docker compose exec -T app php artisan key:generate --force 2>/dev/null || true
docker compose exec -T app php artisan storage:link 2>/dev/null || true
docker compose exec -T app chmod -R 775 storage bootstrap/cache 2>/dev/null || true

# 7. Migration
for i in $(seq 1 5); do
    docker compose exec -T app php artisan migrate --force && break
    echo "Retry $i/5 in 5s..."
    sleep 5
done

docker compose exec -T app php artisan db:seed --class=AdminSeeder 2>/dev/null || true
docker compose exec -T app php artisan config:cache

# 8. النتيجة
APP_PORT=$(grep -E "^APP_PORT=" .env 2>/dev/null | cut -d= -f2 || echo "3307")
echo ""
echo "✅ Done!"
echo "   Admin: http://YOUR_IP:${APP_PORT}/admin/login"
echo "   Login: admin@rybella.com / Admin@123"
echo ""
