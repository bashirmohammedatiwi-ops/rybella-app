@extends('layouts.admin')

@section('title', 'إضافة منتج')

@section('content')
    <div class="page-header">
        <h1 class="page-title">إضافة منتج</h1>
        <a href="{{ route('admin.products.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.products.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            <div class="form-group">
                <label>الاسم (عربي) *</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar') }}" required>
            </div>
            <div class="form-group">
                <label>الوصف (عربي)</label>
                <textarea name="description_ar" class="form-control" rows="4">{{ old('description_ar') }}</textarea>
            </div>
            <div class="form-group">
                <label>رمز SKU</label>
                <input type="text" name="sku" class="form-control" value="{{ old('sku') }}">
            </div>
            <div class="form-group">
                <label>الباركود (للمنتجات بدون ألوان فقط)</label>
                <input type="text" name="barcode" class="form-control" value="{{ old('barcode') }}" placeholder="يُستخدم عند عدم إضافة ألوان">
                <small class="text-muted">عند إضافة ألوان، يُحدد الباركود لكل لون</small>
            </div>
            <div class="form-group">
                <label>السعر (د.ع) *</label>
                <input type="number" name="price" class="form-control" value="{{ old('price') }}" min="0" required>
            </div>
            <div class="form-group">
                <label>سعر المقارنة (د.ع)</label>
                <input type="number" name="compare_at_price" class="form-control" value="{{ old('compare_at_price') }}" min="0">
            </div>
            <div class="form-group">
                <label>نسبة الخصم %</label>
                <input type="number" name="discount_percent" class="form-control" value="{{ old('discount_percent', 0) }}" min="0" max="100">
            </div>
            <div class="form-group">
                <label>الفئة</label>
                <select name="category_id" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($categories as $c)
                        <option value="{{ $c->id }}" {{ old('category_id') == $c->id ? 'selected' : '' }}>{{ $c->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>البراند</label>
                <select name="brand_id" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($brands as $b)
                        <option value="{{ $b->id }}" {{ old('brand_id') == $b->id ? 'selected' : '' }}>{{ $b->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>الكمية في المخزون</label>
                <input type="number" name="stock_quantity" class="form-control" value="{{ old('stock_quantity', 0) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_featured" value="1" {{ old('is_featured') ? 'checked' : '' }}> منتج مميز</label>
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', true) ? 'checked' : '' }}> نشط</label>
            </div>
            <div class="form-group">
                <label>ألوان المنتج (تدرجات أحمر الشفاه، ألوان الكحل، أصباغ الأظافر...)</label>
                <div id="colors-container"></div>
                <button type="button" class="btn btn-secondary btn-sm" id="add-color">+ إضافة لون</button>
            </div>
            <div class="form-group">
                <label>صور المنتج (يمكن إضافة عدة صور)</label>
                <input type="file" name="images[]" id="product-images" class="form-control" accept="image/*" multiple>
                <div id="image-preview" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(100px,1fr));gap:8px;margin-top:12px"></div>
                <small class="text-muted">الصورة الأولى ستكون الصورة الرئيسية</small>
            </div>
            <button type="submit" class="btn btn-primary">حفظ المنتج</button>
        </form>
    </div>
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    const imgInput = document.getElementById('product-images');
    const preview = document.getElementById('image-preview');
    imgInput.addEventListener('change', function() {
        preview.innerHTML = '';
        const files = Array.from(this.files || []);
        files.forEach((file, i) => {
            if (!file.type.startsWith('image/')) return;
            const reader = new FileReader();
            reader.onload = () => {
                const div = document.createElement('div');
                div.style.cssText = 'position:relative;border-radius:8px;overflow:hidden;aspect-ratio:1;border:1px solid #ddd';
                const img = document.createElement('img');
                img.src = reader.result;
                img.style.cssText = 'width:100%;height:100%;object-fit:cover';
                div.appendChild(img);
                const badge = document.createElement('span');
                badge.className = 'badge bg-secondary';
                badge.style.cssText = 'position:absolute;top:4px;right:4px;font-size:10px';
                badge.textContent = i === 0 ? 'رئيسية' : (i+1);
                div.appendChild(badge);
                preview.appendChild(div);
            };
            reader.readAsDataURL(file);
        });
    });

    const container = document.getElementById('colors-container');
    const addBtn = document.getElementById('add-color');
    function addRow() {
        const row = document.createElement('div');
        row.className = 'color-row';
        row.style.cssText = 'display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px;align-items:center;padding:12px;border:1px solid #eee;border-radius:8px';
        row.innerHTML = '<input type="text" name="colors[name_ar][]" class="form-control" placeholder="اسم اللون" style="flex:1;min-width:120px">' +
            '<input type="text" name="colors[hex_code][]" class="form-control" placeholder="#hex" style="width:90px">' +
            '<input type="text" name="colors[barcode][]" class="form-control" placeholder="الباركود" style="width:130px">' +
            '<input type="file" name="colors[image][]" accept="image/*" class="form-control" style="width:180px" title="صورة خاصة باللون">' +
            '<button type="button" class="btn btn-danger btn-sm remove-color">حذف</button>';
        container.appendChild(row);
        row.querySelector('.remove-color').onclick = () => row.remove();
    }
    addBtn.onclick = addRow;
    container.querySelectorAll('.remove-color').forEach(btn => {
        btn.onclick = () => btn.closest('.color-row').remove();
    });
});
</script>
@endpush
