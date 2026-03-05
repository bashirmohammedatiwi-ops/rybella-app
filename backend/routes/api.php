<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BannerController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CouponController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\WishlistController;
use Illuminate\Support\Facades\Route;

// Auth
Route::prefix('v1')->group(function () {
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login', [AuthController::class, 'login']);
});

// Guest API - optional auth (user set when Bearer token provided)
Route::prefix('v1')->middleware('auth.optional')->group(function () {
    Route::get('storage/{path}', [\App\Http\Controllers\Api\StorageController::class, 'show'])->where('path', '.*');

    Route::get('banners', [BannerController::class, 'index']);
    Route::get('brands', [\App\Http\Controllers\Api\BrandController::class, 'index']);
    Route::get('categories', [CategoryController::class, 'index']);
    Route::get('categories/{slug}', [CategoryController::class, 'show']);

    Route::get('products', [ProductController::class, 'index']);
    Route::get('products/featured', [ProductController::class, 'featured']);
    Route::get('products/best-sellers', [ProductController::class, 'bestSellers']);
    Route::get('products/{slug}', [ProductController::class, 'show']);

    Route::post('orders', [OrderController::class, 'store']);
    Route::get('orders/track', [OrderController::class, 'trackByPhone']);
    Route::get('orders/{orderNumber}', [OrderController::class, 'showByNumber']);

    Route::get('wishlist', [WishlistController::class, 'index']);
    Route::post('wishlist', [WishlistController::class, 'store']);
    Route::delete('wishlist/{productId}', [WishlistController::class, 'destroy']);

    Route::post('coupons/validate', [CouponController::class, 'validateCoupon']);
});

// Auth required
Route::prefix('v1')->middleware('auth:sanctum')->group(function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);
    Route::get('auth/me', [AuthController::class, 'me']);
    Route::get('orders/my', [OrderController::class, 'myOrders']);
});
