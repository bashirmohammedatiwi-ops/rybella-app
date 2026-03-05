@extends('layouts.admin')

@section('title', 'تعديل فئة')

@section('content')
    <div class="page-header">
        <h1 class="page-title">تعديل: {{ $category->name_ar }}</h1>
        <a href="{{ route('admin.categories.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.categories.update', $category) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label>الاسم (عربي) *</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar', $category->name_ar) }}" required>
            </div>
            <div class="form-group">
                <label>الوصف</label>
                <textarea name="description_ar" class="form-control" rows="3">{{ old('description_ar', $category->description_ar) }}</textarea>
            </div>
            <div class="form-group">
                <label>الفئة الأب</label>
                <select name="parent_id" class="form-control">
                    <option value="">— لا يوجد —</option>
                    @foreach($parents as $p)
                        <option value="{{ $p->id }}" {{ old('parent_id', $category->parent_id) == $p->id ? 'selected' : '' }}>{{ $p->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>صورة الفئة</label>
                @if($category->image)
                    <div style="margin-bottom:0.5rem;">
                        <img src="{{ asset('storage/'.$category->image) }}" alt="" style="max-width:100px;height:100px;object-fit:cover;border-radius:12px;border:1px solid #ddd;">
                        <label style="margin-right:8px;"><input type="checkbox" name="remove_image" value="1"> حذف الصورة</label>
                    </div>
                @endif
                <input type="file" name="image" class="form-control" accept="image/*">
                <small class="text-muted">اتركه فارغاً للإبقاء على الصورة الحالية</small>
            </div>
            <div class="form-group">
                <label>أيقونة الفئة (تُعرض عند عدم وجود صورة)</label>
                <select name="icon" class="form-control">
                    <option value="">— لا شيء (أيقونة افتراضية) —</option>
                    <option value="spa_rounded" {{ old('icon', $category->icon) == 'spa_rounded' ? 'selected' : '' }}>وردة / عناية</option>
                    <option value="face_rounded" {{ old('icon', $category->icon) == 'face_rounded' ? 'selected' : '' }}>وجه</option>
                    <option value="face_retouching_natural_rounded" {{ old('icon', $category->icon) == 'face_retouching_natural_rounded' ? 'selected' : '' }}>عناية بالبشرة</option>
                    <option value="palette_rounded" {{ old('icon', $category->icon) == 'palette_rounded' ? 'selected' : '' }}>ألوان / مكياج</option>
                    <option value="diamond_rounded" {{ old('icon', $category->icon) == 'diamond_rounded' ? 'selected' : '' }}>فخامة</option>
                    <option value="local_offer_rounded" {{ old('icon', $category->icon) == 'local_offer_rounded' ? 'selected' : '' }}>عروض</option>
                    <option value="shopping_bag_rounded" {{ old('icon', $category->icon) == 'shopping_bag_rounded' ? 'selected' : '' }}>تسوق</option>
                    <option value="inventory_2_rounded" {{ old('icon', $category->icon) == 'inventory_2_rounded' ? 'selected' : '' }}>منتجات</option>
                    <option value="checkroom_rounded" {{ old('icon', $category->icon) == 'checkroom_rounded' ? 'selected' : '' }}>أزياء</option>
                    <option value="water_drop_rounded" {{ old('icon', $category->icon) == 'water_drop_rounded' ? 'selected' : '' }}>مرطب</option>
                    <option value="self_improvement_rounded" {{ old('icon', $category->icon) == 'self_improvement_rounded' ? 'selected' : '' }}>يوجا / راحة</option>
                    <option value="eco_rounded" {{ old('icon', $category->icon) == 'eco_rounded' ? 'selected' : '' }}>طبيعي</option>
                    <option value="star_rounded" {{ old('icon', $category->icon) == 'star_rounded' ? 'selected' : '' }}>مميز</option>
                    <option value="favorite_rounded" {{ old('icon', $category->icon) == 'favorite_rounded' ? 'selected' : '' }}>قلب</option>
                    <option value="celebration_rounded" {{ old('icon', $category->icon) == 'celebration_rounded' ? 'selected' : '' }}>احتفال</option>
                </select>
            </div>
            <div class="form-group">
                <label>ترتيب العرض</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', $category->sort_order) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', $category->is_active) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">تحديث الفئة</button>
        </form>
    </div>
@endsection
