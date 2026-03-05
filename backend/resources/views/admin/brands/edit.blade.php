@extends('layouts.admin')

@section('title', 'تعديل البراند')

@section('content')
    <div class="page-header">
        <h1 class="page-title">تعديل البراند</h1>
        <a href="{{ route('admin.brands.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.brands.update', $brand) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label>الاسم (عربي) *</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar', $brand->name_ar) }}" required>
            </div>
            <div class="form-group">
                <label>صورة البراند</label>
                @if($brand->image)
                    <p style="margin-top:0.5rem;"><img src="{{ asset('storage/'.$brand->image) }}" alt="" style="max-width:100px;border-radius:8px;"></p>
                    <label><input type="checkbox" name="remove_image" value="1"> حذف الصورة</label>
                @endif
                <input type="file" name="image" class="form-control" accept="image/*">
            </div>
            <div class="form-group">
                <label>ترتيب العرض</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', $brand->sort_order) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', $brand->is_active) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">حفظ</button>
        </form>
    </div>
@endsection
