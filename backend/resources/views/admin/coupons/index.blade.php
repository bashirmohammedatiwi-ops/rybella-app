@extends('layouts.admin')

@section('title', 'القسائم')

@section('content')
    <div class="page-header">
        <h1 class="page-title">القسائم</h1>
        <a href="{{ route('admin.coupons.create') }}" class="btn btn-primary">إضافة قسيمة</a>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>الرمز</th>
                    <th>النوع</th>
                    <th>القيمة</th>
                    <th>الحد الأدنى للطلب</th>
                    <th>المستخدمة</th>
                    <th>نشط</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($coupons as $c)
                    <tr>
                        <td>{{ $c->code }}</td>
                        <td>{{ $c->type === 'percent' ? 'نسبة مئوية' : 'مبلغ ثابت' }}</td>
                        <td>{{ $c->type === 'percent' ? $c->value.'%' : number_format($c->value).' د.ع' }}</td>
                        <td>{{ $c->min_order_amount ? number_format($c->min_order_amount).' د.ع' : '—' }}</td>
                        <td>{{ $c->used_count }} @if($c->usage_limit)/ {{ $c->usage_limit }}@endif</td>
                        <td>{{ $c->is_active ? 'نعم' : 'لا' }}</td>
                        <td>
                            <a href="{{ route('admin.coupons.edit', $c) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.coupons.destroy', $c) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف القسيمة؟');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        {{ $coupons->links() }}
    </div>
@endsection
