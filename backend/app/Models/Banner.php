<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Banner extends Model
{
    protected $fillable = ['title_ar', 'image', 'link', 'sort_order', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];
}
