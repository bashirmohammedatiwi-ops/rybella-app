===============================================
   تشغيل سيرفر الباك اند - Rybella Iraq
===============================================

الطريقة 1: تشغيل الملف (مُفضّل)
---------------------------------
انقر مرتين على: start-backend.bat

يجب أن تظهر نافذة سوداء ويبقى السيرفر يعمل.
لا تغلق النافذة - إغلاقها يوقف السيرفر.


الطريقة 2: من الطرفية
---------------------------------
● إذا كانت PowerShell:
   cd c:\xampp\htdocs\mobile\backend
   C:\xampp\php\php.exe artisan serve --host=0.0.0.0

● إذا كانت CMD:
   cd /d c:\xampp\htdocs\mobile\backend
   C:\xampp\php\php.exe artisan serve --host=0.0.0.0

3. للإيقاف: اضغط Ctrl + C


التأكد قبل التشغيل:
-------------------
✓ XAMPP Control Panel مفتوح
✓ Apache و MySQL يعملان (أخضر)
✓ قاعدة البيانات cosmatic موجودة (من phpMyAdmin)


العنوان بعد التشغيل:
-------------------
http://127.0.0.1:8000
http://localhost:8000
لوحة الإدارة: http://127.0.0.1:8000/admin/login


إذا ظهر خطأ:
------------
- "php غير معروف": تأكد أن XAMPP مثبت في C:\xampp
- "Connection refused" في MySQL: شغّل MySQL من XAMPP
- البورت 8000 مستخدم: أغلق البرامج التي تستخدمه أو غيّر البورت:
  php artisan serve --host=0.0.0.0 --port=8001
