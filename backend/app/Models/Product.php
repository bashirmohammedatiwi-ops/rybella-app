<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Product extends Model
{
    protected $fillable = [
        'name_ar', 'slug', 'description_ar', 'sku', 'barcode',
        'price', 'compare_at_price', 'discount_percent',
        'category_id', 'brand_id', 'is_featured', 'is_active', 'sort_order',
    ];

    protected $casts = [
        'price' => 'decimal:0',
        'compare_at_price' => 'decimal:0',
        'is_featured' => 'boolean',
        'is_active' => 'boolean',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(ProductImage::class)->orderBy('sort_order');
    }

    public function colors(): HasMany
    {
        return $this->hasMany(ProductColor::class)->orderBy('sort_order');
    }

    public function inventory(): HasMany
    {
        return $this->hasMany(Inventory::class);
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function getStockQuantityAttribute(): int
    {
        return (int) $this->inventory()->sum('quantity');
    }

    public function getFinalPriceAttribute(): float
    {
        $price = (float) $this->price;
        if ($this->discount_percent > 0) {
            $price = round($price * (1 - $this->discount_percent / 100));
        }
        $rule = \App\Services\DiscountService::getBestRuleForProduct($this);
        if ($rule) {
            $disc = $rule->discountAmount($price);
            $price = max(0, round($price - $disc));
        }
        return (float) $price;
    }

    public function getPrimaryImageAttribute(): ?ProductImage
    {
        return $this->images()->where('is_primary', true)->first()
            ?? $this->images()->first();
    }
}
