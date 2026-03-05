@extends('layouts.admin')

@section('title', 'تعديل منتج')

@section('content')
    <div class="page-header">
        <h1 class="page-title">تعديل: {{ $product->name_ar }}</h1>
        <a href="{{ route('admin.products.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    @if($product->images->isNotEmpty())
    <div class="card" style="margin-bottom:20px">
        <h3 style="margin-bottom:16px">الصور الحالية</h3>
        <div class="product-images-grid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:12px">
            @foreach($product->images as $img)
                <div class="image-card" style="position:relative;border:2px solid {{ $img->is_primary ? '#e91e63' : '#e0e0e0' }};border-radius:12px;overflow:hidden;aspect-ratio:1">
                    <img src="{{ asset('storage/'.$img->path) }}" alt="صورة المنتج" style="width:100%;height:100%;object-fit:cover">
                    <div style="position:absolute;bottom:0;left:0;right:0;background:rgba(0,0,0,0.6);display:flex;gap:4px;justify-content:center;padding:6px">
                        @if(!$img->is_primary)
                            <form action="{{ route('admin.products.images.primary', [$product, $img]) }}" method="POST" style="display:inline">
                                @csrf
                                @method('PATCH')
                                <button type="submit" class="btn btn-sm btn-light" title="تعيين كصورة رئيسية">★</button>
                            </form>
                        @else
                            <span class="badge bg-primary" style="font-size:10px">رئيسية</span>
                        @endif
                        <form action="{{ route('admin.products.images.destroy', [$product, $img]) }}" method="POST" style="display:inline" onsubmit="return confirm('حذف هذه الصورة؟')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-sm btn-danger" title="حذف">🗑</button>
                        </form>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
    @endif

    <div class="card">
        <form action="{{ route('admin.products.update', $product) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label>الاسم (عربي) *</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar', $product->name_ar) }}" required>
            </div>
            <div class="form-group">
                <label>الوصف (عربي)</label>
                <textarea name="description_ar" class="form-control" rows="4">{{ old('description_ar', $product->description_ar) }}</textarea>
            </div>
            <div class="form-group">
                <label>رمز SKU</label>
                <input type="text" name="sku" class="form-control" value="{{ old('sku', $product->sku) }}">
            </div>
            <div class="form-group">
                <label>الباركود (للمنتجات بدون ألوان فقط)</label>
                <input type="text" name="barcode" class="form-control" value="{{ old('barcode', $product->barcode) }}" placeholder="يُستخدم عند عدم إضافة ألوان">
                <small class="text-muted">عند إضافة ألوان، يُحدد الباركود لكل لون</small>
            </div>
            <div class="form-group">
                <label>السعر (د.ع) *</label>
                <input type="number" name="price" class="form-control" value="{{ old('price', $product->price) }}" min="0" required>
            </div>
            <div class="form-group">
                <label>سعر المقارنة (د.ع)</label>
                <input type="number" name="compare_at_price" class="form-control" value="{{ old('compare_at_price', $product->compare_at_price) }}" min="0">
            </div>
            <div class="form-group">
                <label>نسبة الخصم %</label>
                <input type="number" name="discount_percent" class="form-control" value="{{ old('discount_percent', $product->discount_percent) }}" min="0" max="100">
            </div>
            <div class="form-group">
                <label>الفئة</label>
                <select name="category_id" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($categories as $c)
                        <option value="{{ $c->id }}" {{ old('category_id', $product->category_id) == $c->id ? 'selected' : '' }}>{{ $c->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>البراند</label>
                <select name="brand_id" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($brands as $b)
                        <option value="{{ $b->id }}" {{ old('brand_id', $product->brand_id) == $b->id ? 'selected' : '' }}>{{ $b->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            @php $inv = $product->inventory->first(); @endphp
            <div class="form-group">
                <label>الكمية في المخزون</label>
                <input type="number" name="stock_quantity" class="form-control" value="{{ old('stock_quantity', $inv?->quantity ?? 0) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_featured" value="1" {{ old('is_featured', $product->is_featured) ? 'checked' : '' }}> منتج مميز</label>
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', $product->is_active) ? 'checked' : '' }}> نشط</label>
            </div>
            <div class="form-group">
                <label>ألوان المنتج (تدرجات أحمر الشفاه، ألوان الكحل، أصباغ الأظافر...)</label>
                <p class="text-muted" style="font-size:13px">كل لون: باركود خاص + صورة خاصة (عند اختيار اللون في التطبيق تظهر صورته)</p>
                <div id="colors-container">
                    @foreach($product->colors as $c)
                    <div class="color-row" style="display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px;align-items:center;padding:12px;border:1px solid #eee;border-radius:8px">
                        <input type="text" name="colors[name_ar][]" class="form-control" placeholder="اسم اللون" value="{{ old('colors.name_ar.'.$loop->index, $c->name_ar) }}" style="flex:1;min-width:120px">
                        <input type="text" name="colors[hex_code][]" class="form-control" placeholder="#hex" value="{{ old('colors.hex_code.'.$loop->index, $c->hex_code) }}" style="width:90px">
                        <input type="text" name="colors[barcode][]" class="form-control" placeholder="الباركود" value="{{ old('colors.barcode.'.$loop->index, $c->barcode) }}" style="width:130px">
                        <input type="hidden" name="colors[image_keep][]" value="{{ $c->image ?? '' }}">
                        @if($c->image)
                        <img src="{{ asset('storage/'.$c->image) }}" alt="" style="width:50px;height:50px;object-fit:cover;border-radius:8px" title="الصورة الحالية">
                        @endif
                        <input type="file" name="colors[image][]" accept="image/*" class="form-control" style="width:180px" title="صورة جديدة (اختياري)">
                        @if($c->hex_code)
                        <span style="width:28px;height:28px;border-radius:50%;background:{{ $c->hex_code }};border:1px solid #ddd;" title="لون"></span>
                        @endif
                        <button type="button" class="btn btn-danger btn-sm remove-color">حذف</button>
                    </div>
                    @endforeach
                </div>
                <button type="button" class="btn btn-secondary btn-sm" id="add-color">+ إضافة لون</button>
            </div>
            <div class="form-group">
                <label>إضافة صور جديدة</label>
                <input type="file" name="images[]" id="new-images" class="form-control" accept="image/*" multiple>
                <div id="new-images-preview" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(100px,1fr));gap:8px;margin-top:12px"></div>
                <small class="text-muted">يمكنك اختيار عدة صور دفعة واحدة</small>
            </div>
            <button type="submit" class="btn btn-primary">تحديث المنتج</button>
        </form>
    </div>
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    const newImgInput = document.getElementById('new-images');
    const newPreview = document.getElementById('new-images-preview');
    if (newImgInput && newPreview) {
        newImgInput.addEventListener('change', function() {
            newPreview.innerHTML = '';
            Array.from(this.files || []).forEach((file, i) => {
                if (!file.type.startsWith('image/')) return;
                const reader = new FileReader();
                reader.onload = () => {
                    const div = document.createElement('div');
                    div.style.cssText = 'border-radius:8px;overflow:hidden;aspect-ratio:1;border:1px solid #ddd';
                    const img = document.createElement('img');
                    img.src = reader.result;
                    img.style.cssText = 'width:100%;height:100%;object-fit:cover';
                    div.appendChild(img);
                    newPreview.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        });
    }

    const container = document.getElementById('colors-container');
    const addBtn = document.getElementById('add-color');
    addBtn.onclick = function() {
        const row = document.createElement('div');
        row.className = 'color-row';
        row.style.cssText = 'display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px;align-items:center;padding:12px;border:1px solid #eee;border-radius:8px';
        row.innerHTML = '<input type="text" name="colors[name_ar][]" class="form-control" placeholder="اسم اللون" style="flex:1;min-width:120px">' +
            '<input type="text" name="colors[hex_code][]" class="form-control" placeholder="#hex" style="width:90px">' +
            '<input type="text" name="colors[barcode][]" class="form-control" placeholder="الباركود" style="width:130px">' +
            '<input type="hidden" name="colors[image_keep][]" value="">' +
            '<input type="file" name="colors[image][]" accept="image/*" class="form-control" style="width:180px" title="صورة اللون">' +
            '<button type="button" class="btn btn-danger btn-sm remove-color">حذف</button>';
        container.appendChild(row);
        row.querySelector('.remove-color').onclick = () => row.remove();
    };
    container.querySelectorAll('.remove-color').forEach(btn => {
        btn.onclick = () => btn.closest('.color-row').remove();
    });
});
</script>
@endpush
