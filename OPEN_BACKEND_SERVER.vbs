Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\xampp\htdocs\mobile"

' تشغيل السيرفر
WshShell.Run "cmd /k cd /d C:\xampp\htdocs\mobile\backend && C:\xampp\php\php.exe artisan serve --host=0.0.0.0", 1, False

' انتظار ثانيتين ثم فتح لوحة التحكم في المتصفح
WScript.Sleep 3000
WshShell.Run "http://127.0.0.1:8000/admin/login", 1, False
