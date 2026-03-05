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
nano .env   # أو استخدم vim/vi
```

**عدّل القيم المهمة:**
- `APP_URL`: رابط الـ API (مثال: `http://YOUR_IP:8080` أو `https://api.rybella.com`)
- `DB_PASSWORD`: كلمة مرور قوية لقاعدة البيانات
- `DB_ROOT_PASSWORD`: كلمة مرور جذر MySQL
- `APP_PORT`: المنفذ (الافتراضي 8080 - غيّره إن كان مستخدماً بمشروع آخر)

### 3. تشغيل النشر

**على Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**يدوياً:**
```bash
# تثبيت اعتماديات PHP
docker run --rm -v $(pwd)/backend:/app -w /app composer:2 install --no-dev --optimize-autoloader

# تشغيل الحاويات
docker compose up -d --build

# بعد 15–20 ثانية: إعداد Laravel
docker compose exec app php artisan key:generate --force
docker compose exec app php artisan storage:link
docker compose exec app php artisan migrate --force
```

### 4. تحديث تطبيق Flutter للربط مع الـ API

عدّل `mobile_app/lib/core/constants/api_constants.dart` وضَع رابط الـ API:

```dart
// للإنتاج
static String get baseUrl => 'https://YOUR_DOMAIN:8080/api/v1';
// أو باستخدام عنوان IP
static String get baseUrl => 'http://YOUR_VPS_IP:8080/api/v1';
```

ثم أعد بناء التطبيق:
```bash
cd mobile_app
flutter build apk    # لأندرويد
flutter build ios    # لـ iOS
flutter build web   # للويب
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

**خطأ في الاتصال بقاعدة البيانات:**
- تأكد من صحة `DB_PASSWORD` و `DB_ROOT_PASSWORD` في `.env`
- انتظر 30 ثانية بعد التشغيل ثم أعد المحاولة

**الصور لا تظهر:**
```bash
docker compose exec app php artisan storage:link
```

**502 Bad Gateway:**
- تحقق من عمل حاوية `app`: `docker compose ps`
- راجع السجلات: `docker compose logs app`
