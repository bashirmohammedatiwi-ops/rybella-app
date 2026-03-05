<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $query = Order::with('items');
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }
        if ($request->filled('phone')) {
            $query->where('customer_phone', 'like', '%' . $request->phone . '%');
        }
        $orders = $query->orderByDesc('created_at')->paginate(20);
        return view('admin.orders.index', compact('orders'));
    }

    public function show(Order $order)
    {
        $order->load('items.product');
        return view('admin.orders.show', compact('order'));
    }

    public function updateStatus(Request $request, Order $order)
    {
        $request->validate(['status' => 'required|in:pending,processing,shipped,delivered,cancelled']);
        $order->update(['status' => $request->status]);
        return back()->with('success', 'تم تحديث حالة الطلب');
    }
}
