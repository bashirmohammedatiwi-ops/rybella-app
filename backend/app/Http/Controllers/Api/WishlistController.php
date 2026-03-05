<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Wishlist;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class WishlistController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $deviceId = $request->header('X-Device-ID') ?? $request->get('device_id');
        if (!$deviceId) {
            return response()->json(['data' => []]);
        }
        $wishlists = Wishlist::with('product.images')
            ->where('device_id', $deviceId)
            ->get();
        $products = $wishlists->map(fn ($w) => $w->product)->filter()->values();
        $formatted = $products->map(function ($p) {
            $primary = $p->primaryImage;
            return [
                'id' => $p->id,
                'name_ar' => $p->name_ar,
                'slug' => $p->slug,
                'price' => (int) $p->price,
                'final_price' => (int) $p->final_price,
                'discount_percent' => $p->discount_percent,
                'image' => $primary ? asset('storage/' . $primary->path) : null,
            ];
        })->all();
        return response()->json(['data' => $formatted]);
    }

    public function store(Request $request): JsonResponse
    {
        $deviceId = $request->header('X-Device-ID') ?? $request->get('device_id');
        $productId = $request->get('product_id');
        if (!$deviceId || !$productId) {
            return response()->json(['message' => 'معرف الجهاز والمنتج مطلوبان'], 422);
        }
        if (!Product::where('id', $productId)->exists()) {
            return response()->json(['message' => 'المنتج غير موجود'], 404);
        }
        Wishlist::firstOrCreate(
            ['device_id' => $deviceId, 'product_id' => $productId]
        );
        return response()->json(['message' => 'تمت الإضافة للمفضلة']);
    }

    public function destroy(Request $request, int $productId): JsonResponse
    {
        $deviceId = $request->header('X-Device-ID') ?? $request->get('device_id');
        if (!$deviceId) {
            return response()->json(['message' => 'معرف الجهاز مطلوب'], 422);
        }
        Wishlist::where('device_id', $deviceId)->where('product_id', $productId)->delete();
        return response()->json(['message' => 'تم الحذف من المفضلة']);
    }
}
