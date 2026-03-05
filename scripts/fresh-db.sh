#!/bin/bash
# إعادة تهيئة قاعدة البيانات من الصفر (يحذف كل البيانات!)
set -e
cd "$(dirname "$0")/.."

echo "⚠️  تحذير: سيتم حذف جميع بيانات MySQL!"
read -p "هل أنت متأكد؟ (اكتب yes للمتابعة): " confirm
if [ "$confirm" != "yes" ]; then
    echo "ملغى."
    exit 0
fi

echo "Stopping containers..."
docker compose down

echo "Removing MySQL volume..."
for v in $(docker volume ls -q | grep rybella_db_data); do docker volume rm "$v"; done 2>/dev/null || true

echo "Starting fresh..."
docker compose up -d
echo "Waiting 45 seconds for MySQL..."
sleep 45

echo "Running migrations..."
docker compose exec -T app php artisan migrate --force
docker compose exec -T app php artisan db:seed --class=AdminSeeder --force

echo "✅ Done! admin@rybella.com / Admin@123"
