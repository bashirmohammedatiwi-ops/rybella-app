#!/bin/bash
# إعادة تهيئة قاعدة البيانات من الصفر (يحذف كل البيانات!)
# استخدمه عند مشاكل Access denied أو عند الرغبة في بداية جديدة

set -e

echo "⚠️  تحذير: سيتم حذف جميع بيانات MySQL!"
read -p "هل أنت متأكد؟ (اكتب yes للمتابعة): " confirm
if [ "$confirm" != "yes" ]; then
    echo "ملغى."
    exit 0
fi

echo "Stopping containers..."
docker compose down

echo "Removing MySQL volume..."
VOL=$(docker volume ls -q | grep rybella_db_data || true)
if [ -n "$VOL" ]; then
    docker volume rm $VOL
else
    echo "No rybella_db volume found."
fi

echo "Starting fresh..."
docker compose up -d
echo "Waiting 45 seconds for MySQL to initialize..."
sleep 45

echo "Running migrations..."
docker compose exec app php artisan migrate --force
docker compose exec app php artisan db:seed --class=AdminSeeder

echo "✅ Done! Admin: admin@rybella.com / Admin@123"
