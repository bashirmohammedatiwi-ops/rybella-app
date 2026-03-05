<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DiscountRule extends Model
{
    protected $fillable = [
        'name_ar', 'scope_type', 'scope_id', 'discount_type', 'value',
        'starts_at', 'ends_at', 'is_active', 'sort_order',
    ];

    protected $casts = [
        'value' => 'decimal:2',
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    public const SCOPE_PRODUCT = 'product';
    public const SCOPE_CATEGORY = 'category';
    public const SCOPE_BRAND = 'brand';

    public const TYPE_PERCENT = 'percent';
    public const TYPE_FIXED = 'fixed';

    public function isActive(): bool
    {
        if (!$this->is_active) {
            return false;
        }
        $now = now();
        if ($this->starts_at && $now->lt($this->starts_at)) {
            return false;
        }
        if ($this->ends_at && $now->gt($this->ends_at)) {
            return false;
        }
        return true;
    }

    public function appliesTo(?int $productId, ?int $categoryId, ?int $brandId): bool
    {
        switch ($this->scope_type) {
            case self::SCOPE_PRODUCT: return $this->scope_id && $this->scope_id == $productId;
            case self::SCOPE_CATEGORY: return $this->scope_id && $this->scope_id == $categoryId;
            case self::SCOPE_BRAND: return $this->scope_id && $this->scope_id == $brandId;
            default: return false;
        }
    }

    public function discountAmount(float $price): float
    {
        if ($this->discount_type === self::TYPE_PERCENT) {
            return round($price * ((float) $this->value / 100));
        }
        return min((float) $this->value, $price);
    }
}
