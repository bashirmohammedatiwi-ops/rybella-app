class ProductColorModel {
  final int id;
  final String nameAr;
  final String? hexCode;
  final String? barcode;
  final String? image;

  ProductColorModel({
    required this.id,
    required this.nameAr,
    this.hexCode,
    this.barcode,
    this.image,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) {
    return ProductColorModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      hexCode: json['hex_code'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'hex_code': hexCode,
        'barcode': barcode,
        'image': image,
      };
}

class ProductModel {
  final int id;
  final String nameAr;
  final String slug;
  final String? descriptionAr;
  final String? sku;
  final String? barcode;
  final int price;
  final int? compareAtPrice;
  final int discountPercent;
  final int finalPrice;
  final String? image;
  final List<String> images;
  final CategoryRef? category;
  final bool inStock;
  final int stockQuantity;
  final List<ProductColorModel> colors;

  ProductModel({
    required this.id,
    required this.nameAr,
    required this.slug,
    this.descriptionAr,
    this.sku,
    this.barcode,
    required this.price,
    this.compareAtPrice,
    required this.discountPercent,
    required this.finalPrice,
    this.image,
    this.images = const [],
    this.category,
    this.inStock = true,
    this.stockQuantity = 0,
    this.colors = const [],
  });

  bool get hasColors => colors.isNotEmpty;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imgs = json['images'] as List<dynamic>?;
    final colorsList = json['colors'] as List<dynamic>?;
    return ProductModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      descriptionAr: json['description_ar'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      price: (json['price'] as num).toInt(),
      compareAtPrice: json['compare_at_price'] != null ? (json['compare_at_price'] as num).toInt() : null,
      discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
      finalPrice: (json['final_price'] as num).toInt(),
      image: json['image'] as String?,
      images: imgs?.map((e) => e as String).toList() ?? [],
      category: json['category'] != null ? CategoryRef.fromJson(json['category'] as Map<String, dynamic>) : null,
      inStock: json['in_stock'] as bool? ?? true,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      colors: colorsList?.map((e) => ProductColorModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'slug': slug,
      'description_ar': descriptionAr,
      'sku': sku,
      'barcode': barcode,
      'price': price,
      'compare_at_price': compareAtPrice,
      'discount_percent': discountPercent,
      'final_price': finalPrice,
      'image': image,
      'images': images,
      'category': category?.toJson(),
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
      'colors': colors.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryRef {
  final int id;
  final String nameAr;

  CategoryRef({required this.id, required this.nameAr});

  factory CategoryRef.fromJson(Map<String, dynamic> json) {
    return CategoryRef(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name_ar': nameAr};
}
