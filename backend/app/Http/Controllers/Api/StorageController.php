<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class StorageController extends Controller
{
    /**
     * Serve storage files with CORS headers for Flutter web.
     */
    public function show(Request $request, string $path): BinaryFileResponse|\Illuminate\Http\JsonResponse
    {
        $fullPath = storage_path('app/public/' . $path);
        if (!File::exists($fullPath) || !File::isFile($fullPath)) {
            return response()->json(['error' => 'Not found'], 404);
        }
        $response = response()->file($fullPath);
        $response->headers->set('Access-Control-Allow-Origin', '*');
        return $response;
    }
}
