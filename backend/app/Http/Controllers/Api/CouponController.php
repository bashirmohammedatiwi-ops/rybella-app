<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Coupon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CouponController extends Controller
{
    public function validateCoupon(Request $request): JsonResponse
    {
        $code = $request->get('code');
        $subtotal = (float) $request->get('subtotal', 0);
        if (!$code) {
            return response()->json(['message' => 'رمز القسيمة مطلوب'], 422);
        }
        $coupon = Coupon::where('code', $code)->first();
        if (!$coupon) {
            return response()->json(['valid' => false, 'message' => 'القسيمة غير صالحة']);
        }
        if (!$coupon->isValidForAmount($subtotal)) {
            return response()->json(['valid' => false, 'message' => 'القسيمة غير صالحة أو انتهت صلاحيتها']);
        }
        $discount = $coupon->discountAmount($subtotal);
        return response()->json([
            'valid' => true,
            'message' => 'تم تطبيق القسيمة',
            'discount' => (int) $discount,
            'type' => $coupon->type,
            'value' => $coupon->value,
        ]);
    }
}
