<?php
/**
 * إنشاء قاعدة البيانات cosmatic
 * نفّذ: php create_db.php
 */
$host = '127.0.0.1';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host", $user, $pass);
    $pdo->exec("CREATE DATABASE IF NOT EXISTS cosmatic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "تم إنشاء قاعدة البيانات cosmatic بنجاح.\n";
} catch (PDOException $e) {
    echo "خطأ: " . $e->getMessage() . "\n";
    echo "تأكد من تشغيل MySQL في XAMPP.\n";
    exit(1);
}
