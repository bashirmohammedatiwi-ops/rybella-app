<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'لوحة التحكم') | كوزماتيك</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --cosmatic-pink: #f8e8ec;
            --cosmatic-pink-deep: #e8b4bc;
            --cosmatic-gold: #c9a962;
            --cosmatic-gold-light: #e8dcc8;
            --cosmatic-white: #fefefe;
            --cosmatic-text: #2d2d2d;
            --cosmatic-text-muted: #6b6b6b;
            --shadow-soft: 0 4px 20px rgba(201, 169, 98, 0.12);
            --radius: 12px;
            --space: 8px;
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Tajawal', sans-serif;
            background: linear-gradient(135deg, var(--cosmatic-white) 0%, var(--cosmatic-pink) 100%);
            color: var(--cosmatic-text);
            min-height: 100vh;
            margin: 0;
            direction: rtl;
        }
        .admin-wrap {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, rgba(255,255,255,0.95) 0%, rgba(248,232,236,0.98) 100%);
            border-left: 1px solid var(--cosmatic-pink-deep);
            padding: calc(var(--space) * 3);
            box-shadow: var(--shadow-soft);
        }
        .sidebar .brand {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--cosmatic-gold);
            margin-bottom: calc(var(--space) * 4);
            padding-bottom: calc(var(--space) * 2);
            border-bottom: 2px solid var(--cosmatic-gold-light);
        }
        .sidebar nav a {
            display: block;
            padding: calc(var(--space) * 2) calc(var(--space) * 3);
            color: var(--cosmatic-text);
            text-decoration: none;
            border-radius: var(--radius);
            margin-bottom: var(--space);
            transition: all 0.2s;
        }
        .sidebar nav a:hover, .sidebar nav a.active {
            background: var(--cosmatic-pink);
            color: var(--cosmatic-gold);
        }
        .main {
            flex: 1;
            padding: calc(var(--space) * 4);
            overflow: auto;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: calc(var(--space) * 4);
        }
        .page-title { font-size: 1.75rem; font-weight: 700; color: var(--cosmatic-text); margin: 0; }
        .card {
            background: var(--cosmatic-white);
            border-radius: var(--radius);
            box-shadow: var(--shadow-soft);
            padding: calc(var(--space) * 4);
            margin-bottom: calc(var(--space) * 3);
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: var(--space);
            padding: calc(var(--space) * 2) calc(var(--space) * 4);
            border-radius: var(--radius);
            font-family: inherit;
            font-weight: 500;
            cursor: pointer;
            border: none;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--cosmatic-gold) 0%, #b89850 100%);
            color: white;
        }
        .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-secondary { background: var(--cosmatic-pink); color: var(--cosmatic-text); }
        .btn-danger { background: #dc3545; color: white; }
        .btn-sm { padding: var(--space) calc(var(--space) * 2); font-size: 0.875rem; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: calc(var(--space) * 2); text-align: right; border-bottom: 1px solid var(--cosmatic-pink); }
        th { font-weight: 700; color: var(--cosmatic-gold); }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: calc(var(--space) * 3);
            margin-bottom: calc(var(--space) * 4);
        }
        .stat-card {
            background: var(--cosmatic-white);
            border-radius: var(--radius);
            padding: calc(var(--space) * 4);
            box-shadow: var(--shadow-soft);
            border-right: 4px solid var(--cosmatic-gold);
        }
        .stat-card h3 { margin: 0; font-size: 0.9rem; color: var(--cosmatic-text-muted); }
        .stat-card .value { font-size: 1.75rem; font-weight: 800; color: var(--cosmatic-gold); }
        .alert { padding: calc(var(--space) * 2) calc(var(--space) * 4); border-radius: var(--radius); margin-bottom: calc(var(--space) * 3); }
        .alert-success { background: #d4edda; color: #155724; }
        .alert-danger { background: #f8d7da; color: #721c24; }
        .form-group { margin-bottom: calc(var(--space) * 3); }
        .form-group label { display: block; margin-bottom: var(--space); font-weight: 500; }
        .form-control {
            width: 100%;
            padding: calc(var(--space) * 2);
            border: 1px solid var(--cosmatic-pink-deep);
            border-radius: var(--radius);
            font-family: inherit;
        }
        .form-control:focus { outline: none; border-color: var(--cosmatic-gold); box-shadow: 0 0 0 2px rgba(201,169,98,0.2); }
        .logout-form { margin-top: auto; padding-top: calc(var(--space) * 4); }
        .logout-form .btn { width: 100%; justify-content: center; background: var(--cosmatic-pink-deep); color: #fff; }
    </style>
    @stack('styles')
</head>
<body>
    <div class="admin-wrap">
        <aside class="sidebar">
            <div class="brand">كوزماتيك</div>
            <nav>
                <a href="{{ route('admin.dashboard') }}" class="{{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">لوحة التحكم</a>
                <a href="{{ route('admin.products.index') }}" class="{{ request()->routeIs('admin.products.*') ? 'active' : '' }}">المنتجات</a>
                <a href="{{ route('admin.categories.index') }}" class="{{ request()->routeIs('admin.categories.*') ? 'active' : '' }}">الفئات</a>
                <a href="{{ route('admin.brands.index') }}" class="{{ request()->routeIs('admin.brands.*') ? 'active' : '' }}">البراندات</a>
                <a href="{{ route('admin.discount-rules.index') }}" class="{{ request()->routeIs('admin.discount-rules.*') ? 'active' : '' }}">قواعد الخصم</a>
                <a href="{{ route('admin.orders.index') }}" class="{{ request()->routeIs('admin.orders.*') ? 'active' : '' }}">الطلبات</a>
                <a href="{{ route('admin.coupons.index') }}" class="{{ request()->routeIs('admin.coupons.*') ? 'active' : '' }}">القسائم</a>
                <a href="{{ route('admin.banners.index') }}" class="{{ request()->routeIs('admin.banners.*') ? 'active' : '' }}">البانرات</a>
            </nav>
            <form action="{{ route('admin.logout') }}" method="POST" class="logout-form">
                @csrf
                <button type="submit" class="btn btn-secondary">تسجيل الخروج</button>
            </form>
        </aside>
        <main class="main">
            @if(session('success'))
                <div class="alert alert-success">{{ session('success') }}</div>
            @endif
            @if($errors->any())
                <div class="alert alert-danger">
                    <ul style="margin:0;padding-right:1.5rem;">
                        @foreach($errors->all() as $e) <li>{{ $e }}</li> @endforeach
                    </ul>
                </div>
            @endif
            @yield('content')
        </main>
    </div>
    @stack('scripts')
</body>
</html>
