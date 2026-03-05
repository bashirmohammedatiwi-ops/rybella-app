<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use Illuminate\Http\JsonResponse;

class BrandController extends Controller
{
    public function index(): JsonResponse
    {
        $brands = Brand::where('is_active', true)
            ->orderBy('sort_order')
            ->orderBy('name_ar')
            ->get(['id', 'name_ar', 'slug', 'image']);
        $data = $brands->map(fn ($b) => [
            'id' => $b->id,
            'name_ar' => $b->name_ar,
            'slug' => $b->slug,
            'image' => $b->image ? asset('storage/' . $b->image) : null,
        ])->values()->all();
        return response()->json(['data' => $data]);
    }
}
