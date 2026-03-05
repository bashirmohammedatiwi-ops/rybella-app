<?php

namespace App\Services;

use App\Models\Coupon;
use App\Models\Order;
use App\Models\OrderItem;
use App\Repositories\OrderRepository;
use Illuminate\Support\Str;

class OrderService
{
    public function __construct(
        private OrderRepository $orderRepo
    ) {}

    public function placeOrder(array $data): Order
    {
        $orderNumber = 'COS-' . strtoupper(Str::random(8));
        $subtotal = 0;
        $items = [];

        foreach ($data['items'] as $item) {
            $unitPrice = (float) $item['unit_price'];
            $qty = (int) $item['quantity'];
            $total = round($unitPrice * $qty);
            $subtotal += $total;
            $items[] = [
                'product_id' => $item['product_id'],
                'product_name_ar' => $item['product_name_ar'],
                'variant_display' => $item['variant_display'] ?? null,
                'barcode' => $item['barcode'] ?? null,
                'unit_price' => $unitPrice,
                'quantity' => $qty,
                'total' => $total,
            ];
        }

        $discount = 0;
        $couponCode = $data['coupon_code'] ?? null;
        if ($couponCode) {
            $coupon = Coupon::where('code', $couponCode)->first();
            if ($coupon && $coupon->isValidForAmount($subtotal)) {
                $discount = $coupon->discountAmount($subtotal);
                $coupon->increment('used_count');
            }
        }

        $total = $subtotal - $discount;

        $order = $this->orderRepo->create([
            'order_number' => $orderNumber,
            'user_id' => $data['user_id'] ?? null,
            'customer_name' => $data['customer_name'],
            'customer_phone' => $data['customer_phone'],
            'delivery_address' => $data['delivery_address'],
            'city' => $data['city'] ?? null,
            'subtotal' => $subtotal,
            'discount' => $discount,
            'coupon_code' => $couponCode,
            'total' => $total,
            'status' => Order::STATUS_PENDING,
            'payment_method' => 'cod',
            'notes' => $data['notes'] ?? null,
        ]);

        foreach ($items as $item) {
            OrderItem::create([
                'order_id' => $order->id,
                'product_id' => $item['product_id'],
                'product_name_ar' => $item['product_name_ar'],
                'variant_display' => $item['variant_display'] ?? null,
                'barcode' => $item['barcode'] ?? null,
                'unit_price' => $item['unit_price'],
                'quantity' => $item['quantity'],
                'total' => $item['total'],
            ]);
        }

        return $order->load('items');
    }
}
