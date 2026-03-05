<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    public function index(): JsonResponse
    {
        $categories = Category::with('children')
            ->whereNull('parent_id')
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->get(['id', 'name_ar', 'slug', 'image', 'icon', 'parent_id']);
        return response()->json(['data' => $categories]);
    }

    public function show(string $slug): JsonResponse
    {
        $category = Category::where('slug', $slug)->where('is_active', true)->first();
        if (!$category) {
            return response()->json(['message' => 'الفئة غير موجودة'], 404);
        }
        return response()->json(['data' => $category->load('children')]);
    }
}
