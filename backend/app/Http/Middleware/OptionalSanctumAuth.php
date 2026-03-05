<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class OptionalSanctumAuth
{
    public function handle(Request $request, Closure $next)
    {
        if ($request->bearerToken()) {
            $request->setUserResolver(function () use ($request) {
                return \Laravel\Sanctum\PersonalAccessToken::findToken($request->bearerToken())?->tokenable;
            });
        }
        return $next($request);
    }
}
