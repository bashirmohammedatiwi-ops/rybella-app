import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:cosmatic_app/core/utils/image_url.dart';
import 'package:cosmatic_app/core/utils/category_icons.dart';
import 'package:cosmatic_app/core/network/api_client.dart';
import 'package:cosmatic_app/data/models/banner_model.dart';
import 'package:cosmatic_app/data/models/brand_model.dart';
import 'package:cosmatic_app/data/models/category_model.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/data/repositories/product_repository.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/features/wishlist/presentation/wishlist_provider.dart';
import 'package:cosmatic_app/features/widgets/product_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productRepo = ProductRepository();
  final _api = ApiClient();
  final _bannerController = PageController(viewportFraction: 0.92);
  List<BannerModel> _banners = [];
  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  List<ProductModel> _featured = [];
  List<ProductModel> _bestSellers = [];
  bool _loading = true;
  String? _error;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _load({bool silentRefresh = false}) async {
    if (!silentRefresh) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final bannerRes = await _api.get(ApiConstants.banners);
      final catRes = await _api.get(ApiConstants.categories);
      final brandRes = await _api.get(ApiConstants.brands);
      final featured = await _productRepo.getFeatured();
      final best = await _productRepo.getBestSellers();
      final bannerList = (bannerRes['data'] as List<dynamic>?) ?? [];
      final catList = (catRes['data'] as List<dynamic>?) ?? [];
      final brandList = (brandRes['data'] as List<dynamic>?) ?? [];
      setState(() {
        _banners = bannerList.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
        _categories = catList.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
        _brands = brandList.map((e) => BrandModel.fromJson(e as Map<String, dynamic>)).toList();
        _featured = featured;
        _bestSellers = best;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
        if (!silentRefresh) {
          _banners = [];
          _categories = [];
          _brands = [];
          _featured = [];
          _bestSellers = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _buildPeachHeader(context),
          Expanded(
            child: Container(
              color: AppColors.surface,
              child: SafeArea(
                top: false,
                child: RefreshIndicator(
                  onRefresh: () => _load(silentRefresh: true),
                  color: AppColors.peach,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (_loading) ...[
                        const SliverToBoxAdapter(child: _HomeShimmer()),
                      ] else if (_error != null) ...[
                        SliverFillRemaining(
                          child: _buildError(context),
                        ),
                      ] else ...[
                        if (_banners.isNotEmpty) _buildBannerCarousel(context),
                        if (_categories.isNotEmpty) _buildCategories(context),
                        if (_brands.isNotEmpty) _buildBrands(context),
                        _buildSectionTitle(context, 'منتجات مميزة'),
                        _buildProductList(context, _featured),
                        _buildSectionTitle(context, 'الأكثر مبيعاً'),
                        _buildProductList(context, _bestSellers),
                        _buildViewAllButton(context),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPeachHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.peach.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppTheme.space4, AppTheme.space3, AppTheme.space4, AppTheme.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rybella Iraq',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: AppTheme.space1),
                      Text(
                        'لنجد أفضل المنتجات لك!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/wishlist'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      SizedBox(width: AppTheme.space2),
                      GestureDetector(
                        onTap: () => context.push('/cart'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                            ),
                            if (context.watch<CartProvider>().itemCount > 0)
                              Positioned(
                                top: -2,
                                left: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${context.watch<CartProvider>().itemCount}',
                                    style: TextStyle(
                                      color: AppColors.peach,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppTheme.space2),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppTheme.space4),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => context.push('/search'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space3),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                        SizedBox(width: AppTheme.space2),
                        Text(
                          'ابحث عن منتج',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.roseGoldGradient.createShader(bounds),
                  child: Text(
                    'Rybella Iraq',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
                SizedBox(height: AppTheme.space1),
                Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: AppColors.champagneGradient,
                    borderRadius: AppTheme.radiusPill,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _HeaderIcon(icon: Icons.search_rounded, onTap: () => context.push('/search')),
                _HeaderIcon(icon: Icons.favorite_border_rounded, onTap: () => context.push('/wishlist')),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _HeaderIcon(icon: Icons.shopping_bag_outlined, onTap: () => context.push('/cart')),
                    if (context.watch<CartProvider>().itemCount > 0)
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.softShadow,
                          ),
                          child: Text(
                            '${context.watch<CartProvider>().itemCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              itemCount: _banners.length,
              itemBuilder: (_, i) {
                final b = _banners[i];
                final url = buildImageUrl(b.image);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppTheme.space2,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.radiusLarge,
                    boxShadow: AppColors.elevatedShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: AppTheme.radiusLarge,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                        child: const Center(child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2)),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                        child: const Icon(Icons.image, size: 56, color: Colors.white70),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: AppTheme.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _bannerIndex == i ? 20 : 8,
                height: 8,
                    decoration: BoxDecoration(
                      gradient: _bannerIndex == i ? AppColors.accentGradient : null,
                    color: _bannerIndex == i ? null : AppColors.mauve.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          SizedBox(height: AppTheme.space4),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitleContent(context, 'الفئات'),
            SizedBox(height: AppTheme.space3),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final c = _categories[i];
                  return Padding(
                    padding: EdgeInsets.only(left: AppTheme.space3),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/products?category_id=${c.id}&name=${Uri.encodeComponent(c.nameAr)}'),
                        borderRadius: AppTheme.radiusMedium,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [AppColors.cardBackground, AppColors.pearl],
                                ),
                                borderRadius: AppTheme.radiusMedium,
                                boxShadow: AppColors.cardShadow,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: c.image != null && c.image!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: buildImageUrl(c.image),
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Icon(getCategoryIcon(c.icon), color: AppColors.roseGold, size: 36),
                                      errorWidget: (_, __, ___) => Icon(getCategoryIcon(c.icon), color: AppColors.roseGold, size: 36),
                                    )
                                  : Icon(getCategoryIcon(c.icon), color: AppColors.roseGold, size: 36),
                            ),
                            SizedBox(height: AppTheme.space1),
                            SizedBox(
                              width: 80,
                              child: Text(
                                c.nameAr,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppTheme.space5),
          ],
        ),
      ),
    );
  }

  Widget _buildBrands(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitleContent(context, 'البراندات'),
            SizedBox(height: AppTheme.space3),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _brands.length,
                itemBuilder: (_, i) {
                  final b = _brands[i];
                  return Padding(
                    padding: EdgeInsets.only(left: AppTheme.space3),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/products?brand_id=${b.id}&name=${Uri.encodeComponent(b.nameAr)}'),
                        borderRadius: AppTheme.radiusMedium,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppTheme.radiusMedium,
                            boxShadow: AppColors.cardShadow,
                          ),
                          alignment: Alignment.center,
                          child: Text(b.nameAr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppTheme.space5),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleContent(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.roseGoldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppTheme.space2),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: _buildSectionTitleContent(context, title),
    );
  }

  Widget _buildProductList(BuildContext context, List<ProductModel> products) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space3),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (_, i) {
            return Padding(
              padding: EdgeInsets.only(left: AppTheme.space3),
                  child: ProductCard(
                product: products[i],
                onTap: () => context.push('/products/${products[i].slug}'),
                onAddCart: products[i].hasColors
                    ? () => context.push('/products/${products[i].slug}')
                    : () => context.read<CartProvider>().add(products[i]),
                onWishlist: () => context.read<WishlistProvider>().toggle(products[i].id),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.space5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/products'),
            borderRadius: AppTheme.radiusMedium,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppTheme.space4),
                decoration: BoxDecoration(
                  borderRadius: AppTheme.radiusMedium,
                  border: Border.all(color: AppColors.roseGold, width: 2),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'عرض كل المنتجات',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.roseGold,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(width: AppTheme.space2),
                  Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.roseGold),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 72, color: AppColors.mauve.withValues(alpha: 0.5)),
          SizedBox(height: AppTheme.space4),
          Text(_error!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: AppTheme.space4),
          TextButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final loc = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    final isHome = loc == '/home' || loc == '/' || loc.isEmpty;

    return ColoredBox(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(AppTheme.space4, 0, AppTheme.space4, AppTheme.space3),
        child: SafeArea(
          top: false,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardBackground,
                  AppColors.cream,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.roseGold.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  iconFilled: Icons.home_rounded,
                  label: 'الرئيسية',
                  isSelected: isHome,
                  onTap: () => context.go('/home'),
                ),
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  iconFilled: Icons.grid_view_rounded,
                  label: 'المنتجات',
                  isSelected: loc.startsWith('/products'),
                  onTap: () => context.push('/products'),
                ),
                _NavItem(
                  icon: Icons.receipt_long_outlined,
                  iconFilled: Icons.receipt_long_rounded,
                  label: 'تتبع الطلب',
                  isSelected: loc.startsWith('/order-tracking') || loc.startsWith('/order-detail'),
                  onTap: () => context.push('/order-tracking'),
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  iconFilled: Icons.settings_rounded,
                  label: 'الإعدادات',
                  isSelected: loc == '/settings',
                  onTap: () => context.push('/settings'),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 26, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconFilled;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconFilled,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.radiusSmall,
          splashColor: AppColors.roseGold.withValues(alpha: 0.12),
          highlightColor: AppColors.roseGold.withValues(alpha: 0.06),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: AppTheme.space1),
            padding: EdgeInsets.symmetric(vertical: AppTheme.space2),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.roseGold.withValues(alpha: 0.14),
                        AppColors.roseGold.withValues(alpha: 0.06),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? iconFilled : icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected ? AppColors.roseGold : AppColors.textMuted,
                  ),
                ),
                SizedBox(height: AppTheme.space1),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: isSelected ? AppColors.roseGold : AppColors.textMuted,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.stone,
      highlightColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppTheme.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radiusLarge)),
            SizedBox(height: AppTheme.space5),
            Row(children: [
              Container(height: 20, width: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
              SizedBox(width: AppTheme.space2),
              Container(height: 24, width: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
            ]),
            SizedBox(height: AppTheme.space4),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.only(left: AppTheme.space3),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppTheme.space5),
            Row(children: [
              Container(height: 20, width: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
              SizedBox(width: AppTheme.space2),
              Container(height: 24, width: 130, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
            ]),
            SizedBox(height: AppTheme.space4),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.only(left: AppTheme.space3),
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
