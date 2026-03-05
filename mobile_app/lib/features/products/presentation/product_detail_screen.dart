import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/widgets/animated_primary_button.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/core/utils/image_url.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/data/repositories/product_repository.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/features/wishlist/presentation/wishlist_provider.dart';
import 'package:cosmatic_app/features/widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _repo = ProductRepository();
  final _imagePageController = PageController();
  ProductModel? _product;
  List<ProductModel> _related = [];
  bool _loading = true;
  int _imageIndex = 0;
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _repo.getBySlug(widget.slug);
      setState(() {
        _product = res.product;
        _related = res.related;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  static String _imageUrl(String? path) => buildImageUrl(path);

  static Color _parseHexColor(String hex) {
    final h = hex.startsWith('#') ? hex : '#$hex';
    if (h.length == 7) {
      return Color(int.parse(h.substring(1), radix: 16) + 0xFF000000);
    }
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
                SizedBox(height: AppTheme.space4),
                Text('جاري التحميل...', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('المنتج')),
        body: Center(child: Text('المنتج غير موجود', style: Theme.of(context).textTheme.bodyLarge)),
      );
    }
    final p = _product!;
    final baseImages = p.images.isNotEmpty ? p.images : (p.image != null ? [p.image!] : []);
    final selectedColor = p.hasColors && _selectedColorIndex < p.colors.length ? p.colors[_selectedColorIndex] : null;
    final colorImageUrl = selectedColor?.image;
    final displayImages = colorImageUrl != null && colorImageUrl.isNotEmpty
        ? [colorImageUrl, ...baseImages.where((url) => url != colorImageUrl)]
        : baseImages;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              backgroundColor: AppColors.surface,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.glassWhite, shape: BoxShape.circle, boxShadow: AppColors.softShadow),
                  child: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                Consumer<WishlistProvider>(
                  builder: (_, wish, __) {
                    final inWish = wish.has(p.id);
                    return IconButton(
                      icon: Icon(inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: inWish ? Colors.red : AppColors.textPrimary),
                      onPressed: () async {
                        if (inWish) {
                          await wish.remove(p.id);
                        } else {
                          await wish.add(p.id);
                        }
                      },
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: displayImages.isEmpty
                    ? Container(decoration: const BoxDecoration(gradient: AppColors.premiumAccent))
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            controller: _imagePageController,
                            itemCount: displayImages.length,
                            onPageChanged: (i) => setState(() => _imageIndex = i),
                            itemBuilder: (_, i) {
                              final url = _imageUrl(displayImages[i]);
                              return url.isEmpty
                                  ? Container(decoration: const BoxDecoration(gradient: AppColors.premiumAccent))
                                  : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
                            },
                          ),
                          if (displayImages.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(displayImages.length, (i) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: _imageIndex == i ? 24 : 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: _imageIndex == i ? AppColors.accentGradient : null,
                                      color: _imageIndex == i ? null : Colors.white.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  );
                                }),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      p.nameAr,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: AppTheme.space3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatIQD(p.finalPrice),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w900),
                        ),
                        if (p.discountPercent > 0) ...[
                          SizedBox(width: AppTheme.space3),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppTheme.space2, vertical: AppTheme.space1),
                            decoration: BoxDecoration(
                              gradient: AppColors.blushGradient,
                              borderRadius: AppTheme.radiusSmall,
                            ),
                            child: Text('${p.discountPercent}% خصم', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(width: AppTheme.space2),
                          Text(
                            formatIQD(p.price),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.textMuted),
                          ),
                        ],
                      ],
                    ),
                    if (p.descriptionAr != null && p.descriptionAr!.isNotEmpty) ...[
                      SizedBox(height: AppTheme.space4),
                      Text(p.descriptionAr!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                    ],
                    if (p.hasColors) ...[
                      SizedBox(height: AppTheme.space4),
                      Text('اختر اللون', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: AppTheme.space2),
                      Wrap(
                        spacing: AppTheme.space2,
                        runSpacing: AppTheme.space2,
                        children: List.generate(p.colors.length, (i) {
                          final c = p.colors[i];
                          final isSelected = _selectedColorIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColorIndex = i;
                                if (c.image != null && c.image!.isNotEmpty) {
                                  _imageIndex = 0;
                                  _imagePageController.jumpToPage(0);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: AppTheme.space3, vertical: AppTheme.space2),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.roseGold.withValues(alpha: 0.2) : AppColors.linen,
                                borderRadius: AppTheme.radiusSmall,
                                border: Border.all(
                                  color: isSelected ? AppColors.roseGold : AppColors.stone,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (c.hexCode != null && c.hexCode!.isNotEmpty)
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: EdgeInsets.only(left: AppTheme.space1),
                                      decoration: BoxDecoration(
                                        color: _parseHexColor(c.hexCode!),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.textMuted, width: 1),
                                      ),
                                    ),
                                  Text(c.nameAr, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                    SizedBox(height: AppTheme.space3),
                    Row(
                      children: [
                        Icon(
                          p.inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          size: 22,
                          color: p.inStock ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: AppTheme.space1),
                        Text(p.inStock ? 'متوفر في المخزون' : 'غير متوفر', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: p.inStock ? Colors.green : Colors.red)),
                      ],
                    ),
                    SizedBox(height: AppTheme.space5),
                    AnimatedPrimaryButton(
                      label: p.inStock ? 'أضف إلى السلة' : 'غير متوفر',
                      onPressed: p.inStock
                          ? () {
                              final color = p.hasColors ? p.colors[_selectedColorIndex] : null;
                              context.read<CartProvider>().add(p, selectedColor: color);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), SizedBox(width: AppTheme.space2), const Text('تمت الإضافة إلى السلة')]),
                                  backgroundColor: AppColors.gold,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusSmall),
                                ),
                              );
                            }
                          : null,
                      icon: Icons.shopping_bag_rounded,
                    ),
                    if (_related.isNotEmpty) ...[
                      SizedBox(height: AppTheme.space6),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(2)),
                          ),
                          SizedBox(width: AppTheme.space2),
                          Text('منتجات ذات صلة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                      SizedBox(height: AppTheme.space4),
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _related.length,
                          itemBuilder: (_, i) {
                            final r = _related[i];
                            return Padding(
                              padding: EdgeInsets.only(left: AppTheme.space3),
                              child: ProductCard(
                                product: r,
                                onTap: () => context.pushReplacement('/products/${r.slug}'),
                                onAddCart: r.hasColors
                                    ? () => context.push('/products/${r.slug}')
                                    : () => context.read<CartProvider>().add(r),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
