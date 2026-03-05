<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Inventory;
use App\Models\Product;
use App\Models\ProductImage;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::with('category', 'images')->orderByDesc('created_at')->paginate(20);
        return view('admin.products.index', compact('products'));
    }

    public function create()
    {
        $categories = Category::whereNull('parent_id')->orderBy('sort_order')->get();
        $brands = Brand::where('is_active', true)->orderBy('sort_order')->orderBy('name_ar')->get();
        return view('admin.products.create', compact('categories', 'brands'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name_ar' => 'required|string|max:255',
            'description_ar' => 'nullable|string',
            'sku' => 'nullable|string|max:100',
            'barcode' => 'nullable|string|max:100',
            'price' => 'required|numeric|min:0',
            'compare_at_price' => 'nullable|numeric|min:0',
            'discount_percent' => 'nullable|integer|min:0|max:100',
            'category_id' => 'nullable|exists:categories,id',
            'is_featured' => 'boolean',
            'is_active' => 'boolean',
            'stock_quantity' => 'nullable|integer|min:0',
            'images.*' => 'image|max:2048',
        ]);
        $data['slug'] = Str::slug($data['name_ar'] . '-' . Str::random(4));
        $data['is_featured'] = $request->boolean('is_featured');
        $data['is_active'] = $request->boolean('is_active', true);
        $data['discount_percent'] = $data['discount_percent'] ?? 0;
        $data['compare_at_price'] = isset($data['compare_at_price']) && $data['compare_at_price'] !== '' ? $data['compare_at_price'] : null;
        $data['category_id'] = isset($data['category_id']) && $data['category_id'] !== '' ? $data['category_id'] : null;
        $data['brand_id'] = isset($data['brand_id']) && $data['brand_id'] !== '' ? $data['brand_id'] : null;
        $stock = (int) ($data['stock_quantity'] ?? 0);
        unset($data['stock_quantity'], $data['images']);

        $product = Product::create($data);
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $i => $file) {
                $path = $file->store('products', 'public');
                ProductImage::create([
                    'product_id' => $product->id,
                    'path' => $path,
                    'sort_order' => $i,
                    'is_primary' => $i === 0,
                ]);
            }
        } else {
            ProductImage::create([
                'product_id' => $product->id,
                'path' => 'products/placeholder.png',
                'sort_order' => 0,
                'is_primary' => true,
            ]);
        }
        Inventory::create([
            'product_id' => $product->id,
            'quantity' => $stock,
            'low_stock_threshold' => 5,
        ]);
        // Add colors with barcode and image
        $colors = $request->input('colors', []);
        if (!empty($colors['name_ar'])) {
            foreach ($colors['name_ar'] as $i => $name) {
                $name = trim($name ?? '');
                if ($name !== '') {
                    $imagePath = null;
                    $colorImages = $request->file('colors.image', []);
                    if (!empty($colorImages[$i])) {
                        $imagePath = $colorImages[$i]->store('product-colors', 'public');
                    }
                    $product->colors()->create([
                        'name_ar' => $name,
                        'hex_code' => $colors['hex_code'][$i] ?? null,
                        'barcode' => $colors['barcode'][$i] ?? null,
                        'image' => $imagePath,
                        'sort_order' => $i,
                    ]);
                }
            }
        }
        return redirect()->route('admin.products.index')->with('success', 'تم إضافة المنتج بنجاح');
    }

    public function edit(Product $product)
    {
        $product->load('images', 'inventory', 'colors');
        $categories = Category::whereNull('parent_id')->orderBy('sort_order')->get();
        $brands = Brand::where('is_active', true)->orderBy('sort_order')->orderBy('name_ar')->get();
        return view('admin.products.edit', compact('product', 'categories', 'brands'));
    }

    public function update(Request $request, Product $product)
    {
        $data = $request->validate([
            'name_ar' => 'required|string|max:255',
            'description_ar' => 'nullable|string',
            'sku' => 'nullable|string|max:100',
            'barcode' => 'nullable|string|max:100',
            'price' => 'required|numeric|min:0',
            'compare_at_price' => 'nullable|numeric|min:0',
            'discount_percent' => 'nullable|integer|min:0|max:100',
            'category_id' => 'nullable|exists:categories,id',
            'brand_id' => 'nullable|exists:brands,id',
            'is_featured' => 'boolean',
            'is_active' => 'boolean',
            'stock_quantity' => 'nullable|integer|min:0',
            'images.*' => 'image|max:2048',
        ]);
        $data['is_featured'] = $request->boolean('is_featured');
        $data['is_active'] = $request->boolean('is_active');
        $data['discount_percent'] = $data['discount_percent'] ?? 0;
        $data['compare_at_price'] = isset($data['compare_at_price']) && $data['compare_at_price'] !== '' ? $data['compare_at_price'] : null;
        $data['category_id'] = isset($data['category_id']) && $data['category_id'] !== '' ? $data['category_id'] : null;
        $data['brand_id'] = isset($data['brand_id']) && $data['brand_id'] !== '' ? $data['brand_id'] : null;
        $stock = isset($data['stock_quantity']) ? (int) $data['stock_quantity'] : null;
        unset($data['stock_quantity'], $data['images']);

        $product->update($data);
        if ($stock !== null) {
            $inv = $product->inventory()->first();
            if ($inv) {
                $inv->update(['quantity' => $stock]);
            } else {
                Inventory::create(['product_id' => $product->id, 'quantity' => $stock, 'low_stock_threshold' => 5]);
            }
        }
        if ($request->hasFile('images')) {
            $startOrder = (int) $product->images()->max('sort_order') + 1;
            foreach ($request->file('images') as $i => $file) {
                $path = $file->store('products', 'public');
                ProductImage::create([
                    'product_id' => $product->id,
                    'path' => $path,
                    'sort_order' => $startOrder + $i,
                    'is_primary' => $product->images()->count() === 0 && $i === 0,
                ]);
            }
        }
        // Update colors with barcode and image
        $product->colors()->delete();
        $colors = $request->input('colors', []);
        if (!empty($colors['name_ar'])) {
            foreach ($colors['name_ar'] as $i => $name) {
                $name = trim($name ?? '');
                if ($name !== '') {
                    $imagePath = null;
                    $colorImages = $request->file('colors.image', []);
                    if (!empty($colorImages[$i])) {
                        $imagePath = $colorImages[$i]->store('product-colors', 'public');
                    } elseif (!empty($colors['image_keep'][$i])) {
                        $imagePath = $colors['image_keep'][$i];
                    }
                    $product->colors()->create([
                        'name_ar' => $name,
                        'hex_code' => $colors['hex_code'][$i] ?? null,
                        'barcode' => $colors['barcode'][$i] ?? null,
                        'image' => $imagePath,
                        'sort_order' => $i,
                    ]);
                }
            }
        }
        return redirect()->route('admin.products.index')->with('success', 'تم تحديث المنتج بنجاح');
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return redirect()->route('admin.products.index')->with('success', 'تم حذف المنتج');
    }

    public function destroyImage(Product $product, ProductImage $image)
    {
        if ($image->product_id !== $product->id) {
            abort(404);
        }
        \Illuminate\Support\Facades\Storage::disk('public')->delete($image->path);
        $image->delete();
        $remaining = $product->images()->first();
        if ($remaining && !$product->images()->where('is_primary', true)->exists()) {
            $remaining->update(['is_primary' => true]);
        }
        return redirect()->back()->with('success', 'تم حذف الصورة');
    }

    public function setPrimaryImage(Product $product, ProductImage $image)
    {
        if ($image->product_id !== $product->id) {
            abort(404);
        }
        $product->images()->update(['is_primary' => false]);
        $image->update(['is_primary' => true]);
        return redirect()->back()->with('success', 'تم تعيين الصورة كرئيسية');
    }
}
