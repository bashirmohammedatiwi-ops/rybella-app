# دليل النشر - Rybella

## المتطلبات

- Docker و Docker Compose
- Git

---

## الخطوات

### 1. نسخ المشروع

```bash
git clone https://github.com/bashirmohammedatiwi-ops/rybella-app.git
cd rybella-app
```

### 2. إعداد .env

```bash
cp .env.docker.example .env
nano .env
```

**عدّل:**
- `APP_URL`: `http://عنوان_السيرفر:8080` (مثلاً `http://187.124.23.65:8080`)
- `DB_PASSWORD`: كلمة مرور قوية
- `DB_ROOT_PASSWORD`: كلمة مرور جذر قوية

### 3. النشر

```bash
chmod +x deploy.sh
./deploy.sh
```

### 4. لوحة التحكم

- **الرابط:** `http://YOUR_IP:8080/admin/login`
- **البريد:** admin@rybella.com
- **كلمة المرور:** Admin@123

### 5. بناء Flutter

```bash
cd mobile_app
flutter build apk --dart-define=API_BASE_URL=http://YOUR_IP:8080/api/v1
```

---

## المنافذ

| الخدمة | المنفذ |
|--------|--------|
| لوحة التحكم + API | 8080 |
| MySQL (من المضيف) | 3307 |

---

## تحديث المشروع

```bash
git pull
docker compose up -d --build
docker compose exec app php artisan migrate --force
docker compose exec app php artisan config:cache
```

---

## إعادة تهيئة قاعدة البيانات

```bash
chmod +x scripts/fresh-db.sh
./scripts/fresh-db.sh
```

---

## استكشاف الأخطاء

**خطأ Access denied:**
- غيّر `DB_PASSWORD` و `DB_ROOT_PASSWORD` في `.env`
- أو استخدم `./scripts/fresh-db.sh`

**خطأ 500 / لا يظهر شيء:**
- `docker compose exec app tail -50 storage/logs/laravel.log`
- تأكد `APP_URL` يطابق رابط الدخول
- تأكد `SESSION_SECURE_COOKIE=false`

**vendor غير موجود:**
```bash
docker run --rm -v "$(pwd)/backend:/app" -w /app php:8.1-cli sh -c "apt-get update -qq && apt-get install -y -qq zip unzip git && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer install --no-dev --optimize-autoloader --no-interaction"
```
