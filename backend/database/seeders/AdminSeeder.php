<?php

namespace Database\Seeders;

use App\Models\AdminUser;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        if (AdminUser::count() > 0) {
            return;
        }
        AdminUser::create([
            'name' => 'مدير النظام',
            'email' => 'admin@rybella.com',
            'password' => bcrypt('Admin@123'),
        ]);
    }
}
