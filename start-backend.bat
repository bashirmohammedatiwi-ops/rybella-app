@echo off
title Rybella Iraq - Backend Server
chcp 65001 >nul
echo ========================================
echo    تشغيل سيرفر الباك اند - Rybella Iraq
echo ========================================
echo.

REM استخدام PHP من XAMPP
set "PHP_EXE=php"
if exist "C:\xampp\php\php.exe" set "PHP_EXE=C:\xampp\php\php.exe"

echo إيقاف أي سيرفر سابق...
taskkill /F /IM php.exe 2>nul
timeout /t 2 /nobreak >nul

echo.
echo تشغيل Laravel...
cd /d "%~dp0backend"

"%PHP_EXE%" artisan serve --host=0.0.0.0

if errorlevel 1 (
    echo.
    echo خطأ! تأكد من:
    echo 1. تشغيل XAMPP Control Panel وتشغيل Apache و MySQL
    echo 2. وجود PHP في المسار: C:\xampp\php\php.exe
    echo.
)

pause
