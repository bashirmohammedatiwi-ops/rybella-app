@extends('layouts.admin')

@section('title', 'قواعد الخصم')

@section('content')
    <div class="page-header">
        <h1 class="page-title">قواعد الخصم</h1>
        <a href="{{ route('admin.discount-rules.create') }}" class="btn btn-primary">إضافة قاعدة خصم</a>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>الاسم</th>
                    <th>النطاق</th>
                    <th>نوع الخصم</th>
                    <th>القيمة</th>
                    <th>الفترة</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($rules as $r)
                    <tr>
                        <td>{{ $r->name_ar ?: '—' }}</td>
                        <td>
                            @if($r->scope_type === 'product')
                                منتج #{{ $r->scope_id }}
                            @elseif($r->scope_type === 'category')
                                فئة #{{ $r->scope_id }}
                            @else
                                براند #{{ $r->scope_id }}
                            @endif
                        </td>
                        <td>{{ $r->discount_type === 'percent' ? 'نسبة %' : 'مبلغ ثابت' }}</td>
                        <td>{{ $r->discount_type === 'percent' ? $r->value . '%' : number_format($r->value) . ' د.ع' }}</td>
                        <td>
                            @if($r->starts_at || $r->ends_at)
                                {{ $r->starts_at?->format('Y-m-d') ?? '—' }} إلى {{ $r->ends_at?->format('Y-m-d') ?? '—' }}
                            @else
                                دائماً
                            @endif
                        </td>
                        <td>
                            <a href="{{ route('admin.discount-rules.edit', $r) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.discount-rules.destroy', $r) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف قاعدة الخصم؟');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
@endsection
