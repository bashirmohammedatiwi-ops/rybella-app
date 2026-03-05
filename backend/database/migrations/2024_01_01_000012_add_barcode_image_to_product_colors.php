<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('product_colors', function (Blueprint $table) {
            $table->string('barcode', 100)->nullable()->after('hex_code');
            $table->string('image', 255)->nullable()->after('barcode');
        });
    }

    public function down(): void
    {
        Schema::table('product_colors', function (Blueprint $table) {
            $table->dropColumn(['barcode', 'image']);
        });
    }
};
