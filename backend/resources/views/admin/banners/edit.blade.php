@extends('layouts.admin')

@section('title', 'تعديل بانر')

@section('content')
    <div class="page-header">
        <h1 class="page-title">تعديل البانر</h1>
        <a href="{{ route('admin.banners.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.banners.update', $banner) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label>العنوان</label>
                <input type="text" name="title_ar" class="form-control" value="{{ old('title_ar', $banner->title_ar) }}">
            </div>
            <div class="form-group">
                <label>الصورة (تركها فارغة للإبقاء على الحالية)</label>
                <input type="file" name="image" class="form-control" accept="image/*">
                @if($banner->image)
                    <p style="margin-top:0.5rem;"><img src="{{ asset('storage/'.$banner->image) }}" alt="" style="max-width:200px;border-radius:8px;"></p>
                @endif
            </div>
            <div class="form-group">
                <label>الرابط</label>
                <input type="url" name="link" class="form-control" value="{{ old('link', $banner->link) }}">
            </div>
            <div class="form-group">
                <label>ترتيب العرض</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', $banner->sort_order) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', $banner->is_active) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">تحديث البانر</button>
        </form>
    </div>
@endsection
