@extends('layouts.admin')

@section('title', 'المنتجات')

@section('content')
    <div class="page-header">
        <h1 class="page-title">المنتجات</h1>
        <a href="{{ route('admin.products.create') }}" class="btn btn-primary">إضافة منتج</a>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>الصورة</th>
                    <th>الاسم</th>
                    <th>السعر (د.ع)</th>
                    <th>الخصم</th>
                    <th>الفئة</th>
                    <th>مميز</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($products as $p)
                    <tr>
                        <td>
                            @if($p->primaryImage)
                                <img src="{{ asset('storage/'.$p->primaryImage->path) }}" alt="" style="width:50px;height:50px;object-fit:cover;border-radius:8px;">
                            @else
                                —
                            @endif
                        </td>
                        <td>{{ $p->name_ar }}</td>
                        <td>{{ number_format($p->price) }}</td>
                        <td>{{ $p->discount_percent ? $p->discount_percent.'%' : '—' }}</td>
                        <td>{{ $p->category?->name_ar ?? '—' }}</td>
                        <td>{{ $p->is_featured ? 'نعم' : 'لا' }}</td>
                        <td>
                            <a href="{{ route('admin.products.edit', $p) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.products.destroy', $p) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف المنتج؟');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        {{ $products->links() }}
    </div>
@endsection
