#!/bin/bash
# Rybella - نشر في حاوية Docker جديدة
set -e

cd "$(dirname "$0")"

echo "=== Rybella Deployment ==="

# 1. التحقق من .env
if [ ! -f .env ]; then
    cp .env.docker.example .env
    echo ""
    echo "⚠️  عدّل .env (APP_URL, DB_PASSWORD, DB_ROOT_PASSWORD) ثم شغّل: ./deploy.sh"
    exit 1
fi

if grep -qE "CHANGE_THIS_STRONG_PASSWORD|CHANGE_ROOT_PASSWORD|YOUR_VPS_IP" .env 2>/dev/null; then
    echo "❌ عدّل في .env: APP_URL, DB_PASSWORD, DB_ROOT_PASSWORD"
    exit 1
fi

# 2. Composer (مع zip و git)
if [ ! -d backend/vendor ]; then
    echo ">>> Installing Composer dependencies..."
    docker run --rm -v "$(pwd)/backend:/app" -w /app php:8.1-cli sh -c "\
        apt-get update -qq && apt-get install -y -qq zip unzip git && \
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
        composer install --no-dev --optimize-autoloader --no-interaction"
fi

# 3. مجلدات التخزين
mkdir -p backend/storage/app/public \
         backend/storage/framework/sessions \
         backend/storage/framework/views \
         backend/storage/framework/cache/data \
         backend/storage/logs \
         backend/bootstrap/cache

chmod -R 777 backend/storage backend/bootstrap/cache 2>/dev/null || true

# 4. إيقاف وإعادة البناء
echo ">>> Building containers..."
docker compose down 2>/dev/null || true
docker compose build --no-cache app
docker compose up -d

# 5. انتظار MySQL
echo ">>> Waiting for MySQL (90s max)..."
for i in $(seq 1 30); do
    if docker compose exec -T db sh -c 'mysqladmin ping -h localhost -uroot -p"$MYSQL_ROOT_PASSWORD" 2>/dev/null' 2>/dev/null; then
        echo "MySQL ready."
        break
    fi
    [ $i -eq 30 ] && { echo "❌ MySQL timeout. Check: docker compose logs db"; exit 1; }
    sleep 3
done

# 6. إعداد Laravel
echo ">>> Setting up Laravel..."
docker compose exec -T app php artisan config:clear 2>/dev/null || true
docker compose exec -T app php artisan key:generate --force 2>/dev/null || true
docker compose exec -T app php artisan storage:link 2>/dev/null || true
docker compose exec -T app chmod -R 777 storage bootstrap/cache 2>/dev/null || true

# 7. Migration
for i in $(seq 1 5); do
    docker compose exec -T app php artisan migrate --force && break
    echo "Retry $i/5..."
    sleep 5
done

docker compose exec -T app php artisan db:seed --class=AdminSeeder --force 2>/dev/null || true
docker compose exec -T app php artisan config:cache 2>/dev/null || true

# 8. النتيجة
APP_PORT=$(grep -E "^APP_PORT=" .env 2>/dev/null | cut -d= -f2 || echo "8080")
echo ""
echo "✅ Deployment complete!"
echo "   Admin: http://YOUR_IP:${APP_PORT}/admin/login"
echo "   Login: admin@rybella.com / Admin@123"
echo ""
