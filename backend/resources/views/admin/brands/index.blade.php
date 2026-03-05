@extends('layouts.admin')

@section('title', 'البراندات')

@section('content')
    <div class="page-header">
        <h1 class="page-title">البراندات</h1>
        <a href="{{ route('admin.brands.create') }}" class="btn btn-primary">إضافة براند</a>
    </div>

    @if(session('error'))
        <div class="alert alert-danger">{{ session('error') }}</div>
    @endif

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>صورة</th>
                    <th>الاسم</th>
                    <th>الرابط</th>
                    <th>عدد المنتجات</th>
                    <th>ترتيب</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($brands as $b)
                    <tr>
                        <td>
                            @if($b->image)
                                <img src="{{ asset('storage/'.$b->image) }}" alt="" style="width:40px;height:40px;object-fit:cover;border-radius:8px;">
                            @else
                                <span style="font-size:20px;opacity:0.5;">—</span>
                            @endif
                        </td>
                        <td>{{ $b->name_ar }}</td>
                        <td>{{ $b->slug }}</td>
                        <td>{{ $b->products_count }}</td>
                        <td>{{ $b->sort_order }}</td>
                        <td>
                            <a href="{{ route('admin.brands.edit', $b) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.brands.destroy', $b) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف البراند؟');">
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
