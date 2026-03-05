import 'package:cosmatic_app/core/network/api_client.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:cosmatic_app/data/models/brand_model.dart';
import 'package:cosmatic_app/data/models/product_model.dart';

class ProductRepository {
  final _api = ApiClient();

  Future<List<ProductModel>> getFeatured() async {
    final res = await _api.get(ApiConstants.productsFeatured);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ProductModel>> getBestSellers() async {
    final res = await _api.get(ApiConstants.productsBestSellers);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<BrandModel>> getBrands() async {
    final res = await _api.get(ApiConstants.brands);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => BrandModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> getProducts({
    int? categoryId,
    int? brandId,
    int? minPrice,
    int? maxPrice,
    String sort = 'newest',
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final q = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      'sort': sort,
    };
    if (categoryId != null) q['category_id'] = '$categoryId';
    if (brandId != null) q['brand_id'] = '$brandId';
    if (minPrice != null) q['min_price'] = '$minPrice';
    if (maxPrice != null) q['max_price'] = '$maxPrice';
    if (search != null && search.isNotEmpty) q['q'] = search;
    final path = '${ApiConstants.products}?${q.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
    final res = await _api.get(path);
    final data = res['data'] as List<dynamic>? ?? [];
    final list = data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    return {
      'data': list,
      'current_page': res['current_page'] ?? 1,
      'last_page': res['last_page'] ?? 1,
      'total': res['total'] ?? list.length,
    };
  }

  Future<ProductDetailResponse> getBySlug(String slug) async {
    final res = await _api.get('${ApiConstants.products}/$slug');
    final data = res['data'] as Map<String, dynamic>;
    final related = (res['related'] as List<dynamic>?)?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    return ProductDetailResponse(
      product: ProductModel.fromJson(data),
      related: related,
    );
  }
}

class ProductDetailResponse {
  final ProductModel product;
  final List<ProductModel> related;

  ProductDetailResponse({required this.product, required this.related});
}
