<?php

namespace App\Repositories;

use App\Models\Product;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Collection;

class ProductRepository
{
    public function getFeatured(int $limit = 10): Collection
    {
        return Product::with(['images', 'category', 'brand', 'colors'])
            ->where('is_active', true)
            ->where('is_featured', true)
            ->orderBy('sort_order')
            ->limit($limit)
            ->get();
    }

    public function getBestSellers(int $limit = 10): Collection
    {
        return Product::with(['images', 'category', 'brand', 'colors'])
            ->where('is_active', true)
            ->withCount(['orderItems as orders_count' => function ($q) {
                $q->whereHas('order', fn ($o) => $o->whereIn('status', ['delivered', 'shipped', 'processing']));
            }])
            ->orderByDesc('orders_count')
            ->limit($limit)
            ->get();
    }

    public function listForApi(array $filters = [], int $perPage = 20): LengthAwarePaginator
    {
        $query = Product::with(['images', 'category', 'brand', 'colors'])->where('is_active', true);

        if (!empty($filters['category_id'])) {
            $query->where('category_id', $filters['category_id']);
        }

        if (!empty($filters['brand_id'])) {
            $query->where('brand_id', $filters['brand_id']);
        }

        if (!empty($filters['search'])) {
            $term = $filters['search'];
            $query->where(function ($q) use ($term) {
                $q->where('name_ar', 'like', "%{$term}%")
                    ->orWhere('description_ar', 'like', "%{$term}%")
                    ->orWhere('sku', 'like', "%{$term}%");
            });
        }

        if (isset($filters['min_price'])) {
            $query->where('price', '>=', $filters['min_price']);
        }
        if (isset($filters['max_price'])) {
            $query->where('price', '<=', $filters['max_price']);
        }

        $sort = $filters['sort'] ?? 'newest';
        switch ($sort) {
            case 'price_asc': $query->orderBy('price'); break;
            case 'price_desc': $query->orderByDesc('price'); break;
            case 'name': $query->orderBy('name_ar'); break;
            default: $query->orderByDesc('created_at'); break;
        }

        return $query->paginate($perPage);
    }

    public function findBySlug(string $slug): ?Product
    {
        return Product::with(['images', 'category', 'brand', 'colors'])->where('slug', $slug)->first();
    }

    public function getRelated(Product $product, int $limit = 4): Collection
    {
        return Product::with(['images', 'colors'])
            ->where('is_active', true)
            ->where('id', '!=', $product->id)
            ->where('category_id', $product->category_id)
            ->limit($limit)
            ->get();
    }
}
