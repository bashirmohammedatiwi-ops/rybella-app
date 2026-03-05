<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>تسجيل الدخول | كوزماتيك</title>
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --cosmatic-pink: #f8e8ec;
            --cosmatic-gold: #c9a962;
            --cosmatic-white: #fefefe;
            --cosmatic-text: #2d2d2d;
            --shadow-soft: 0 4px 20px rgba(201, 169, 98, 0.12);
            --radius: 12px;
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Tajawal', sans-serif;
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--cosmatic-white) 0%, var(--cosmatic-pink) 100%);
            direction: rtl;
        }
        .login-box {
            width: 100%;
            max-width: 400px;
            background: var(--cosmatic-white);
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: var(--shadow-soft);
        }
        .login-box h1 { text-align: center; color: var(--cosmatic-gold); margin-bottom: 1.5rem; font-size: 1.75rem; }
        .form-group { margin-bottom: 1.25rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; }
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e8b4bc;
            border-radius: var(--radius);
            font-family: inherit;
        }
        .btn {
            width: 100%;
            padding: 0.75rem;
            background: linear-gradient(135deg, var(--cosmatic-gold) 0%, #b89850 100%);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
        }
        .alert-danger { background: #f8d7da; color: #721c24; padding: 0.75rem; border-radius: var(--radius); margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>كوزماتيك</h1>
        <p style="text-align:center;color:#6b6b6b;margin-bottom:1.5rem;">لوحة إدارة المتجر</p>
        @if($errors->any())
            <div class="alert-danger">{{ $errors->first() }}</div>
        @endif
        <form method="POST" action="{{ route('admin.login') }}">
            @csrf
            <div class="form-group">
                <label for="email">البريد الإلكتروني</label>
                <input type="email" id="email" name="email" class="form-control" value="{{ old('email') }}" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">كلمة المرور</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn">تسجيل الدخول</button>
        </form>
    </div>
</body>
</html>
