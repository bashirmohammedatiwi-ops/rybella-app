@extends('layouts.admin')

@section('title', 'تعديل قاعدة الخصم')

@section('content')
    <div class="page-header">
        <h1 class="page-title">تعديل قاعدة الخصم</h1>
        <a href="{{ route('admin.discount-rules.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.discount-rules.update', $discountRule) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label>الاسم (اختياري)</label>
                <input type="text" name="name_ar" class="form-control" value="{{ old('name_ar', $discountRule->name_ar') }}">
            </div>
            <div class="form-group">
                <label>نطاق التطبيق *</label>
                <select name="scope_type" id="scope_type" class="form-control" required>
                    <option value="product" {{ old('scope_type', $discountRule->scope_type) == 'product' ? 'selected' : '' }}>منتج معين</option>
                    <option value="category" {{ old('scope_type', $discountRule->scope_type) == 'category' ? 'selected' : '' }}>فئة</option>
                    <option value="brand" {{ old('scope_type', $discountRule->scope_type) == 'brand' ? 'selected' : '' }}>براند</option>
                </select>
            </div>
            <div class="form-group" id="scope_product_group">
                <label>المنتج</label>
                <select name="scope_id" id="scope_product" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($products as $p)
                        <option value="{{ $p->id }}" {{ old('scope_id', $discountRule->scope_id) == $p->id && $discountRule->scope_type == 'product' ? 'selected' : '' }}>{{ $p->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group" id="scope_category_group" style="display:none;">
                <label>الفئة</label>
                <select name="scope_id" id="scope_category" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($categories as $c)
                        <option value="{{ $c->id }}" {{ old('scope_id', $discountRule->scope_id) == $c->id ? 'selected' : '' }}>{{ $c->name_ar }}</option>
                        @foreach($c->children as $ch)
                            <option value="{{ $ch->id }}" {{ old('scope_id', $discountRule->scope_id) == $ch->id ? 'selected' : '' }}>— {{ $ch->name_ar }}</option>
                        @endforeach
                    @endforeach
                </select>
            </div>
            <div class="form-group" id="scope_brand_group" style="display:none;">
                <label>البراند</label>
                <select name="scope_id" id="scope_brand" class="form-control">
                    <option value="">— اختر —</option>
                    @foreach($brands as $b)
                        <option value="{{ $b->id }}" {{ old('scope_id', $discountRule->scope_id) == $b->id ? 'selected' : '' }}>{{ $b->name_ar }}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>نوع الخصم *</label>
                <select name="discount_type" class="form-control" required>
                    <option value="percent" {{ old('discount_type', $discountRule->discount_type) == 'percent' ? 'selected' : '' }}>نسبة مئوية %</option>
                    <option value="fixed" {{ old('discount_type', $discountRule->discount_type) == 'fixed' ? 'selected' : '' }}>مبلغ ثابت (د.ع)</option>
                </select>
            </div>
            <div class="form-group">
                <label>القيمة *</label>
                <input type="number" name="value" class="form-control" value="{{ old('value', $discountRule->value) }}" min="0" step="0.01" required>
            </div>
            <div class="form-group">
                <label>تاريخ البداية</label>
                <input type="datetime-local" name="starts_at" class="form-control" value="{{ old('starts_at', $discountRule->starts_at?->format('Y-m-d\TH:i')) }}">
            </div>
            <div class="form-group">
                <label>تاريخ النهاية</label>
                <input type="datetime-local" name="ends_at" class="form-control" value="{{ old('ends_at', $discountRule->ends_at?->format('Y-m-d\TH:i')) }}">
            </div>
            <div class="form-group">
                <label>ترتيب الأولوية</label>
                <input type="number" name="sort_order" class="form-control" value="{{ old('sort_order', $discountRule->sort_order) }}" min="0">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', $discountRule->is_active) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">حفظ</button>
        </form>
    </div>

    @push('scripts')
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const st = document.getElementById('scope_type');
        const pg = document.getElementById('scope_product_group');
        const cg = document.getElementById('scope_category_group');
        const bg = document.getElementById('scope_brand_group');
        const sp = document.getElementById('scope_product');
        const sc = document.getElementById('scope_category');
        const sb = document.getElementById('scope_brand');
        function updateScopeSelects() {
            pg.style.display = 'none'; cg.style.display = 'none'; bg.style.display = 'none';
            sp.name = ''; sc.name = ''; sb.name = '';
            if (st.value === 'product') { pg.style.display = 'block'; sp.name = 'scope_id'; }
            else if (st.value === 'category') { cg.style.display = 'block'; sc.name = 'scope_id'; }
            else { bg.style.display = 'block'; sb.name = 'scope_id'; }
        }
        st.onchange = updateScopeSelects;
        updateScopeSelects();
    });
    </script>
    @endpush
@endsection
