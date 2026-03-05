# دليل النشر على VPS - Rybella

## المتطلبات

- Docker و Docker Compose على الـ VPS
- Git (لنسخ المشروع)

---

## الخطوات

### 1. نسخ المشروع

```bash
git clone https://github.com/bashirmohammedatiwi-ops/rybella-app.git
cd rybella-app
```

### 2. إعداد ملف البيئة

```bash
cp .env.docker.example .env
nano .env
```

**عدّل القيم:**
- `APP_URL`: مثلاً `http://187.124.23.65:8080`
- `DB_PASSWORD`: كلمة مرور قوية
- `DB_ROOT_PASSWORD`: كلمة مرور جذر MySQL
- `APP_PORT`: 8080 (أو غيره إن كان مستخدماً)
- **مهم:** لا تغيّر `DB_PORT=3306` - مطلوب للاتصال الداخلي بقاعدة البيانات

### 3. تشغيل النشر

```bash
chmod +x deploy.sh
./deploy.sh
```

**أو يدوياً:**
```bash
# تثبيت الاعتماديات (إن لم تكن موجودة)
docker run --rm -v $(pwd)/backend:/app -w /app php:8.1-cli sh -c "apt-get update -qq && apt-get install -y -qq zip unzip git && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer install --no-dev --optimize-autoloader --no-interaction"

# تشغيل الحاويات
docker compose up -d --build

# انتظار 20 ثانية ثم إعداد Laravel
sleep 20
docker compose exec app php artisan key:generate --force
docker compose exec app php artisan storage:link
docker compose exec app php artisan migrate --force

# إنشاء مستخدم مدير للوحة التحكم
docker compose exec app php artisan db:seed --class=AdminSeeder
```

### 4. لوحة التحكم

- **الرابط:** `http://YOUR_VPS_IP:8080/admin/login`
- **البريد الافتراضي:** admin@rybella.com
- **كلمة المرور:** Admin@123  
  (غيّرها فوراً بعد أول تسجيل دخول)

### 5. تطبيق Flutter للإنتاج

```bash
cd mobile_app
flutter build apk --dart-define=API_BASE_URL=http://YOUR_VPS_IP:8080/api/v1
```

---

## أوامر مفيدة

```bash
# إيقاف المشروع
docker compose down

# عرض السجلات
docker compose logs -f app

# تشغيل migrations جديدة
docker compose exec app php artisan migrate

# إنشاء مستخدم مدير
docker compose exec app php artisan tinker
# ثم: \App\Models\AdminUser::create([...]);
```

---

## تشغيل أكثر من مشروع

على نفس الـ VPS، استخدم منافذ مختلفة:

| المشروع   | APP_PORT | DB_PORT |
|-----------|----------|---------|
| Rybella   | 8080     | 3307    |
| مشروع آخر | 80 أو 8081 | 3306  |

---

## استكشاف الأخطاء

**خطأ Connection refused لقاعدة البيانات:**
- تأكد أن `DB_PORT=3306` في `.env` (للاتصال الداخلي داخل Docker)
- لا تستخدم 3307 للـ app - هذا منفذ الوصول من المضيف فقط

**الصور لا تظهر:**
```bash
docker compose exec app php artisan storage:link
```

**502 Bad Gateway:**
- تحقق من عمل حاوية `app`: `docker compose ps`
- راجع السجلات: `docker compose logs app`
