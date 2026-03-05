import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/data/repositories/order_repository.dart';

class CartItem {
  final ProductModel product;
  final ProductColorModel? selectedColor;
  int quantity;

  CartItem({required this.product, this.selectedColor, this.quantity = 1});

  int get total => product.finalPrice * quantity;

  String get variantDisplay => selectedColor != null ? 'اللون: ${selectedColor!.nameAr}' : '';

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'selected_color': selectedColor?.toJson(),
      };

  static CartItem fromJson(Map<String, dynamic> json) {
    final sc = json['selected_color'];
    return CartItem(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedColor: sc != null ? ProductColorModel.fromJson(sc as Map<String, dynamic>) : null,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  static const _cartKey = 'cosmatic_cart';

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, e) => sum + e.quantity);

  int get totalAmount => _items.fold(0, (sum, e) => sum + e.total);

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cartKey);
      if (json != null) {
        final list = jsonDecode(json) as List<dynamic>? ?? [];
        _items.clear();
        for (final e in list) {
          _items.add(CartItem.fromJson(e as Map<String, dynamic>));
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _items.map((e) => e.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(list));
    } catch (_) {}
  }

  void add(ProductModel product, {ProductColorModel? selectedColor, int quantity = 1}) {
    final productId = product.id;
    final colorId = selectedColor?.id;
    final i = _items.indexWhere((e) {
      if (e.product.id != productId) return false;
      final ec = e.selectedColor?.id;
      return ec == colorId;
    });
    if (i >= 0) {
      _items[i].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, selectedColor: selectedColor, quantity: quantity));
    }
    _saveToStorage();
    notifyListeners();
  }

  void setQuantity(int productId, int quantity, {int? colorId}) {
    if (quantity <= 0) {
      remove(productId, colorId: colorId);
      return;
    }
    final i = _items.indexWhere((e) {
      if (e.product.id != productId) return false;
      final ec = e.selectedColor?.id;
      return ec == colorId;
    });
    if (i >= 0) {
      _items[i].quantity = quantity;
      _saveToStorage();
      notifyListeners();
    }
  }

  void remove(int productId, {int? colorId}) {
    _items.removeWhere((e) {
      if (e.product.id != productId) return false;
      final ec = e.selectedColor?.id;
      return ec == colorId;
    });
    _saveToStorage();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveToStorage();
    notifyListeners();
  }

  List<OrderItemRequest> toOrderItems() {
    return _items.map((e) {
      final barcode = e.selectedColor?.barcode ?? e.product.barcode;
      return OrderItemRequest(
        productId: e.product.id,
        productNameAr: e.product.nameAr,
        variantDisplay: e.variantDisplay.isNotEmpty ? e.variantDisplay : null,
        barcode: barcode,
        unitPrice: e.product.finalPrice,
        quantity: e.quantity,
      );
    }).toList();
  }
}
