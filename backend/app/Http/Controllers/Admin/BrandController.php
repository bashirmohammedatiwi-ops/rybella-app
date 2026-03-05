<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class BrandController extends Controller
{
    public function index()
    {
        $brands = Brand::withCount('products')->orderBy('sort_order')->orderBy('name_ar')->paginate(20);
        return view('admin.brands.index', compact('brands'));
    }

    public function create()
    {
        return view('admin.brands.create');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name_ar' => 'required|string|max:255',
            'image' => 'nullable|image|max:2048',
            'sort_order' => 'nullable|integer|min:0',
            'is_active' => 'boolean',
        ]);
        $data['slug'] = Str::slug($data['name_ar'] . '-' . Str::random(4));
        $data['is_active'] = $request->boolean('is_active', true);
        $data['sort_order'] = $data['sort_order'] ?? 0;
        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('brands', 'public');
        }
        Brand::create($data);
        return redirect()->route('admin.brands.index')->with('success', 'تم إضافة البراند بنجاح');
    }

    public function edit(Brand $brand)
    {
        return view('admin.brands.edit', compact('brand'));
    }

    public function update(Request $request, Brand $brand)
    {
        $data = $request->validate([
            'name_ar' => 'required|string|max:255',
            'image' => 'nullable|image|max:2048',
            'sort_order' => 'nullable|integer|min:0',
            'is_active' => 'boolean',
        ]);
        $data['is_active'] = $request->boolean('is_active');
        $data['sort_order'] = $data['sort_order'] ?? 0;
        if ($request->boolean('remove_image')) {
            if ($brand->image) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($brand->image);
            }
            $data['image'] = null;
        } elseif ($request->hasFile('image')) {
            if ($brand->image) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($brand->image);
            }
            $data['image'] = $request->file('image')->store('brands', 'public');
        }
        $brand->update($data);
        return redirect()->route('admin.brands.index')->with('success', 'تم تحديث البراند بنجاح');
    }

    public function destroy(Brand $brand)
    {
        if ($brand->products()->count() > 0) {
            return redirect()->back()->with('error', 'لا يمكن الحذف. يوجد منتجات مرتبطة بهذا البراند');
        }
        if ($brand->image) {
            \Illuminate\Support\Facades\Storage::disk('public')->delete($brand->image);
        }
        $brand->delete();
        return redirect()->route('admin.brands.index')->with('success', 'تم حذف البراند');
    }
}
