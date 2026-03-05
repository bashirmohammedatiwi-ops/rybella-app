@extends('layouts.admin')

@section('title', 'البانرات')

@section('content')
    <div class="page-header">
        <h1 class="page-title">البانرات</h1>
        <a href="{{ route('admin.banners.create') }}" class="btn btn-primary">إضافة بانر</a>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>الصورة</th>
                    <th>العنوان</th>
                    <th>الرابط</th>
                    <th>ترتيب</th>
                    <th>نشط</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($banners as $b)
                    <tr>
                        <td>
                            <img src="{{ asset('storage/'.$b->image) }}" alt="" style="width:80px;height:40px;object-fit:cover;border-radius:8px;">
                        </td>
                        <td>{{ $b->title_ar ?? '—' }}</td>
                        <td>{{ $b->link ?? '—' }}</td>
                        <td>{{ $b->sort_order }}</td>
                        <td>{{ $b->is_active ? 'نعم' : 'لا' }}</td>
                        <td>
                            <a href="{{ route('admin.banners.edit', $b) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.banners.destroy', $b) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف البانر؟');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        {{ $banners->links() }}
    </div>
@endsection
