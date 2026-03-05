@extends('layouts.admin')

@section('title', 'طلب ' . $order->order_number)

@section('content')
    <div class="page-header">
        <h1 class="page-title">طلب {{ $order->order_number }}</h1>
        <a href="{{ route('admin.orders.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <h3 style="margin-top:0;">تحديث الحالة</h3>
        <form method="POST" action="{{ route('admin.orders.status', $order) }}" style="display:flex;gap:0.5rem;align-items:center;">
            @csrf
            @method('PATCH')
            <select name="status" class="form-control" style="width:200px;">
                @foreach(\App\Models\Order::statusLabelsAr() as $key => $label)
                    <option value="{{ $key }}" {{ $order->status == $key ? 'selected' : '' }}>{{ $label }}</option>
                @endforeach
            </select>
            <button type="submit" class="btn btn-primary">حفظ</button>
        </form>
    </div>

    <div class="card">
        <h3 style="margin-top:0;">بيانات العميل</h3>
        <p><strong>الاسم:</strong> {{ $order->customer_name }}</p>
        <p><strong>الهاتف:</strong> {{ $order->customer_phone }}</p>
        <p><strong>العنوان:</strong> {{ $order->delivery_address }}</p>
        @if($order->city)<p><strong>المدينة:</strong> {{ $order->city }}</p>@endif
        @if($order->notes)<p><strong>ملاحظات:</strong> {{ $order->notes }}</p>@endif
    </div>

    <div class="card">
        <h3 style="margin-top:0;">تفاصيل الطلب</h3>
        <table>
            <thead>
                <tr>
                    <th>المنتج</th>
                    <th>السعر</th>
                    <th>الكمية</th>
                    <th>الإجمالي</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->items as $item)
                    <tr>
                        <td>{{ $item->product_name_ar }}</td>
                        <td>{{ number_format($item->unit_price) }} د.ع</td>
                        <td>{{ $item->quantity }}</td>
                        <td>{{ number_format($item->total) }} د.ع</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <p style="margin-top:1rem;"><strong>المجموع الفرعي:</strong> {{ number_format($order->subtotal) }} د.ع</p>
        @if($order->discount > 0)
            <p><strong>الخصم:</strong> {{ number_format($order->discount) }} د.ع @if($order->coupon_code)({{ $order->coupon_code }})@endif</p>
        @endif
        <p><strong>الإجمالي النهائي:</strong> {{ number_format($order->total) }} د.ع</p>
    </div>
@endsection
