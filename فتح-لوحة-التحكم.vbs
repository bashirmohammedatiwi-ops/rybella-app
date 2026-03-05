' يفتح لوحة التحكم في المتصفح (يُفترض أن السيرفر يعمل بالفعل)
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "http://127.0.0.1:8000/admin/login", 1, False
