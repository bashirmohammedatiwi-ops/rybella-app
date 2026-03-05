<?php

namespace Database\Seeders;

use App\Models\AdminUser;
use App\Models\Banner;
use App\Models\Category;
use App\Models\Coupon;
use App\Models\Inventory;
use App\Models\Product;
use App\Models\ProductImage;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        AdminUser::create([
            'name' => 'مدير النظام',
            'email' => 'admin@cosmatic.iq',
            'password' => bcrypt('password'),
        ]);

        $categories = [
            ['name_ar' => 'مستحضرات العناية بالبشرة', 'slug' => 'skincare', 'icon' => 'skincare'],
            ['name_ar' => 'مستحضرات التجميل', 'slug' => 'makeup', 'icon' => 'makeup'],
            ['name_ar' => 'العطور', 'slug' => 'fragrance', 'icon' => 'fragrance'],
            ['name_ar' => 'العناية بالشعر', 'slug' => 'haircare', 'icon' => 'haircare'],
        ];
        foreach ($categories as $c) {
            Category::create(array_merge($c, ['is_active' => true, 'sort_order' => Category::count() + 1]));
        }

        Coupon::create([
            'code' => 'ترحيب10',
            'description_ar' => 'خصم 10% للطلب الأول',
            'type' => 'percent',
            'value' => 10,
            'min_order_amount' => 50000,
            'usage_limit' => 1000,
            'is_active' => true,
        ]);

        for ($i = 1; $i <= 3; $i++) {
            Banner::create([
                'title_ar' => 'عرض خاص ' . $i,
                'image' => "banners/banner-{$i}.jpg",
                'link' => null,
                'sort_order' => $i,
                'is_active' => true,
            ]);
        }

        $categoryIds = Category::pluck('id')->all();
        for ($i = 1; $i <= 12; $i++) {
            $p = Product::create([
                'name_ar' => 'منتج تجميل فاخر ' . $i,
                'slug' => 'product-' . $i . '-' . Str::random(4),
                'description_ar' => 'وصف المنتج الفاخر. جودة عالية وأناقة.',
                'sku' => 'SKU-' . str_pad($i, 5, '0', STR_PAD_LEFT),
                'price' => rand(25000, 150000),
                'compare_at_price' => rand(30000, 180000),
                'discount_percent' => rand(0, 1) ? rand(5, 25) : 0,
                'category_id' => $categoryIds[array_rand($categoryIds)],
                'is_featured' => $i <= 4,
                'is_active' => true,
                'sort_order' => $i,
            ]);
            ProductImage::create([
                'product_id' => $p->id,
                'path' => 'products/placeholder.png',
                'sort_order' => 0,
                'is_primary' => true,
            ]);
            Inventory::create([
                'product_id' => $p->id,
                'quantity' => rand(5, 100),
                'low_stock_threshold' => 5,
            ]);
        }
    }
}
