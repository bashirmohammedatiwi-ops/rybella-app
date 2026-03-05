import 'package:cosmatic_app/core/network/api_client.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:cosmatic_app/data/models/order_model.dart';

class OrderRepository {
  final _api = ApiClient();

  Future<PlaceOrderResult> placeOrder({
    String? token,
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    String? city,
    String? notes,
    String? couponCode,
    required List<OrderItemRequest> items,
  }) async {
    final body = {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      if (city != null && city.isNotEmpty) 'city': city,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      'items': items.map((e) => {
        'product_id': e.productId,
        'product_name_ar': e.productNameAr,
        if (e.variantDisplay != null && e.variantDisplay!.isNotEmpty) 'variant_display': e.variantDisplay,
        if (e.barcode != null && e.barcode!.isNotEmpty) 'barcode': e.barcode,
        'unit_price': e.unitPrice,
        'quantity': e.quantity,
      }).toList(),
    };
    final res = await _api.post(ApiConstants.orders, body: body, token: token);
    final d = res['data'] as Map<String, dynamic>;
    return PlaceOrderResult(
      id: d['id'] as int,
      orderNumber: d['order_number'] as String,
      total: (d['total'] as num).toInt(),
      status: d['status'] as String,
    );
  }

  Future<List<OrderModel>> getMyOrders(String token) async {
    final res = await _api.get(ApiConstants.ordersMy, token: token);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<OrderModel>> trackByPhone(String phone) async {
    final res = await _api.get('${ApiConstants.ordersTrack}?phone=${Uri.encodeComponent(phone)}');
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderDetailModel> getByOrderNumber(String orderNumber) async {
    final res = await _api.get('${ApiConstants.orders}/$orderNumber');
    return OrderDetailModel.fromJson(res);
  }
}

class OrderItemRequest {
  final int productId;
  final String productNameAr;
  final String? variantDisplay;
  final String? barcode;
  final int unitPrice;
  final int quantity;

  OrderItemRequest({
    required this.productId,
    required this.productNameAr,
    this.variantDisplay,
    this.barcode,
    required this.unitPrice,
    required this.quantity,
  });
}

class PlaceOrderResult {
  final int id;
  final String orderNumber;
  final int total;
  final String status;

  PlaceOrderResult({
    required this.id,
    required this.orderNumber,
    required this.total,
    required this.status,
  });
}
