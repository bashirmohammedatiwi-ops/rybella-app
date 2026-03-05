@extends('layouts.admin')

@section('title', 'الطلبات')

@section('content')
    <div class="page-header">
        <h1 class="page-title">الطلبات</h1>
    </div>

    <div class="card">
        <form method="GET" action="{{ route('admin.orders.index') }}" style="margin-bottom:1.5rem;display:flex;gap:0.5rem;flex-wrap:wrap;">
            <select name="status" class="form-control" style="width:auto;">
                <option value="">كل الحالات</option>
                @foreach(\App\Models\Order::statusLabelsAr() as $key => $label)
                    <option value="{{ $key }}" {{ request('status') == $key ? 'selected' : '' }}>{{ $label }}</option>
                @endforeach
            </select>
            <input type="text" name="phone" class="form-control" placeholder="رقم الهاتف" value="{{ request('phone') }}" style="width:180px;">
            <button type="submit" class="btn btn-primary">بحث</button>
        </form>
        <table>
            <thead>
                <tr>
                    <th>رقم الطلب</th>
                    <th>العميل</th>
                    <th>الهاتف</th>
                    <th>المبلغ</th>
                    <th>الحالة</th>
                    <th>التاريخ</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($orders as $order)
                    <tr>
                        <td>{{ $order->order_number }}</td>
                        <td>{{ $order->customer_name }}</td>
                        <td>{{ $order->customer_phone }}</td>
                        <td>{{ number_format($order->total) }} د.ع</td>
                        <td>{{ \App\Models\Order::statusLabelsAr()[$order->status] ?? $order->status }}</td>
                        <td>{{ $order->created_at->format('Y-m-d H:i') }}</td>
                        <td><a href="{{ route('admin.orders.show', $order) }}" class="btn btn-secondary btn-sm">عرض</a></td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        {{ $orders->links() }}
    </div>
@endsection
