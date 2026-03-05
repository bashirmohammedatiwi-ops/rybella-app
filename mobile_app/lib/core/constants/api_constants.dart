import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiConstants {
  /// غيّر إلى true عند التشغيل على هاتف فعلي (يحتاج نفس الـ Wi-Fi)
  static const bool _usePhysicalDevice = false;

  static const String _hostIpPhysical = '192.168.68.112';  // للهاتف الفعلي
  static const String _hostIpEmulator = '10.0.2.2';      // محاكي أندرويد
  static const String _hostIpLocal = '127.0.0.1';         // محاكي iOS أو ويب

  static String get _hostIp {
    if (_usePhysicalDevice) return _hostIpPhysical;
    if (kIsWeb) return _hostIpLocal;
    if (Platform.isAndroid) return _hostIpEmulator;
    return _hostIpLocal;
  }

  static String get baseUrl => 'http://$_hostIp:8000/api/v1';

  static String get storageBase =>
      baseUrl.replaceFirst(RegExp(r'/api/v1.*'), '');

  /// Images served via API with CORS for Flutter web compatibility.
  static String get storageApiBase => '$storageBase/api/v1/storage';

  static const String banners = '/banners';
  static const String brands = '/brands';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String productsFeatured = '/products/featured';
  static const String productsBestSellers = '/products/best-sellers';
  static const String orders = '/orders';
  static const String ordersMy = '/orders/my';
  static const String ordersTrack = '/orders/track';
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String wishlist = '/wishlist';
  static const String couponsValidate = '/coupons/validate';
}
