<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Coupon extends Model
{
    protected $fillable = [
        'code', 'description_ar', 'type', 'value',
        'min_order_amount', 'usage_limit', 'used_count',
        'starts_at', 'ends_at', 'is_active',
    ];

    protected $casts = [
        'value' => 'decimal:2',
        'min_order_amount' => 'decimal:0',
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    public function isValidForAmount(float $orderAmount): bool
    {
        if (!$this->is_active) {
            return false;
        }
        if ($this->starts_at && Carbon::now()->lt($this->starts_at)) {
            return false;
        }
        if ($this->ends_at && Carbon::now()->gt($this->ends_at)) {
            return false;
        }
        if ($this->usage_limit !== null && $this->used_count >= $this->usage_limit) {
            return false;
        }
        if ($this->min_order_amount !== null && $orderAmount < $this->min_order_amount) {
            return false;
        }
        return true;
    }

    public function discountAmount(float $subtotal): float
    {
        if ($this->type === 'percent') {
            return round($subtotal * ($this->value / 100));
        }
        return min((float) $this->value, $subtotal);
    }
}
