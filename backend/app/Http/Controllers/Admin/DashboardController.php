<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class DashboardController extends Controller
{
    public function index()
    {
        try {
            $today = now()->toDateString();
            $totalSales = (int) Order::whereIn('status', ['delivered', 'shipped', 'processing'])->sum('total');
            $ordersToday = Order::whereDate('created_at', $today)->count();
            $revenueToday = (int) Order::whereDate('created_at', $today)->whereIn('status', ['delivered', 'shipped', 'processing'])->sum('total');

            $lowStock = Product::whereHas('inventory', fn ($q) => $q->whereRaw('inventory.quantity <= inventory.low_stock_threshold'))->count();

            $bestSellers = OrderItem::query()
                ->join('orders', 'orders.id', '=', 'order_items.order_id')
                ->whereIn('orders.status', ['delivered', 'shipped', 'processing'])
                ->select('order_items.product_id', 'order_items.product_name_ar', DB::raw('SUM(order_items.quantity) as total_qty'))
                ->groupBy('order_items.product_id', 'order_items.product_name_ar')
                ->orderByDesc('total_qty')
                ->limit(5)
                ->get();

            $recentOrders = Order::with('items')->orderByDesc('created_at')->limit(10)->get();
        } catch (\Throwable $e) {
            Log::error('Dashboard error: ' . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
            $totalSales = $ordersToday = $revenueToday = $lowStock = 0;
            $bestSellers = collect();
            $recentOrders = collect();
        }

        return view('admin.dashboard', compact(
            'totalSales', 'ordersToday', 'revenueToday', 'lowStock', 'bestSellers', 'recentOrders'
        ));
    }
}
