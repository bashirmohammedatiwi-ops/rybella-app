import 'package:flutter/foundation.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/core/network/api_client.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  String? _deviceId;
  static const _keyDeviceId = 'cosmatic_device_id';

  List<ProductModel> get items => List.unmodifiable(_items);

  Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString(_keyDeviceId);
    if (_deviceId == null || _deviceId!.isEmpty) {
      _deviceId = DateTime.now().millisecondsSinceEpoch.toString() + _randomHex(8);
      await prefs.setString(_keyDeviceId, _deviceId!);
    }
    return _deviceId!;
  }

  String _randomHex(int length) {
    const chars = '0123456789abcdef';
    return List.generate(length, (_) => chars[(DateTime.now().microsecondsSinceEpoch % 16)]).join();
  }

  Future<void> load() async {
    try {
      final deviceId = await _getDeviceId();
      final res = await ApiClient().get(ApiConstants.wishlist, headers: {'X-Device-ID': deviceId});
      final list = (res['data'] as List<dynamic>?) ?? [];
      _items.clear();
      _items.addAll(list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)));
      notifyListeners();
    } catch (_) {
      _items.clear();
      notifyListeners();
    }
  }

  Future<void> add(int productId) async {
    try {
      final deviceId = await _getDeviceId();
      await ApiClient().post(ApiConstants.wishlist, body: {'product_id': productId}, headers: {'X-Device-ID': deviceId});
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> remove(int productId) async {
    try {
      final deviceId = await _getDeviceId();
      await ApiClient().delete('${ApiConstants.wishlist}/$productId', headers: {'X-Device-ID': deviceId});
      _items.removeWhere((e) => e.id == productId);
      notifyListeners();
    } catch (_) {}
  }

  bool has(int productId) => _items.any((e) => e.id == productId);

  Future<void> toggle(int productId) async {
    if (has(productId)) {
      await remove(productId);
    } else {
      await add(productId);
    }
  }
}
