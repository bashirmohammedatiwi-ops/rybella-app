<?php

namespace App\Services;

use App\Models\DiscountRule;
use App\Models\Product;

class DiscountService
{
    public static function getBestRuleForProduct(Product $product): ?DiscountRule
    {
        $product->load('category', 'brand');
        $productId = $product->id;
        $categoryId = $product->category_id;
        $brandId = $product->brand_id;

        return DiscountRule::where('is_active', true)
            ->where(function ($q) use ($productId, $categoryId, $brandId) {
                $q->where(function ($sub) use ($productId) {
                    $sub->where('scope_type', 'product')->where('scope_id', $productId);
                })
                ->orWhere(function ($sub) use ($categoryId) {
                    $sub->where('scope_type', 'category')->where('scope_id', $categoryId);
                })
                ->orWhere(function ($sub) use ($brandId) {
                    $sub->where('scope_type', 'brand')->where('scope_id', $brandId);
                });
            })
            ->where(function ($q) {
                $now = now();
                $q->whereNull('starts_at')->orWhere('starts_at', '<=', $now);
            })
            ->where(function ($q) {
                $now = now();
                $q->whereNull('ends_at')->orWhere('ends_at', '>=', $now);
            })
            ->orderBy('sort_order')
            ->orderByDesc('value')
            ->first();
    }
}
