@extends('layouts.admin')

@section('title', 'إضافة فئة')

@section('content')
    <div class="page-header">
        <h1 class="page-title">إضافة فئة</h1>
        <a href="{{ route('admin.categories.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.categories.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            <div class="form-group">
                <label>الاسم (عربي) *</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar') }}" required>
            </div>
            <div class="form-group">
                <label>الوصف</label>
                <textarea name="description_ar" class="form-control" rows="3">{{ old('description_ar') }}</textarea>
            </div>
            <div class="form-group">
                <label>الفئة الأب</label>
                <select name="parent_id" class="form-control">
                    <option value="">— لا يوجد —</option>
                    @foreach($parents as $p)
                        <option value="{{ $p->id }}" {{ old('parent_id') == $p->id ? 'selected' : '' }}>{{ $p->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>صورة الفئة (اختياري - تُعرض بدل الأيقونة إن وُجدت)</label>
                <input type="file" name="image" class="form-control" accept="image/*">
            </div>
            <div class="form-group">
                <label>أيقونة الفئة (اختياري - تُعرض عند عدم وجود صورة)</label>
                <select name="icon" class="form-control">
                    <option value="">— لا شيء (أيقونة افتراضية) —</option>
                    <option value="spa_rounded" {{ old('icon') == 'spa_rounded' ? 'selected' : '' }}>وردة / عناية</option>
                    <option value="face_rounded" {{ old('icon') == 'face_rounded' ? 'selected' : '' }}>وجه</option>
                    <option value="face_retouching_natural_rounded" {{ old('icon') == 'face_retouching_natural_rounded' ? 'selected' : '' }}>عناية بالبشرة</option>
                    <option value="palette_rounded" {{ old('icon') == 'palette_rounded' ? 'selected' : '' }}>ألوان / مكياج</option>
                    <option value="diamond_rounded" {{ old('icon') == 'diamond_rounded' ? 'selected' : '' }}>فخامة</option>
                    <option value="local_offer_rounded" {{ old('icon') == 'local_offer_rounded' ? 'selected' : '' }}>عروض</option>
                    <option value="shopping_bag_rounded" {{ old('icon') == 'shopping_bag_rounded' ? 'selected' : '' }}>تسوق</option>
                    <option value="inventory_2_rounded" {{ old('icon') == 'inventory_2_rounded' ? 'selected' : '' }}>منتجات</option>
                    <option value="checkroom_rounded" {{ old('icon') == 'checkroom_rounded' ? 'selected' : '' }}>أزياء</option>
                    <option value="water_drop_rounded" {{ old('icon') == 'water_drop_rounded' ? 'selected' : '' }}>مرطب</option>
                    <option value="self_improvement_rounded" {{ old('icon') == 'self_improvement_rounded' ? 'selected' : '' }}>يوجا / راحة</option>
                    <option value="eco_rounded" {{ old('icon') == 'eco_rounded' ? 'selected' : '' }}>طبيعي</option>
                    <option value="star_rounded" {{ old('icon') == 'star_rounded' ? 'selected' : '' }}>مميز</option>
                    <option value="favorite_rounded" {{ old('icon') == 'favorite_rounded' ? 'selected' : '' }}>قلب</option>
                    <option value="celebration_rounded" {{ old('icon') == 'celebration_rounded' ? 'selected' : '' }}>احتفال</option>
                </select>
            </div>
            <div class="form-group">
                <label>ترتيب العرض</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', 0) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', true) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">حفظ الفئة</button>
        </form>
    </div>
@endsection
