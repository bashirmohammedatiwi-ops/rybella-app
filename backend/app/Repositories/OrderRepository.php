<?php

namespace App\Repositories;

use App\Models\Order;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Collection;

class OrderRepository
{
    public function create(array $data): Order
    {
        return Order::create($data);
    }

    public function findByPhone(string $phone): Collection
    {
        return Order::with('items.product.images')
            ->where('customer_phone', $phone)
            ->orderByDesc('created_at')
            ->get();
    }

    public function findByUserId(int $userId): Collection
    {
        return Order::with('items.product.images')
            ->where('user_id', $userId)
            ->orderByDesc('created_at')
            ->get();
    }

    public function findByOrderNumber(string $orderNumber): ?Order
    {
        return Order::with('items.product.images')->where('order_number', $orderNumber)->first();
    }

    public function listForAdmin(array $filters = [], int $perPage = 20): LengthAwarePaginator
    {
        $query = Order::with('items');

        if (!empty($filters['status'])) {
            $query->where('status', $filters['status']);
        }
        if (!empty($filters['phone'])) {
            $query->where('customer_phone', 'like', '%' . $filters['phone'] . '%');
        }

        return $query->orderByDesc('created_at')->paginate($perPage);
    }
}
