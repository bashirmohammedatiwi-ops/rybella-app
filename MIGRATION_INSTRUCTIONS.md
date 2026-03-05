# تعليمات تطبيق التحديثات

## خطوات تشغيل المشروع بعد التحديث

### 1. تشغيل الـ Migrations (الباك اند)

افتح الطرفية من مجلد `backend` ونفّذ:

```powershell
cd c:\xampp\htdocs\mobile\backend
C:\xampp\php\php.exe artisan migrate --force
```

هذا سينشئ:
- جدول `users` (المستخدمين)
- جدول `brands` (البراندات)
- جدول `discount_rules` (قواعد الخصم)
- إضافة عمود `brand_id` للمنتجات
- إضافة عمود `user_id` للطلبات

### 2. التأكد من Sanctum

إذا لم تكن migration الـ personal_access_tokens موجودة، نفّذ:

```powershell
C:\xampp\php\php.exe artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
C:\xampp\php\php.exe artisan migrate --force
```

### 3. تشغيل الباك اند

```powershell
C:\xampp\php\php.exe artisan serve --host=0.0.0.0
```

### 4. تشغيل التطبيق

```powershell
cd c:\xampp\htdocs\mobile\mobile_app
flutter pub get
flutter run
```

---

## الميزات الجديدة

### لوحة التحكم
- **البراندات**: إدارة البراندات من القائمة الجانبية
- **قواعد الخصم**: خصم بنسبة أو مبلغ ثابت على منتج، فئة، أو براند
- **المنتجات**: اختيار البراند عند إضافة/تعديل منتج

### التطبيق
- **تسجيل الدخول / إنشاء حساب**: من الإعدادات
- **طلباتي**: للمستخدمين المسجلين
- **فلتر البراند**: في قائمة المنتجات والرئيسية
- **الخصومات**: تُحسب تلقائياً من القواعد المضبوطة في لوحة التحكم
