<?php

return [
    'defaults' => [
        'guard' => 'web',
        'passwords' => 'users',
    ],
    'guards' => [
        'web' => [
            'driver' => 'session',
            'provider' => 'admin',
        ],
        'api' => [
            'driver' => 'sanctum',
            'provider' => 'customer_users',
        ],
    ],
    'providers' => [
        'admin' => [
            'driver' => 'eloquent',
            'model' => App\Models\AdminUser::class,
        ],
        'customer_users' => [
            'driver' => 'eloquent',
            'model' => App\Models\User::class,
        ],
    ],
    'passwords' => [
        'users' => [
            'provider' => 'customer_users',
            'table' => 'password_resets',
            'expire' => 60,
        ],
    ],
];
