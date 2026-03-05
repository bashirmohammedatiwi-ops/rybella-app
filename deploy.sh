#!/bin/bash
# Rybella Deployment Script
set -e

echo "=== Rybella Deployment ==="

# التحقق من وجود .env
if [ ! -f .env ]; then
    echo "Creating .env from template..."
    cp .env.docker.example .env
    echo ""
    echo "⚠️  عدّل ملف .env وأدخل كلمات المرور الصحيحة قبل المتابعة!"
    echo "   nano .env"
    echo ""
    exit 1
fi

# التحقق من تعديل كلمات المرور (لا تستخدم القيم الافتراضية)
if grep -q "CHANGE_THIS_STRONG_PASSWORD" .env 2>/dev/null || grep -q "CHANGE_ROOT_PASSWORD" .env 2>/dev/null; then
    echo "❌ عدّل كلمات المرور في .env قبل النشر:"
    echo "   DB_PASSWORD=كلمة_مرور_قوية"
    echo "   DB_ROOT_PASSWORD=كلمة_مرور_جذر_قوية"
    echo ""
    exit 1
fi

# تثبيت Composer إن لزم
if [ ! -d backend/vendor ]; then
    echo "Installing Composer dependencies..."
    docker run --rm -v "$(pwd)/backend:/app" -w /app php:8.1-cli sh -c "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer install --no-dev --optimize-autoloader --no-interaction"
fi

echo "Starting Docker containers..."
docker compose up -d --build

echo "Waiting for MySQL (up to 90 seconds)..."
for i in $(seq 1 30); do
    if docker compose exec -T db sh -c 'mysqladmin ping -h localhost -uroot -p"$MYSQL_ROOT_PASSWORD" 2>/dev/null'; then
        echo "MySQL is ready."
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ MySQL did not start in time. Check: docker compose logs db"
        exit 1
    fi
    sleep 3
done

echo "Setting up Laravel..."
docker compose exec -T app php artisan config:clear
docker compose exec -T app php artisan key:generate --force 2>/dev/null || true
# إنشاء رابط التخزين في مجلد backend على المضيف (للـ nginx لخدمة الصور)
docker run --rm -v "$(pwd)/backend:/var/www/html" -v "$(pwd)/.env:/var/www/html/.env:ro" -w /var/www/html php:8.1-cli php artisan storage:link 2>/dev/null || true

# صلاحيات التخزين
docker compose exec -T app chmod -R 775 storage bootstrap/cache 2>/dev/null || true

# Migration مع إعادة المحاولة
for i in $(seq 1 5); do
    if docker compose exec -T app php artisan migrate --force; then
        break
    fi
    echo "Migration attempt $i failed, retrying in 5s..."
    sleep 5
done

docker compose exec -T app php artisan db:seed --class=AdminSeeder 2>/dev/null || true
docker compose exec -T app php artisan config:cache

# قراءة المنفذ من .env
APP_PORT=$(grep -E "^APP_PORT=" .env 2>/dev/null | cut -d= -f2 || echo "3307")

echo ""
echo "✅ Deployment complete!"
echo "   Admin: http://YOUR_VPS_IP:${APP_PORT}/admin/login"
echo "   Login: admin@rybella.com / Admin@123"
echo ""
