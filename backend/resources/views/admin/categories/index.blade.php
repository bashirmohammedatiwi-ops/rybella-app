@extends('layouts.admin')

@section('title', 'الفئات')

@section('content')
    <div class="page-header">
        <h1 class="page-title">الفئات</h1>
        <a href="{{ route('admin.categories.create') }}" class="btn btn-primary">إضافة فئة</a>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>صورة/أيقونة</th>
                    <th>الاسم</th>
                    <th>الرابط</th>
                    <th>الفئة الأب</th>
                    <th>ترتيب</th>
                    <th>إجراءات</th>
                </tr>
            </thead>
            <tbody>
                @foreach($categories as $c)
                    <tr>
                        <td>
                            @if($c->image)
                                <img src="{{ asset('storage/'.$c->image) }}" alt="" style="width:40px;height:40px;object-fit:cover;border-radius:8px;">
                            @elseif($c->icon)
                                <span style="font-size:20px;opacity:0.7;">📦</span>
                            @else
                                <span style="font-size:20px;opacity:0.5;">—</span>
                            @endif
                        </td>
                        <td>{{ $c->name_ar }}</td>
                        <td>{{ $c->slug }}</td>
                        <td>—</td>
                        <td>{{ $c->sort_order }}</td>
                        <td>
                            <a href="{{ route('admin.categories.edit', $c) }}" class="btn btn-secondary btn-sm">تعديل</a>
                            <form action="{{ route('admin.categories.destroy', $c) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف الفئة؟');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                            </form>
                        </td>
                    </tr>
                    @foreach($c->children as $child)
                        <tr>
                            <td>
                                @if($child->image)
                                    <img src="{{ asset('storage/'.$child->image) }}" alt="" style="width:40px;height:40px;object-fit:cover;border-radius:8px;">
                                @elseif($child->icon)
                                    <span style="font-size:20px;opacity:0.7;">📦</span>
                                @else
                                    <span style="font-size:20px;opacity:0.5;">—</span>
                                @endif
                            </td>
                            <td>— {{ $child->name_ar }}</td>
                            <td>{{ $child->slug }}</td>
                            <td>{{ $c->name_ar }}</td>
                            <td>{{ $child->sort_order }}</td>
                            <td>
                                <a href="{{ route('admin.categories.edit', $child) }}" class="btn btn-secondary btn-sm">تعديل</a>
                                <form action="{{ route('admin.categories.destroy', $child) }}" method="POST" style="display:inline;" onsubmit="return confirm('حذف الفئة؟');">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                                </form>
                            </td>
                        </tr>
                    @endforeach
                @endforeach
            </tbody>
        </table>
    </div>
@endsection
