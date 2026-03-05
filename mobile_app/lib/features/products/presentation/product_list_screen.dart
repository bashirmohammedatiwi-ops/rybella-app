import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/data/models/brand_model.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/data/repositories/product_repository.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/features/widgets/product_card.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatefulWidget {
  final int? categoryId;
  final int? brandId;
  final String categoryName;

  const ProductListScreen({super.key, this.categoryId, this.brandId, this.categoryName = 'المنتجات'});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _repo = ProductRepository();
  List<ProductModel> _list = [];
  List<BrandModel> _brands = [];
  int _page = 1;
  int _lastPage = 1;
  bool _loading = true;
  bool _loadingMore = false;
  String _sort = 'newest';
  int? _minPrice;
  int? _maxPrice;
  int? _brandId;

  @override
  void initState() {
    super.initState();
    _brandId = widget.brandId;
    _load();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await _repo.getBrands();
      if (mounted) setState(() => _brands = brands);
    } catch (_) {}
  }

  Future<void> _load({bool reset = true}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _page = 1;
      });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final res = await _repo.getProducts(
        categoryId: widget.categoryId,
        brandId: _brandId,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        sort: _sort,
        page: reset ? 1 : _page,
        perPage: 20,
      );
      final data = (res['data'] as List<ProductModel>?) ?? [];
      final lastPage = res['last_page'] as int;
      setState(() {
        if (reset) {
          _list = data;
        } else {
          _list.addAll(data);
        }
        _lastPage = lastPage;
        _page = reset ? 2 : _page + 1;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _loadingMore = false;
        if (reset) _list = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.pinkLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Column(
          children: [
            if (_brands.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space1),
                child: Row(
                  children: [
                    _Chip(label: 'كل البراندات', selected: _brandId == null, onTap: () { setState(() => _brandId = null); _load(); }),
                    ..._brands.map((b) => Padding(
                      padding: EdgeInsets.only(left: AppTheme.space2),
                      child: _Chip(
                        label: b.nameAr,
                        selected: _brandId == b.id,
                        onTap: () { setState(() => _brandId = b.id); _load(); },
                      ),
                    )),
                  ],
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space2),
              child: Row(
                children: [
                  _Chip(
                    label: 'الأحدث',
                    selected: _sort == 'newest',
                    onTap: () {
                      setState(() => _sort = 'newest');
                      _load();
                    },
                  ),
                  SizedBox(width: AppTheme.space2),
                  _Chip(
                    label: 'السعر: منخفض-عالي',
                    selected: _sort == 'price_asc',
                    onTap: () {
                      setState(() => _sort = 'price_asc');
                      _load();
                    },
                  ),
                  SizedBox(width: AppTheme.space2),
                  _Chip(
                    label: 'السعر: عالي-منخفض',
                    selected: _sort == 'price_desc',
                    onTap: () {
                      setState(() => _sort = 'price_desc');
                      _load();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _load(reset: true),
                color: AppColors.gold,
                child: _loading
                    ? const _GridShimmer()
                    : _list.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                              Center(child: Text('لا توجد منتجات', style: Theme.of(context).textTheme.bodyLarge)),
                            ],
                          )
                        : GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(AppTheme.space4),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _list.length + (_loadingMore ? 1 : 0) + (_page <= _lastPage && _list.isNotEmpty && !_loadingMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i == _list.length) {
                              if (_loadingMore) return Center(child: CircularProgressIndicator(color: AppColors.roseGold));
                              if (_page <= _lastPage) {
                                _load(reset: false);
                                return Center(child: CircularProgressIndicator(color: AppColors.roseGold));
                              }
                              return const SizedBox.shrink();
                            }
                            if (i > _list.length) return const SizedBox.shrink();
                            final p = _list[i];
                            return ProductCard(
                              product: p,
                              onTap: () => context.push('/products/${p.slug}'),
                              onAddCart: p.hasColors
                                  ? () => context.push('/products/${p.slug}')
                                  : () => context.read<CartProvider>().add(p),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: Theme.of(context).textTheme.labelMedium),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.peachLight,
      checkmarkColor: AppColors.gold,
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? AppColors.gold : AppColors.pinkLight),
    );
  }
}

class _GridShimmer extends StatelessWidget {
  const _GridShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.stone,
      highlightColor: Colors.white,
      child: GridView.builder(
        padding: EdgeInsets.all(AppTheme.space4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radiusMedium),
        ),
      ),
    );
  }
}
