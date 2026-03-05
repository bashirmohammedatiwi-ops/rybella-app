@extends('layouts.admin')

@section('title', 'إضافة بانر')

@section('content')
    <div class="page-header">
        <h1 class="page-title">إضافة بانر</h1>
        <a href="{{ route('admin.banners.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.banners.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            <div class="form-group">
                <label>العنوان</label>
                <input type="text" name="title_ar" class="form-control" value="{{ old('title_ar') }}">
            </div>
            <div class="form-group">
                <label>الصورة *</label>
                <input type="file" name="image" class="form-control" accept="image/*" required>
            </div>
            <div class="form-group">
                <label>الرابط</label>
                <input type="url" name="link" class="form-control" value="{{ old('link') }}">
            </div>
            <div class="form-group">
                <label>ترتيب العرض</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', 0) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', true) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">حفظ البانر</button>
        </form>
    </div>
@endsection
