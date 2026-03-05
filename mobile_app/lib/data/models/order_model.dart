class OrderModel {
  final int id;
  final String orderNumber;
  final int total;
  final String status;
  final String? statusLabelAr;
  final String createdAt;
  final int itemsCount;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.total,
    required this.status,
    this.statusLabelAr,
    required this.createdAt,
    this.itemsCount = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      total: (json['total'] as num).toInt(),
      status: json['status'] as String,
      statusLabelAr: json['status_label_ar'] as String?,
      createdAt: json['created_at'] as String,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class OrderDetailModel {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? city;
  final int subtotal;
  final int discount;
  final int total;
  final String status;
  final String? statusLabelAr;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.city,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    this.statusLabelAr,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final itemsList = data['items'] as List<dynamic>? ?? [];
    return OrderDetailModel(
      id: data['id'] as int,
      orderNumber: data['order_number'] as String,
      customerName: data['customer_name'] as String,
      customerPhone: data['customer_phone'] as String,
      deliveryAddress: data['delivery_address'] as String,
      city: data['city'] as String?,
      subtotal: (data['subtotal'] as num).toInt(),
      discount: (data['discount'] as num?)?.toInt() ?? 0,
      total: (data['total'] as num).toInt(),
      status: data['status'] as String,
      statusLabelAr: data['status_label_ar'] as String?,
      createdAt: data['created_at'] as String,
      items: itemsList.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class OrderItemModel {
  final String productNameAr;
  final String? variantDisplay;
  final int unitPrice;
  final int quantity;
  final int total;
  final String? image;

  OrderItemModel({
    required this.productNameAr,
    this.variantDisplay,
    required this.unitPrice,
    required this.quantity,
    required this.total,
    this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productNameAr: json['product_name_ar'] as String,
      variantDisplay: json['variant_display'] as String?,
      unitPrice: (json['unit_price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      image: json['image'] as String?,
    );
  }
}
