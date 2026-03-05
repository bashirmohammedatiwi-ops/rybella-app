<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    protected $table = 'notifications';

    protected $fillable = ['title_ar', 'body_ar', 'target', 'sent_at'];

    protected $casts = ['sent_at' => 'datetime'];
}
