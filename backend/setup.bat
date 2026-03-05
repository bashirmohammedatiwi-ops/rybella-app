@echo off
chcp 65001 >nul
echo ========================================
echo    إعداد مشروع كوزماتيك - Cosmatic
echo ========================================
echo.

cd /d "%~dp0"

REM استخدام PHP من XAMPP إذا وُجد
set "PHP_EXE=php"
if exist "C:\xampp\php\php.exe" set "PHP_EXE=C:\xampp\php\php.exe"

echo [0/7] إنشاء قاعدة البيانات...
%PHP_EXE% create_db.php
if errorlevel 1 (
    echo تحذير: لم يتم إنشاء قاعدة البيانات. أنشئها يدوياً من phpMyAdmin.
)
echo.

echo [1/7] تثبيت المكتبات (Composer)...
call composer install --no-interaction
if errorlevel 1 (
    echo خطأ في composer install
    pause
    exit /b 1
)
echo.

echo [2/7] توليد مفتاح التطبيق...
call %PHP_EXE% artisan key:generate --force
if errorlevel 1 (
    echo خطأ في key:generate
    pause
    exit /b 1
)
echo.

echo [3/7] تنفيذ الـ migrations (إنشاء الجداول)...
call %PHP_EXE% artisan migrate --force
if errorlevel 1 (
    echo خطأ: تأكد من تشغيل MySQL في XAMPP وإنشاء قاعدة البيانات cosmatic
    echo يمكنك إنشاؤها من phpMyAdmin: http://localhost/phpmyadmin
    pause
    exit /b 1
)
echo.

echo [4/7] إدخال البيانات التجريبية...
call %PHP_EXE% artisan db:seed --force
if errorlevel 1 (
    echo خطأ في db:seed
    pause
    exit /b 1
)
echo.

echo [5/7] ربط مجلد التخزين...
call %PHP_EXE% artisan storage:link
echo.

echo [6/7] مسح الكاش...
call %PHP_EXE% artisan config:clear
call %PHP_EXE% artisan cache:clear
echo.

echo ========================================
echo    تم الإعداد بنجاح!
echo ========================================
echo.
echo لتشغيل السيرفر اكتب: php artisan serve
echo لوحة الإدارة: http://127.0.0.1:8000/admin/login
echo البريد: admin@cosmatic.iq
echo كلمة المرور: password
echo.
pause
