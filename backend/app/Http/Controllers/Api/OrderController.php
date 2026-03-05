<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Repositories\OrderRepository;
use App\Services\OrderService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function __construct(
        private OrderService $orderService,
        private OrderRepository $orderRepo
    ) {}

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'customer_name' => 'required|string|max:255',
            'customer_phone' => 'required|string|max:50',
            'delivery_address' => 'required|string',
            'city' => 'nullable|string|max:100',
            'notes' => 'nullable|string|max:500',
            'coupon_code' => 'nullable|string|max:50',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.product_name_ar' => 'required|string',
            'items.*.variant_display' => 'nullable|string|max:255',
            'items.*.barcode' => 'nullable|string|max:100',
            'items.*.unit_price' => 'required|numeric|min:0',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'بيانات غير صالحة', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $data['user_id'] = $request->user()?->id;
        $order = $this->orderService->placeOrder($data);
        return response()->json([
            'message' => 'تم إنشاء الطلب بنجاح',
            'data' => [
                'id' => $order->id,
                'order_number' => $order->order_number,
                'total' => (int) $order->total,
                'status' => $order->status,
            ],
        ], 201);
    }

    public function trackByPhone(Request $request): JsonResponse
    {
        $phone = $request->get('phone');
        if (!$phone) {
            return response()->json(['message' => 'رقم الهاتف مطلوب'], 422);
        }
        $orders = $this->orderRepo->findByPhone($phone);
        $statusLabels = \App\Models\Order::statusLabelsAr();
        $data = $orders->map(fn ($o) => [
            'id' => $o->id,
            'order_number' => $o->order_number,
            'total' => (int) $o->total,
            'status' => $o->status,
            'status_label_ar' => $statusLabels[$o->status] ?? $o->status,
            'created_at' => $o->created_at->toIso8601String(),
            'items_count' => $o->items->count(),
        ])->values()->all();
        return response()->json(['data' => $data]);
    }

    public function myOrders(Request $request): JsonResponse
    {
        $orders = $this->orderRepo->findByUserId($request->user()->id);
        $statusLabels = \App\Models\Order::statusLabelsAr();
        $data = $orders->map(fn ($o) => [
            'id' => $o->id,
            'order_number' => $o->order_number,
            'total' => (int) $o->total,
            'status' => $o->status,
            'status_label_ar' => $statusLabels[$o->status] ?? $o->status,
            'created_at' => $o->created_at->toIso8601String(),
            'items_count' => $o->items->count(),
        ])->values()->all();
        return response()->json(['data' => $data]);
    }

    public function showByNumber(string $orderNumber): JsonResponse
    {
        $order = $this->orderRepo->findByOrderNumber($orderNumber);
        if (!$order) {
            return response()->json(['message' => 'الطلب غير موجود'], 404);
        }
        $statusLabels = \App\Models\Order::statusLabelsAr();
        return response()->json([
            'data' => [
                'id' => $order->id,
                'order_number' => $order->order_number,
                'customer_name' => $order->customer_name,
                'customer_phone' => $order->customer_phone,
                'delivery_address' => $order->delivery_address,
                'city' => $order->city,
                'subtotal' => (int) $order->subtotal,
                'discount' => (int) $order->discount,
                'total' => (int) $order->total,
                'status' => $order->status,
                'status_label_ar' => $statusLabels[$order->status] ?? $order->status,
                'created_at' => $order->created_at->toIso8601String(),
                'items' => $order->items->map(fn ($i) => [
                    'product_name_ar' => $i->product_name_ar,
                    'variant_display' => $i->variant_display,
                    'unit_price' => (int) $i->unit_price,
                    'quantity' => $i->quantity,
                    'total' => (int) $i->total,
                    'image' => $i->product->primaryImage ? asset('storage/' . $i->product->primaryImage->path) : null,
                ])->values()->all(),
            ],
        ]);
    }
}
