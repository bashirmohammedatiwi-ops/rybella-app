@extends('layouts.admin')

@section('title', 'إضافة قسيمة')

@section('content')
    <div class="page-header">
        <h1 class="page-title">إضافة قسيمة</h1>
        <a href="{{ route('admin.coupons.index') }}" class="btn btn-secondary">رجوع</a>
    </div>

    <div class="card">
        <form action="{{ route('admin.coupons.store') }}" method="POST">
            @csrf
            <div class="form-group">
                <label>رمز القسيمة *</label>
                <input type="text" name="code" class="form-control" value="{{ old('code') }}" required>
            </div>
            <div class="form-group">
                <label>الوصف</label>
                <input type="text" name="description_ar" class="form-control" value="{{ old('description_ar') }}">
            </div>
            <div class="form-group">
                <label>النوع *</label>
                <select name="type" class="form-control" required>
                    <option value="percent" {{ old('type') == 'percent' ? 'selected' : '' }}>نسبة مئوية</option>
                    <option value="fixed" {{ old('type') == 'fixed' ? 'selected' : '' }}>مبلغ ثابت</option>
                </select>
            </div>
            <div class="form-group">
                <label>القيمة *</label>
                <input type="number" name="value" class="form-control" value="{{ old('value') }}" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label>الحد الأدنى للطلب (د.ع)</label>
                <input type="number" name="min_order_amount" class="form-control" value="{{ old('min_order_amount') }}" min="0">
            </div>
            <div class="form-group">
                <label>حد الاستخدام (عدد المرات)</label>
                <input type="number" name="usage_limit" class="form-control" value="{{ old('usage_limit') }}" min="0">
            </div>
            <div class="form-group">
                <label>تاريخ البداية</label>
                <input type="datetime-local" name="starts_at" class="form-control" value="{{ old('starts_at') }}">
            </div>
            <div class="form-group">
                <label>تاريخ النهاية</label>
                <input type="datetime-local" name="ends_at" class="form-control" value="{{ old('ends_at') }}">
            </div>
            <div class="form-group">
                <label><input type="checkbox" name="is_active" value="1" {{ old('is_active', true) ? 'checked' : '' }}> نشط</label>
            </div>
            <button type="submit" class="btn btn-primary">حفظ القسيمة</button>
        </form>
    </div>
@endsection
