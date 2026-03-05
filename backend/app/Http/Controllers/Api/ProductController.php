<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Repositories\ProductRepository;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function __construct(
        private ProductRepository $productRepo
    ) {}

    public function index(Request $request): JsonResponse
    {
        $filters = [
            'category_id' => $request->get('category_id'),
            'brand_id' => $request->get('brand_id'),
            'min_price' => $request->get('min_price'),
            'max_price' => $request->get('max_price'),
            'sort' => $request->get('sort', 'newest'),
            'search' => $request->get('q'),
        ];
        $paginated = $this->productRepo->listForApi($filters, (int) $request->get('per_page', 20));
        $paginated->getCollection()->transform(fn ($p) => $this->formatProduct($p));
        return response()->json($paginated);
    }

    public function featured(): JsonResponse
    {
        $products = $this->productRepo->getFeatured(10);
        return response()->json(['data' => $this->formatProducts($products)]);
    }

    public function bestSellers(): JsonResponse
    {
        $products = $this->productRepo->getBestSellers(10);
        return response()->json(['data' => $this->formatProducts($products)]);
    }

    public function show(string $slug): JsonResponse
    {
        $product = $this->productRepo->findBySlug($slug);
        if (!$product) {
            return response()->json(['message' => 'المنتج غير موجود'], 404);
        }
        $related = $this->productRepo->getRelated($product, 4);
        return response()->json([
            'data' => $this->formatProductDetail($product),
            'related' => $this->formatProducts($related),
        ]);
    }

    private function formatProducts($products): array
    {
        return $products->map(fn ($p) => $this->formatProduct($p))->values()->all();
    }

    private function formatProduct($p): array
    {
        $primary = $p->primaryImage;
        return [
            'id' => $p->id,
            'name_ar' => $p->name_ar,
            'slug' => $p->slug,
            'barcode' => $p->barcode,
            'price' => (int) $p->price,
            'compare_at_price' => $p->compare_at_price ? (int) $p->compare_at_price : null,
            'discount_percent' => $p->discount_percent,
            'final_price' => (int) $p->final_price,
            'image' => $primary ? asset('storage/' . $primary->path) : null,
            'images' => $p->images->map(fn ($i) => asset('storage/' . $i->path))->values()->all(),
            'category' => $p->category ? ['id' => $p->category->id, 'name_ar' => $p->category->name_ar] : null,
            'brand' => $p->brand ? ['id' => $p->brand->id, 'name_ar' => $p->brand->name_ar] : null,
            'in_stock' => $p->stock_quantity > 0,
            'stock_quantity' => $p->stock_quantity,
            'colors' => $p->colors->map(fn ($c) => [
                'id' => $c->id,
                'name_ar' => $c->name_ar,
                'hex_code' => $c->hex_code,
                'barcode' => $c->barcode,
                'image' => $c->image ? asset('storage/' . $c->image) : null,
            ])->values()->all(),
        ];
    }

    private function formatProductDetail($p): array
    {
        $base = $this->formatProduct($p);
        $base['description_ar'] = $p->description_ar;
        $base['sku'] = $p->sku;
        $base['barcode'] = $p->barcode;
        return $base;
    }
}
