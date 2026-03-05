<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\DiscountRule;
use App\Models\Product;
use Illuminate\Http\Request;

class DiscountRuleController extends Controller
{
    public function index()
    {
        $rules = DiscountRule::orderBy('sort_order')->orderByDesc('created_at')->paginate(20);
        return view('admin.discount_rules.index', compact('rules'));
    }

    public function create()
    {
        $products = Product::orderBy('name_ar')->get(['id', 'name_ar']);
        $categories = Category::whereNull('parent_id')->with('children')->orderBy('sort_order')->get();
        $brands = Brand::where('is_active', true)->orderBy('name_ar')->get();
        return view('admin.discount_rules.create', compact('products', 'categories', 'brands'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name_ar' => 'nullable|string|max:255',
            'scope_type' => 'required|in:product,category,brand',
            'scope_id' => 'required_with:scope_type|nullable|integer',
            'discount_type' => 'required|in:percent,fixed',
            'value' => 'required|numeric|min:0',
            'starts_at' => 'nullable|date',
            'ends_at' => 'nullable|date|after_or_equal:starts_at',
            'sort_order' => 'nullable|integer|min:0',
            'is_active' => 'boolean',
        ]);
        $data['value'] = $data['discount_type'] === 'percent' ? min(100, $data['value']) : $data['value'];
        $data['scope_id'] = ($data['scope_id'] ?? '') !== '' ? (int) $data['scope_id'] : null;
        $data['is_active'] = $request->boolean('is_active', true);
        $data['sort_order'] = $data['sort_order'] ?? 0;
        DiscountRule::create($data);
        return redirect()->route('admin.discount-rules.index')->with('success', 'تم إضافة قاعدة الخصم بنجاح');
    }

    public function edit(DiscountRule $discountRule)
    {
        $products = Product::orderBy('name_ar')->get(['id', 'name_ar']);
        $categories = Category::whereNull('parent_id')->with('children')->orderBy('sort_order')->get();
        $brands = Brand::where('is_active', true)->orderBy('name_ar')->get();
        return view('admin.discount_rules.edit', compact('discountRule', 'products', 'categories', 'brands'));
    }

    public function update(Request $request, DiscountRule $discountRule)
    {
        $data = $request->validate([
            'name_ar' => 'nullable|string|max:255',
            'scope_type' => 'required|in:product,category,brand',
            'scope_id' => 'required_with:scope_type|nullable|integer',
            'discount_type' => 'required|in:percent,fixed',
            'value' => 'required|numeric|min:0',
            'starts_at' => 'nullable|date',
            'ends_at' => 'nullable|date',
            'sort_order' => 'nullable|integer|min:0',
            'is_active' => 'boolean',
        ]);
        $data['value'] = $data['discount_type'] === 'percent' ? min(100, $data['value']) : $data['value'];
        $data['scope_id'] = ($data['scope_id'] ?? '') !== '' ? (int) $data['scope_id'] : null;
        $data['is_active'] = $request->boolean('is_active');
        $data['sort_order'] = $data['sort_order'] ?? 0;
        $discountRule->update($data);
        return redirect()->route('admin.discount-rules.index')->with('success', 'تم تحديث قاعدة الخصم');
    }

    public function destroy(DiscountRule $discountRule)
    {
        $discountRule->delete();
        return redirect()->route('admin.discount-rules.index')->with('success', 'تم حذف قاعدة الخصم');
    }
}
