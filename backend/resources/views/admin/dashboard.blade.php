@extends('layouts.admin')

@section('title', 'لوحة التحكم')

@section('content')
    <div class="page-header">
        <h1 class="page-title">لوحة التحكم</h1>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>إجمالي المبيعات (د.ع)</h3>
            <div class="value">{{ number_format($totalSales) }}</div>
        </div>
        <div class="stat-card">
            <h3>طلبات اليوم</h3>
            <div class="value">{{ $ordersToday }}</div>
        </div>
        <div class="stat-card">
            <h3>إيرادات اليوم (د.ع)</h3>
            <div class="value">{{ number_format($revenueToday) }}</div>
        </div>
        <div class="stat-card">
            <h3>منتجات منخفضة المخزون</h3>
            <div class="value">{{ $lowStock }}</div>
        </div>
    </div>

    <div class="card">
        <h2 style="margin-top:0;">أفضل المنتجات مبيعاً</h2>
        <table>
            <thead>
                <tr>
                    <th>المنتج</th>
                    <th>الكمية المباعة</th>
                </tr>
            </thead>
            <tbody>
                @forelse($bestSellers as $row)
                    <tr>
                        <td>{{ $row->product_name_ar }}</td>
                        <td>{{ $row->total_qty }}</td>
                    </tr>
                @empty
                    <tr><td colspan="2">لا توجد بيانات</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="card">
        <h2 style="margin-top:0;">أحدث الطلبات</h2>
        <table>
            <thead>
                <tr>
                    <th>رقم الطلب</th>
                    <th>العميل</th>
                    <th>المبلغ</th>
                    <th>الحالة</th>
                    <th>التاريخ</th>
                </tr>
            </thead>
            <tbody>
                @forelse($recentOrders as $order)
                    <tr>
                        <td><a href="{{ route('admin.orders.show', $order) }}">{{ $order->order_number }}</a></td>
                        <td>{{ $order->customer_name }}</td>
                        <td>{{ number_format($order->total) }} د.ع</td>
                        <td>{{ \App\Models\Order::statusLabelsAr()[$order->status] ?? $order->status }}</td>
                        <td>{{ $order->created_at->format('Y-m-d H:i') }}</td>
                    </tr>
                @empty
                    <tr><td colspan="5">لا توجد طلبات</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
@endsection
